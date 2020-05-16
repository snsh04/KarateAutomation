function() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  karate.configure('ssl', true);


  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env,
    Admin: 'https://admin:notrequired@apiadmin.dev.dev.a878-06.ams10.nonp.cloud.random.com/admin/register',
    ApiAdminURL: 'https://admin:notrequired@apiadmin.dev.dev.a878-06.ams10.nonp.cloud.random.com',
    AdminPath: 'gateway/v1/api',
    wso2_username: 'admin',
    wso2_password: 'notrequired',
    apiGatewayKey: 'REGTEST_REGTEST',
    adminAD: 'notrequired',
    pipelineAD: 'notrequired',
    authURL: 'https://auth-dev-dev-a878-13-ams10-nonp.cloud.random.com/oauth2/token',
    Authorization: 'Basic XXXXXXXXX',
    Authorization_APIGWUATSSO: 'Basic XXXXXXXXXX',
    Authorization_APIGWPRODSSO: 'Basic XXXXXXXXX',
    PublisherURL: 'https://publishr-dev-dev-a878-16-ams10-nonp.cloud.random.com/api/am/publisher/v0.14/apis',
    storeURL: 'https://apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com/api/am/store/v0.14/apis',
    applicationURL: 'https://apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com/api/am/store/v0.14',
    internalGateway: 'https://gateway-int-dev-dev-a878-15-ams10-nonp.cloud.random.com',
    jetstarInternalGateway: 'https://gateway-jg-dev-dev-a878-30-ams10-nonp.cloud.random.com',
    gatewayNGINX: 'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com',
    gatewayNGINXAPI: 'https://api-gateway.dev.dev.a878-01.ams10.nonp.cloud.random.com/api',
    jetstarGatewayNGINX: 'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com',
    jetstarGatewayNGINXAPI: 'https://jg-reverse-proxy.dev.dev.a878-31.ams10.nonp.cloud.random.com/api',
    externalGateway: 'https://gateway-dev-dev-a878-15-ams10-nonp.cloud.random.com',
    jetstarExternalGateway: 'https://gateway-jg-dev-dev-a878-30-ams10-nonp.cloud.random.com',
    GatewayManagerURL: 'https://manager-int-dev-dev-a878-15-ams10-nonp.cloud.random.com:443'
  }
  if (env == 'uat') {
  	AdminPassword = 'notrequired';
  	ProxyService = 'apiawsps.uat-26.dev.a878-19.ams10.nonp.cloud.random.com';
  	BPS = 'https://bps-uat-dev-a878-27-ams10-nonp.cloud.random.com/services/HumanTaskClientAPIAdmin/';
  	BPS_PASSWORD = 'notrequired';
    config.Admin = 'https://apiadmin.uat.dev.a878-06.ams10.nonp.cloud.random.com/admin/register';
    config.ApiAdminURL = 'https://apiadmin.uat.dev.a878-06.ams10.nonp.cloud.random.com';
    config.AdminPath = 'gateway/v1/api';
    config.apiGatewayKey = 'REGTEST_REGTEST';
    config thURL = 'https://auth-uat-dev-a878-13-ams10-nonp.cloud.random.com/oauth2/token';
    config thorization = 'Basic xxxxxxxxxxxxxx';
    config.PublisherURL = 'https://publishr-uat-dev-a878-16-ams10-nonp.cloud.random.com/api/am/publisher/v0.14/apis';
    config.storeURL = 'https://apistore-uat-dev-a878-14-ams10-nonp.cloud.random.com/api/am/store/v0.14/apis';
    config.applicationURL = 'https://apistore-uat-dev-a878-14-ams10-nonp.cloud.random.com/api/am/store/v0.14';
    config.internalGateway = 'https://api-stg.random.com';
    config.jetstarInternalGateway = 'https://jg-reverse-proxy.uat.dev.a878-31.ams10.nonp.cloud.random.com';
    config.gatewayNGINX = 'https://api-gateway.uat.dev.a878-01.ams10.nonp.cloud.random.com';
    config.gatewayNGINXAPI = 'https://api-gateway.uat.dev.a878-01.ams10.nonp.cloud.random.com/api';
    config.jetstarGatewayNGINX = 'https://jg-reverse-proxy.uat.dev.a878-31.ams10.nonp.cloud.random.com';
    config.jetstarGatewayNGINXAPI = 'https://jg-reverse-proxy.uat.dev.a878-31.ams10.nonp.cloud.random.com/api';
    config.externalGateway = 'https://api-stage.random.com';
    config.jetstarExternalGateway = 'https://apis-stage.jetstar.com'
  }
  else if (env == 'prod') {
    AdminPassword = 'notrequired';
    ProxyService = 'apiawsps.master.prod.a878-19.ams10.cloud.random.com';
    BPS = 'https://bps-master-prod-a878-27-ams10.cloud.random.com/services/HumanTaskClientAPIAdmin/';
    BPS_PASSWORD = 'notrequired';
    config.Admin = 'https://apiadmin.master.prod.a878-06.ams10.cloud.random.com/admin/register';
    config.ApiAdminURL = 'https://apiadmin.master.prod.a878-06.ams10.cloud.random.com';
    config.AdminPath = 'gateway/v1/api';
    config.apiGatewayKey = 'REGTEST_REGTEST';
    config thURL = 'https://auth-master-prod-a878-13-ams10.cloud.random.com/oauth2/token';
    config thorization = 'Basic xxxxxxxxxxx';
    config.PublisherURL = 'https://publishr-master-prod-a878-16-ams10.cloud.random.com/api/am/publisher/v0.14/apis';
    config.storeURL = 'https://apistore-master-prod-a878-14-ams10.cloud.random.com/api/am/store/v0.14/apis';
    config.applicationURL = 'https://apistore-master-prod-a878-14-ams10.cloud.random.com/api/am/store/v0.14';
    config.internalGateway = 'https://gateway-int-master-prod-a878-15-ams10.cloud.random.com';
    config.jetstarInternalGateway = 'https://jg-reverse-proxy-master-prod-a878-31-ams10.cloud.random.com';
    config.gatewayNGINX = 'https://api-gateway.master.prod.a878-01.ams10.cloud.random.com';
    config.gatewayNGINXAPI = 'https://api-gateway-master-prod-a878-01-ams10.cloud.random.com/api';
    config.jetstarGatewayNGINX = 'https://jg-reverse-proxy-master-prod-a878-31-ams10.cloud.random.com';
    config.jetstarGatewayNGINXAPI = 'https://jg-reverse-proxy-master-prod-a878-31-ams10.cloud.random.com/api';
    config.externalGateway = 'https://gateway-master-prod-a878-15-ams10.cloud.random.com';
    config.jetstarExternalGateway = 'https://gateway-jg-master-prod-a878-30-ams10.cloud.random.com'

  }
  karate.configure('connectTimeout', 180000);
  karate.configure('readTimeout', 180000);
  return config;
}
