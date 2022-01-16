
param baseName string
param location string

// server
resource dbServer 'Microsoft.Sql/servers@2021-05-01-preview' = {
  name: 'sqlserver-${baseName}'
  location: location
  properties: {
    administratorLogin: 'azureuser'
    administratorLoginPassword: 'TempPassword011!!X980'
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
