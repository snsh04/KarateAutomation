Feature: This feature tests the Mutual SSL hand shake 

Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }

#----------------------**** MUTUAL SSL ****----------------------------------#
@All @parallel=false  @MutualSSL
Scenario Outline: Validate Mutual SSL via gateway for unauthenticated API with /mssl/api
# Register API
Given url Admin
* json myReq = read('Swagger-MutualSSL.json')
* set myReq.swagger.host = <ProdURL>
* def name = '1-' + now()
* def title = <title> + name
* set myReq.swagger.info.title = title
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
And request myReq
When method post
* retry until responseStatus == 200 

# Declaration of variables 
* def domain = <domain>
* def basepath = <basepath>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>


# Wait for 5 secs after registration
* call read('classpath:examples/Polling/Polling.feature') 

# Get API ID from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

# Invoke API through random External Gateway
* def responseFromrandomExternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' ,'requestMethod': 'get' }
* print ' response from random external gateway' , responseFromrandomExternalWSO2Gateway.responseHeaders
* match responseFromrandomExternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Invoke API through random Internal Gateway
* def responseFromrandomInternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' ,'requestMethod': 'get'  }
* print ' response from random internal gateway' , responseFromrandomInternalWSO2Gateway.responseHeaders
* match responseFromrandomInternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Invoke API through JetStar External Gateway
* def responseFromJetStarExternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'requestMethod': 'get' }
* print ' response from JetStar external gateway' , responseFromJetStarExternalWSO2Gateway.responseHeaders
* match responseFromJetStarExternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Invoke API through JetStar Internal Gateway
* def responseFromJetStarInternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' , 'requestMethod': 'get' }
* print ' response from JetStar internal gateway' , responseFromJetStarInternalWSO2Gateway.responseHeaders
* match responseFromJetStarInternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Delete API 
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:
|title                      |path          |basepath                |domain   |ProdURL                                                               |internalGatewayResponse|externalGatewayResponse|
|'Regtest_mapi'             |'v1/countries'|'countryMSSLAPI'        |'partner'|'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/mssl/api'    |200                    |200                    |
#|'Regtest_mapiWrongPath'    |'v1/countries'|'countryMSSLAPIWRONG'   |'car'    |'demo.master.dev.a878.02-ams10-nonp.cloud.random.com/mssl/api'    |500                     |500                  |

@All @parallel=false  @MutualSSL
Scenario Outline: Validate Mutual SSL via gateway for unauthenticated API with /mssl/secure
# Register API
Given url Admin
* json myReq = read('Swagger-MutualSSLSecure.json')
* set myReq.swagger.host = <ProdURL>
* set myReq.swagger.info.title = <title>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
And request myReq
When method post
* retry until responseStatus == 200

# Declaration of variables 
* def domain = <domain>
* def basepath = <basepath>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def title = <title>

# Wait for 5 secs after registration
* call read('classpath:examples/Polling/Polling.feature') 

# Get API ID from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

# update API definition in publisher with secure credentials 
Given url PublisherURL
And path APIIDPub
* def auth = callonce read('classpath:examples/Tokens/CreateToken.feature') {'createAccessToken': 'createAccessToken'  } 
* print 'auth token for large swagger' , auth.createAccessToken
And  header Authorization = auth.createAccessToken
* json myReq = read('Swagger-updateSecurityForMSSL.json')
And request myReq
When method put
Then status 200

# Invoke API through random External Gateway
* def responseFromrandomExternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' ,'requestMethod': 'get' }
* print ' response from random external gateway' , responseFromrandomExternalWSO2Gateway.responseHeaders
* match responseFromrandomExternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Invoke API through random Internal Gateway
* def responseFromrandomInternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' ,'requestMethod': 'get'  }
* print ' response from random internal gateway' , responseFromrandomInternalWSO2Gateway.responseHeaders
* match responseFromrandomInternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Invoke API through JetStar External Gateway
* def responseFromJetStarIExternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'requestMethod': 'get' }
* print ' response from JetStar external gateway' , responseFromJetStarIExternalWSO2Gateway.responseHeaders
* match responseFromJetStarIExternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Invoke API through JetStar Internal Gateway
* def responseFromJetStarInternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' , 'requestMethod': 'get' }
* print ' response from JetStar internal gateway' , responseFromJetStarInternalWSO2Gateway.responseHeaders
* match responseFromJetStarInternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Delete API 
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:
|title             |path          |basepath         |domain   |ProdURL                                                               |internalGatewayResponse|externalGatewayResponse|
|'Regtest_MSecure' |'v1/countries'|'countryMSSL'    |'event'  |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/mssl'        |200                    |200                    | 

@All @parallel=false  @MutualSSL @HSTS
Scenario Outline: Validate Mutual SSL via NGINX for unauthenticated API with /mssl/api
# Register API
Given url Admin
* json myReq = read('Swagger-MutualSSL.json')
* set myReq.swagger.host = <ProdURL>
* def name = '1-' + now()
* def title = <title> + name
* set myReq.swagger.info.title = title
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
And request myReq
When method post
* retry until responseStatus == 200

# Declaration of variables 
* def domain = <domain>
* def basepath = <basepath>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>


# Wait for 5 secs after registration
* call read('classpath:examples/Polling/Polling.feature') 

# Get API ID from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

# Invoke API through random  External Gateway
* def responseFromNGINXrandomExternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' ,'requestMethod': 'get' }
* print ' response from random external NGINX' , responseFromNGINXrandomExternalWSO2Gateway.responseHeaders
* match responseFromNGINXrandomExternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'
* match responseFromNGINXrandomExternalWSO2Gateway.responseHeaders.Strict-Transport-Security[0] == '#present'


# Invoke API through random Internal Gateway
* def responseFromNGINXrandomInternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' ,'requestMethod': 'get'  }
* print ' response from random internal gateway' , responseFromNGINXrandomInternalWSO2Gateway.responseHeaders
* match responseFromNGINXrandomInternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'
* match responseFromNGINXrandomInternalWSO2Gateway.responseHeaders.Strict-Transport-Security[0] contains '#present'


# Invoke API through JetStar External Gateway
* def responseFromJetStarNGINXExternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarNGINXExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'requestMethod': 'get' }
* print ' response from JetStar external gateway' , responseFromJetStarNGINXExternalWSO2Gateway.responseHeaders
* match responseFromJetStarNGINXExternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'
* match responseFromJetStarNGINXExternalWSO2Gateway.responseHeaders.Strict-Transport-Security[0] contains '#present'


# Invoke API through JetStar Internal Gateway
* def responseFromJetStarNGINXInternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarNGINXInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' , 'requestMethod': 'get' }
* print ' response from JetStar internal gateway' , responseFromJetStarNGINXInternalWSO2Gateway.responseHeaders
* match responseFromJetStarNGINXInternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'
* match responseFromJetStarNGINXInternalWSO2Gateway.responseHeaders.Strict-Transport-Security[0] contains '#present'


# Delete API 
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:
|title             |path          |basepath                |domain   |ProdURL                                                               |internalGatewayResponse|externalGatewayResponse|
|'Regtest_mapiNGINX'    |'v1/countries'|'countryMSSLAPINGINX'   |'car'|'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/mssl/api'    |200                    |200                    |
#|'Regtest_MInvalid'|'v1/countries'|'countryMSSL'      |'car'    |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/mssl'        |404                    |404                    |

@All @parallel=false  @MutualSSL
Scenario Outline: Validate Mutual SSL via NGINX for unauthenticated API with /mssl/secure
# Register API
Given url Admin
* json myReq = read('Swagger-MutualSSLSecure.json')
* set myReq.swagger.host = <ProdURL>
* set myReq.swagger.info.title = <title>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
And request myReq
When method post
* retry until responseStatus == 200

# Declaration of variables 
* def domain = <domain>
* def basepath = <basepath>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def title = <title>

# Wait for 5 secs after registration
* call read('classpath:examples/Polling/Polling.feature') 

# Get API ID from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

# update API definition in publisher with secure credentials 
Given url PublisherURL
And path APIIDPub
* def auth = callonce read('classpath:examples/Tokens/CreateToken.feature') {'createAccessToken': 'createAccessToken'  } 
* print 'auth token for large swagger' , auth.createAccessToken
And  header Authorization = auth.createAccessToken
* json myReq = read('Swagger-updateSecurityForMSSL.json')
And request myReq
When method put
Then status 200

# Invoke API through random  External Gateway
* def responseFromNGINXrandomExternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' ,'requestMethod': 'get' }
* print ' response from random external NGINX' , responseFromNGINXrandomExternalWSO2Gateway.responseHeaders
* match responseFromNGINXrandomExternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Invoke API through random Internal Gateway
* def responseFromNGINXrandomInternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' ,'requestMethod': 'get'  }
* print ' response from random internal gateway' , responseFromNGINXrandomInternalWSO2Gateway.responseHeaders
* match responseFromNGINXrandomInternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Invoke API through JetStar External Gateway
* def responseFromJetStarNGINXExternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarNGINXExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'requestMethod': 'get' }
* print ' response from JetStar external gateway' , responseFromJetStarNGINXExternalWSO2Gateway.responseHeaders
* match responseFromJetStarNGINXExternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Invoke API through JetStar Internal Gateway
* def responseFromJetStarNGINXInternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarNGINXInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' , 'requestMethod': 'get' }
* print ' response from JetStar internal gateway' , responseFromJetStarNGINXInternalWSO2Gateway.responseHeaders
* match responseFromJetStarNGINXInternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Delete API 
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:
|title             |path                  |basepath           |domain   |ProdURL                                                               |internalGatewayResponse|externalGatewayResponse|
|'Regtest_MSecure' |'v1/countries'        |'countryMSSL'      |'event'  |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/mssl'        |200                    |200                    | 

 @parallel=false  @MutualSSL
Scenario Outline: Validate Mutual SSL for authenticated API with /mssl/api
# Register API
Given url Admin
* json myReq = read('Swagger-MutualSSL.json')
* set myReq.swagger.host = <ProdURL>
* def name = '1-' + now()
* def title = <title> + name
* set myReq.swagger.info.title = title
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
And request myReq
When method post
* retry until responseStatus == 200

# Declaration of variables 
* def domain = <domain>
* def basepath = <basepath>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>


# Wait for 5 secs after registration
* call read('classpath:examples/Polling/Polling.feature') 

# Get API ID from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

## Subscribe
# Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

# Create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
* def applicationID = applicationDetails.response.applicationId

# Generate keys
* def applicationKeyDetails = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforProd = 'Bearer '+ applicationKeyDetails.response.token.accessToken

# Subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
* def subscriptionId = subscriptionDetails.response.subscriptionId

# Invoke API through random External Gateway
#Invoke API through External Gateway
* def responseFromAuthenticatedrandomExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProd)' }
* print ' response from random external gateway' , responseFromAuthenticatedrandomExternalWSO2Gateway.responseHeaders
* match responseFromAuthenticatedrandomExternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Invoke API through random Internal Gateway
* def responseFromAuthenticatedrandomInternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProd)' }
* print ' response from random internal gateway' , responseFromAuthenticatedrandomInternalWSO2Gateway.responseHeaders
* match responseFromAuthenticatedrandomInternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

#Invoke API through JetStar External Gateway
* def responseFromAuthenticatedJetStarExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProd)' }
* print ' response from random external gateway' , responseFromAuthenticatedJetStarExternalWSO2Gateway.responseHeaders
* match responseFromAuthenticatedJetStarExternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Invoke API through JetStar Internal Gateway
* def responseFromAuthenticatedJetStarInternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProd)' }
* print ' response from random internal gateway' , responseFromAuthenticatedJetStarInternalWSO2Gateway.responseHeaders
* match responseFromAuthenticatedJetStarInternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'


# Delete API 
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:
|title                 |path          |basepath           |domain   |ProdURL                                                               |internalGatewayResponse|externalGatewayResponse|
|'Regtest_mAuth'    |'v1/countries'|'countryMAuth'   |'notification'|'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/mssl/api'    |200                    |200                    |
#|'Regtest_MInvalid'|'v1/countries'|'countryMSSL'      |'car'    |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/mssl'        |404                    |404                    |

@All @parallel=false  @MutualSSL
Scenario Outline: Validate Mutual SSL for authenticated API with /mssl/secure
# Register API
Given url Admin
* json myReq = read('Swagger-MutualSSLSecure.json')
* set myReq.swagger.host = <ProdURL>
* set myReq.swagger.info.title = <title>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
And request myReq
When method post
* retry until responseStatus == 200

# Declaration of variables 
* def domain = <domain>
* def basepath = <basepath>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def title = <title>

# Wait for 5 secs after registration
* call read('classpath:examples/Polling/Polling.feature') 

# Get API ID from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

# update API definition in publisher with secure credentials 
Given url PublisherURL
And path APIIDPub
* def auth = callonce read('classpath:examples/Tokens/CreateToken.feature') {'createAccessToken': 'createAccessToken'  } 
* print 'auth token for large swagger' , auth.createAccessToken
And  header Authorization = auth.createAccessToken
* json myReq = read('Swagger-updateSecurityForMSSL.json')
And request myReq
When method put
Then status 200

## Subscribe
# Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

# Create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
* def applicationID = applicationDetails.response.applicationId

# Generate keys
* def applicationKeyDetails = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforProd = 'Bearer '+ applicationKeyDetails.response.token.accessToken

# Subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
* def subscriptionId = subscriptionDetails.response.subscriptionId

# Invoke API through random External Gateway
#Invoke API through External Gateway
* def responseFromAuthenticatedrandomExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProd)' }
* print ' response from random external gateway' , responseFromAuthenticatedrandomExternalWSO2Gateway.responseHeaders
* match responseFromAuthenticatedrandomExternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Invoke API through random Internal Gateway
* def responseFromAuthenticatedrandomInternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProd)' }
* print ' response from random internal gateway' , responseFromAuthenticatedrandomInternalWSO2Gateway.responseHeaders
* match responseFromAuthenticatedrandomInternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

#Invoke API through JetStar External Gateway
* def responseFromAuthenticatedJetStarExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProd)' }
* print ' response from random external gateway' , responseFromAuthenticatedJetStarExternalWSO2Gateway.responseHeaders
* match responseFromAuthenticatedJetStarExternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Invoke API through JetStar Internal Gateway
* def responseFromAuthenticatedJetStarInternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProd)' }
* print ' response from random internal gateway' , responseFromAuthenticatedJetStarInternalWSO2Gateway.responseHeaders
* match responseFromAuthenticatedJetStarInternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Delete API 
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:
|title             |path                  |basepath           |domain   |ProdURL                                                               |internalGatewayResponse|externalGatewayResponse|
|'Regtest_MSecure' |'v1/countries'        |'countryMSSL'      |'event'  |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/mssl'        |200                    |200                    | 

@All @parallel=false  @MutualSSL
Scenario Outline: Validate Mutual SSL via Sandbox for authenticated API with /mssl/api
# Register API
Given url Admin
* json myReq = read('Swagger-MutualSSL.json')
* set myReq.swagger.host = <ProdURL>
* def name = '1-' + now()
* def title = <title> + name
* set myReq.swagger.info.title = title
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
And request myReq
When method post
* retry until responseStatus == 200

# Declaration of variables 
* def domain = <domain>
* def basepath = <basepath>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>


# Wait for 5 secs after registration
* call read('classpath:examples/Polling/Polling.feature') 

# Get API ID from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

## Subscribe
# Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

# Create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
* def applicationID = applicationDetails.response.applicationId

# Generate keys
* def applicationKeyDetails = call read('classpath:examples/Services/GenerateSandboxApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforSandbox = 'Bearer '+ applicationKeyDetails.response.token.accessToken

# Subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
* def subscriptionId = subscriptionDetails.response.subscriptionId

# Invoke API through random External Gateway
#Invoke API through External Gateway
* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProd)' }
* print ' response from random external gateway' , responseFromAuthenticatedExternalWSO2Gateway.responseHeaders
* match responseFromAuthenticatedExternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Invoke API through random Internal Gateway
* def responseFromAuthenticatedInternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProd)' }
* print ' response from random internal gateway' , responseFromAuthenticatedInternalWSO2Gateway.responseHeaders
* match responseFromAuthenticatedInternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

#Invoke API through JetStar External Gateway
* def responseFromAuthenticatedJetStarExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProd)' }
* print ' response from random external gateway' , responseFromAuthenticatedJetStarExternalWSO2Gateway.responseHeaders
* match responseFromAuthenticatedJetStarExternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Invoke API through JetStar Internal Gateway
* def responseFromAuthenticatedJetStarInternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProd)' }
* print ' response from random internal gateway' , responseFromAuthenticatedJetStarInternalWSO2Gateway.responseHeaders
* match responseFromAuthenticatedJetStarInternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Delete API 
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }


Examples:
|title                    |path          |basepath                  |domain   |ProdURL                                                               |internalGatewayResponse|externalGatewayResponse|
|'Regtest_mapiSand'    |'v1/countries'|'countryMSSLAPISand'   |'business'|'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/mssl/api'    |200                    |200                    |
#|'Regtest_MInvalid'|'v1/countries'|'countryMSSL'      |'car'    |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/mssl'        |404                    |404                    |

@All @parallel=false @MutualSSL
Scenario Outline: Validate Mutual SSL via Sandbox for authenticated API with /mssl/secure
# Register API
Given url Admin
* json myReq = read('Swagger-MutualSSLSecure.json')
* set myReq.swagger.host = <ProdURL>
* set myReq.swagger.info.title = <title>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
And request myReq
When method post
* retry until responseStatus == 200

# Declaration of variables 
* def domain = <domain>
* def basepath = <basepath>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def title = <title>

# Wait for 5 secs after registration
* call read('classpath:examples/Polling/Polling.feature') 

# Get API ID from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

# update API definition in publisher with secure credentials 
Given url PublisherURL
And path APIIDPub
* def auth = callonce read('classpath:examples/Tokens/CreateToken.feature') {'createAccessToken': 'createAccessToken'  } 
* print 'auth token for large swagger' , auth.createAccessToken
And  header Authorization = auth.createAccessToken
* json myReq = read('Swagger-updateSecurityForMSSL.json')
And request myReq
When method put
Then status 200

## Subscribe
# Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

# Create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
* def applicationID = applicationDetails.response.applicationId

# Generate keys
* def applicationKeyDetails = call read('classpath:examples/Services/GenerateSandboxApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforSandbox = 'Bearer '+ applicationKeyDetails.response.token.accessToken

# Subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
* def subscriptionId = subscriptionDetails.response.subscriptionId

# Invoke API through random External Gateway
#Invoke API through External Gateway
* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProd)' }
* print ' response from random external gateway' , responseFromAuthenticatedExternalWSO2Gateway.responseHeaders
* match responseFromAuthenticatedExternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Invoke API through random Internal Gateway
* def responseFromAuthenticatedInternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProd)' }
* print ' response from random internal gateway' , responseFromAuthenticatedInternalWSO2Gateway.responseHeaders
* match responseFromAuthenticatedInternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

#Invoke API through JetStar External Gateway
* def responseFromAuthenticatedJetStarExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProd)' }
* print ' response from random external gateway' , responseFromAuthenticatedJetStarExternalWSO2Gateway.responseHeaders
* match responseFromAuthenticatedJetStarExternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Invoke API through JetStar Internal Gateway
* def responseFromAuthenticatedJetStarInternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProd)' }
* print ' response from random internal gateway' , responseFromAuthenticatedJetStarInternalWSO2Gateway.responseHeaders
* match responseFromAuthenticatedJetStarInternalWSO2Gateway.responseHeaders.x-mutualssl[0] == 'true'

# Delete API 
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:
|title             |path                  |basepath           |domain   |ProdURL                                                               |internalGatewayResponse|externalGatewayResponse|
|'Regtest_MSecure' |'v1/countries'        |'countryMSSL'      |'event'  |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/mssl'        |200                    |200                    | 

@All @parallel=false  @MutualSSL 
Scenario Outline: Validate Mutual SSL via gateway for authenticated API with /mssl/api
# Register API
Given url Admin
* json myReq = read('Swagger-MutualSSL.json')
* set myReq.swagger.host = <ProdURL>
* def name = '1-' + now()
* def title = <title> + name
* set myReq.swagger.info.title = title
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
And request myReq
When method post
* retry until responseStatus == 200 

# Declaration of variables 
* def domain = <domain>
* def basepath = <basepath>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>


# Wait for 5 secs after registration
* call read('classpath:examples/Polling/Polling.feature') 

# Get API ID from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

# Invoke API through random External Gateway
* def responseFromrandomExternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' ,'requestMethod': 'get' }
* print ' response from random external gateway' , responseFromrandomExternalWSO2Gateway.responseHeaders
* match responseFromrandomExternalWSO2Gateway.responseHeaders.x-mutualssl[0] == '#notpresent'

# Invoke API through random Internal Gateway
* def responseFromrandomInternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' ,'requestMethod': 'get'  }
* print ' response from random internal gateway' , responseFromrandomInternalWSO2Gateway.responseHeaders
* match responseFromrandomInternalWSO2Gateway.responseHeaders.x-mutualssl[0] == '#notpresent'

# Invoke API through JetStar External Gateway
* def responseFromJetStarExternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'requestMethod': 'get' }
* print ' response from JetStar external gateway' , responseFromJetStarExternalWSO2Gateway.responseHeaders
* match responseFromJetStarExternalWSO2Gateway.responseHeaders.x-mutualssl[0] == '#notpresent'

# Invoke API through JetStar Internal Gateway
* def responseFromJetStarInternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' , 'requestMethod': 'get' }
* print ' response from JetStar internal gateway' , responseFromJetStarInternalWSO2Gateway.responseHeaders
* match responseFromJetStarInternalWSO2Gateway.responseHeaders.x-mutualssl[0] == '#notpresent'

# Delete API 
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:
|title                      |path          |basepath                |domain   |ProdURL                                                               |internalGatewayResponse|externalGatewayResponse|
#|'Regtest_mapiWrongPath'    |'v1/countries'|'countryMSSLAPIWRONG'   |'car'    |'demo.master.dev.a878.02-ams10-nonp.cloud.random.com/mssl/api'    |500                     |500                  |
|'Regtest_mapiWronMSSL'    |'v1/countries'|'countryMSSLAPIG'        |'car'    |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/mssl'        |404                     |404                  |

 @parallel=false 
Scenario Outline: Validate Supported TLS for valid TLS
# Register API
Given url Admin
* json myReq = read('Swagger-MutualSSL.json')
* set myReq.swagger.info.title = <title>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
And request myReq
When method post
* retry until responseStatus == 200 


* def domain = <domain>
* def basepath = <basepath>
* def responseCode = <responseCode>
* def title = <title>

# Get API ID from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

# Enable ssl and force the algorithm to TLSv1.2
* configure ssl = <TLS>

#Invoke API through random  External Gateway
* def responseFromNGINXrandomExternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': 'v1/countries' , 'externalGatewayResponse': '#(responseCode)' ,'requestMethod': 'get' }

#Invoke API through random  Internal Gateway
* def responseFromNGINXrandomInternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': 'v1/countries' , 'internalGatewayResponse': '#(responseCode)' ,'requestMethod': 'get' }

# Invoke API through JetStar External Gateway
* def responseFromJetStarNGINXExternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarNGINXExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': 'v1/countries' , 'externalGatewayResponse': '#(responseCode)' , 'requestMethod': 'get' }

# Invoke API through JetStar Internal Gateway
* def responseFromJetStarNGINXInternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarNGINXInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': 'v1/countries' , 'internalGatewayResponse': '#(responseCode)' , 'requestMethod': 'get' }

# Delete API 
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:
|title          |TLS      |responseCode|domain        |basepath       |
|'Regtest_SSL12'|'tlsv1.2'|200         |'car'         |'countryTLSV12'|
|'Regtest_SSL'  |'tls'    |200         |'customer'    |'countryTLS'   |


  @parallel=false  
Scenario Outline: Validate Supported TLS for invalid TLS
# Register API
Given url Admin
* json myReq = read('Swagger-MutualSSL.json')
* set myReq.swagger.info.title = <title>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
And request myReq
When method post
* retry until responseStatus == 200 
* def domain = <domain>
* def basepath = <basepath>
#* def responseCode = <responseCode>
* def title = <title>

# Get API ID from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

# Enable ssl and force the algorithm to TLSv1.2
* configure ssl = <TLS>

## Invoke API through random Internal and External NGINX

* eval try { karate.call('NGINXExternal.feature') } catch(e) { karate.log('failed:', e) } karate.abort()
* eval try { karate.call('NGINXInternal.feature') } catch(e) { karate.log('failed:', e) } karate.abort()

# Delete API 
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:
|title          |TLS      |responseCode|domain        |basepath       |
|'Regtest_SSL11'|'tlsv1.1'|-           |'event'       |'countryTLSV11'|
|'Regtest_SSL10'|'tlsv1'  |-           |'flight'      |'countryTLSV10'|
|'Regtest_SSL'  |'tlsv1.3'|-           |'notification'|'countryTLS13'   |
#------------------------------------------------ **** END **** --------------------------------------------------#