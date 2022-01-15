targetScope = 'resourceGroup'

var location = 'eastus'

// create the identity for the application
resource idApplication 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'id-pocapplication'
  location: location
}

// create the key vault
resource kv 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: 'kv-pocapplication2'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    accessPolicies: [
    ]
  }
}

// app configuration
module appConfig 'modules/app-config.bicep' = {
  name: 'appConfigDeploy'
  params: {
    location: location
    configValues: [
      {
        name: 'searchAddress'
        value: 'hhttps://www.bing.com'
      }
    ]
    applicationIdentity: idApplication.properties.principalId
  }
}

// create the application insights reference
resource appi 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-pocapplication'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

// create the app service plan
resource plan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: 'plan-pocapplication'
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

// create the app service
resource app 'Microsoft.Web/sites@2021-02-01' = {
  name: 'app-pocapplication2'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${idApplication.id}': {}     
    }
  }
  properties: {
    serverFarmId: plan.id
    httpsOnly: false
    siteConfig: {
      linuxFxVersion: 'DOTNET|5.0'
      alwaysOn: true
    }
  }
}
