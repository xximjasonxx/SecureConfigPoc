
param name string
param location string
param configValues array

param applicationIdentityPrincipalId string

// create the app configuration service
resource appConfig 'Microsoft.AppConfiguration/configurationStores@2021-03-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'Standard'
  }
  identity: {
    type: 'None'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}

// add values
resource keyValues 'Microsoft.AppConfiguration/configurationStores/keyValues@2021-03-01-preview' = [for config in configValues: {
  parent: appConfig
  name: config.name
  properties: {
    contentType: config.contentType
    value: config.value
    
  }
}]

// assign role
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid('appconfig-pocapplication-role-assignment')
  scope: appConfig
  properties: {
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/516239f1-63e1-4d78-a4de-a74fb236a071'
    principalId: applicationIdentityPrincipalId
  }
}
