
param name string
param location string

// create the identity for the application
resource idApplication 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: name
  location: location
}

// outputs
output principalId string = idApplication.properties.principalId
output resourceId string = idApplication.id
