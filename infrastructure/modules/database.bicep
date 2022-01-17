
param baseName string
param location string

param administratorPassword string
param administratorPrincipalId string

// server
resource dbServer 'Microsoft.Sql/servers@2021-05-01-preview' = {
  name: 'sqlserver-${baseName}'
  location: location
  properties: {
    administratorLogin: 'azureuser'
    administratorLoginPassword: administratorPassword 
  }
}

// database
resource dbDatabase 'Microsoft.Sql/servers/databases@2021-05-01-preview' = {
  name: 'db-${baseName}'
  parent: dbServer
  location: location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    autoPauseDelay: 60
    minCapacity: 1
  }
  sku: {
    name: 'GP_S_Gen5'
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: 1
  }
}

// administrator
resource administrator 'Microsoft.Sql/servers/administrators@2021-05-01-preview' = {
  name: 'ActiveDirectory'
  parent: dbServer
  properties: {
    administratorType: 'ActiveDirectory'
    login: 'appuser'
    sid: administratorPrincipalId
    tenantId: tenant().tenantId
  }
}

// firewall allow azure services
resource fwAzureServiceAllow 'Microsoft.Sql/servers/firewallRules@2021-05-01-preview' = {
  name: 'allow-azure-services'
  parent: dbServer
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

// outputs
output serverFqdn string = dbServer.properties.fullyQualifiedDomainName
output databaseName string = dbDatabase.name
output databaseAdminLogin string = dbServer.properties.administratorLogin
