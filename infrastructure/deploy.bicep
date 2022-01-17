targetScope = 'resourceGroup'

param adminPrinicipalId string

var location = 'eastus'
var suffix = substring(uniqueString('/subscriptions/${subscription().id}/resourceGroups/rg-sandbox2'), 0, 6)
var adminPassword = 'TempPassword011!!X980'  // this is only for demonstration purposes

// create the identity for the application
module identity 'modules/identity.bicep' = {
  name: 'identityDeploy'
  params: {
    name: 'id-pocapplication-${suffix}'
    location: location
  }
}

// database
module database 'modules/database.bicep' = {
  name: 'databaseDeploy'
  params: {
    baseName: 'pocapplication-${suffix}'
    location: location
    administratorPrincipalId: adminPrinicipalId
    administratorPassword: adminPassword
  }
}

// key vault
resource kv 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: 'kv-pocapplication-${suffix}'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    accessPolicies: [
      {
        tenantId: tenant().tenantId
        objectId: identity.outputs.principalId
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
    ]
  }
}

// add our sensitive value
resource secret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: 'sensitiveValue'
  parent: kv
  properties: {
    value: 'thisisaaaaaaasecret'
  }
}

// add the db admin password for reference
resource adminSecret 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name: 'databaseAdminPassword'
  parent: kv
  properties: {
    value: adminPassword
  }
}

// app configuration
module appConfig 'modules/app-config.bicep' = {
  name: 'appConfigDeploy'
  params: {
    name: 'appconfig-pocapplication-${suffix}'
    location: location
    configValues: [
      {
        name: 'searchAddress'
        value: 'hhttps://www.bing.com'
        contentType: 'text/plain'
      }
      {
        name: 'sensitive-value'
        contentType: 'application/vnd.microsoft.appconfig.keyvaultref+json;charset=utf-8'
        value: '{ "uri": "${secret.properties.secretUri}" }'
      }
      {
        name: 'connection-string'
        contentType: 'text/plain'
        value: 'Server=tcp:${database.outputs.serverFqdn};Authentication=Active Directory Managed Identity; User Id=${identity.outputs.principalId}; Database=${database.outputs.databaseName};"'
      }
    ]
    applicationIdentityPrincipalId: identity.outputs.principalId
  }

  dependsOn: [
    identity
  ]
}

module appService 'modules/appService.bicep' = {
  name: 'appServiceDeploy'
  params: {
    baseName: 'pocapplication-${suffix}'
    location: location
    applicationIdentityResourceId: identity.outputs.resourceId
  }

  dependsOn: [
    identity
  ]
}
