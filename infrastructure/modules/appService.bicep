
param baseName string
param location string

param applicationIdentityResourceId string

// create the application insights reference
resource appi 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-${baseName}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

// create the app service plan
resource plan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: 'plan-${baseName}'
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
  name: 'app-${baseName}'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${applicationIdentityResourceId}': {}     
    }
  }
  properties: {
    serverFarmId: plan.id
    httpsOnly: false
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|3.1'
      alwaysOn: true
    }
  }
}
