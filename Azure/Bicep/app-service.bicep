param location string = resourceGroup().location
param appName string = 'kw-demo-001'

@allowed([
  'S1'
  'P1V2'
  'P2V2'
  'P3V2'
  'P1V3'
  'P2V3'
  'P3V3'
])
param appServicePlanSku string

var skuTier = appServicePlanSku == 'S1' ? 'Standard' : 'Premium'
var appServicePlanName = 'plan-${appName}'
var appServicename = 'app-${appName}'
var insightsName = 'appi-${appName}'

resource servicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  location: location
  name: appServicePlanName
  sku: {
    name: appServicePlanSku
    tier: skuTier
    capacity: 1
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource appService 'Microsoft.Web/sites@2021-03-01' = {
  location: location
  name: appServicename
  properties: {
    serverFarmId: servicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|6.0'
      alwaysOn: true
      http20Enabled: true
      healthCheckPath: '/health'
      appSettings: [
        {
          name: 'ASPNETCORE_HTTPS_PORT'
          value: 443
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: insights.properties.InstrumentationKey
        }
      ]   
    }
    clientAffinityEnabled: false
    httpsOnly: true
  }
}

resource insights 'Microsoft.Insights/components@2020-02-02' = {
  name: insightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

output servicePlanId string = servicePlan.id
output appInsightsId string = insights.id
