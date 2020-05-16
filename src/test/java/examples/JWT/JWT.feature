Feature: This feature tests the JWT tokens 

Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }

#----------------------**** JWT ****----------------------------------#
 @parallel=false @JWT
Scenario: Register an API and test the creation of JWT tokens
# Register API
#Given url Admin
#* json myReq = read('Swagger-JWT.json')
#* def name = '1-' + now()
#* def title = <title> + name
#* set myReq.swagger.info.title = 'JWT'
#* set myReq.apiConf.domain = 'notification'
#* set myReq.swagger.basePath = 'jwt'
#And request myReq
#When method post
#* retry until responseStatus == 200 


# Wait for 5 secs after registration
#* call read('classpath:examples/Polling/Polling.feature') 


# Get API ID from publisher 
* def APPIDFromPublisherForJWT = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'JWT'  }
* def APIIDPubForJWT = APPIDFromPublisherForJWT.APIIDPub

## Subscribe
# Get the APIID from Store
* def APPIDFromStoreForJWT = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': 'JWT'  }
* def APIIDStrForJWT = APPIDFromStoreForJWT.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APIIDStrForJWT

# Create subscribe token
Given url authURL
And header Authorization = Authorization
And form field grant_type = 'client_credentials'
And form field scope = 'apim:subscribe'
When method post
Then status 200
* def subscribeToken = 'Bearer ' + response.access_token
* print 'SubscriberToken is ', subscribeToken

# Create application
# Create an Application
Given url applicationURL
And path 'applications'
And header Authorization = subscribeToken
* def name = 'JWTApp'
And request {"throttlingTier": "Unlimited","description": "sample app description","name": '#(name)' ,"callbackUrl": "https://oidc-demo-implicit-dev-a878-21-ams10-nonp.cloud.random.com/"}
When method post
Then status 201
* def applicationIDJWT = response.applicationId
* print 'applicationId is ', applicationID
* def applicationName = response.name
* def subscriber = response.subscriber


# Generate keys
* def applicationKeyDetails = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationIDJWT)' }
* def accessTokenforProdForJWT = 'Bearer '+ applicationKeyDetails.response.token.accessToken

# Subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStrForJWT)' , 'applicationID': '#(applicationIDJWT)' }
* def subscriptionIdForJWT = subscriptionDetails.response.subscriptionId
* def tier = subscriptionDetails.response.tier


# Invoke API through External Gateway
* def responseFromAuthenticatedrandomExternalWSO2GatewayForJWT = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomExternalWSO2Gateway.feature') {'domain': 'test' , 'basepath': 'jwt' , 'path': '' , 'externalGatewayResponse': '200' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProdForJWT)' }
* def encodedJWTToken =  responseFromAuthenticatedrandomExternalWSO2GatewayForJWT.response.jwt
* def decodedJWTToken =  responseFromAuthenticatedrandomExternalWSO2GatewayForJWT.response.verified 
* print ' decoded token', decodedJWTToken
* match decodedJWTToken['http://wso2.org/claims/keytype'] == 'PRODUCTION'
* match decodedJWTToken['http://wso2.org/claims/version'] contains 'v1'
* match decodedJWTToken['http://wso2.org/claims/applicationname'] == 'JWTApp'
* match decodedJWTToken['http://wso2.org/claims/enduser'] == 'admin@carbon.super'
* match decodedJWTToken['http://wso2.org/claims/subscriber'] == subscriber
* match decodedJWTToken['http://wso2.org/claims/tier'] == tier

## Invoke API through random Internal Gateway
* def responseFromAuthenticatedrandomInternalWSO2GatewayForJWT = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProdForJWT)' }
* print ' response from random internal gateway' , responseFromAuthenticatedrandomInternalWSO2GatewayForJWT.response.jwt
* def encodedJWTToken =  responseFromAuthenticatedrandomInternalWSO2GatewayForJWT.response.jwt
* def decodedJWTToken =  responseFromAuthenticatedrandomInternalWSO2GatewayForJWT.response.verified 
* print ' decoded token', decodedJWTToken
* match decodedJWTToken['http://wso2.org/claims/keytype'] == 'PRODUCTION'
* match decodedJWTToken['http://wso2.org/claims/version'] == 'v1'
* match decodedJWTToken['http://wso2.org/claims/applicationname'] == 'JWTApp'
* match decodedJWTToken['http://wso2.org/claims/enduser'] == 'admin@carbon.super'
* match decodedJWTToken['http://wso2.org/claims/subscriber'] == subscriber
* match decodedJWTToken['http://wso2.org/claims/tier'] == tier
#
##Invoke API through JetStar External Gateway
* def responseFromAuthenticatedJetStarExternalWSO2GatewayForJWT = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProdForJWT)' }
* print ' response from random external gateway' , responseFromAuthenticatedJetStarExternalWSO2GatewayForJWT.response.jwt
* def encodedJWTToken =  responseFromAuthenticatedJetStarExternalWSO2GatewayForJWT.response.jwt
* def decodedJWTToken =  responseFromAuthenticatedJetStarExternalWSO2GatewayForJWT.response.verified 
* print ' decoded token', decodedJWTToken
* match decodedJWTToken['http://wso2.org/claims/keytype'] == 'PRODUCTION'
* match decodedJWTToken['http://wso2.org/claims/version'] == 'v1'
* match decodedJWTToken['http://wso2.org/claims/applicationname'] == 'JWTApp'
* match decodedJWTToken['http://wso2.org/claims/enduser'] == 'admin@carbon.super'
* match decodedJWTToken['http://wso2.org/claims/subscriber'] == subscriber
* match decodedJWTToken['http://wso2.org/claims/tier'] == tier
#
## Invoke API through JetStar Internal Gateway
* def responseFromAuthenticatedJetStarInternalWSO2GatewayForJWT = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforProdForJWT)' }
* print ' response from random internal gateway' , responseFromAuthenticatedJetStarInternalWSO2GatewayForJWT.response.jwt
* def encodedJWTToken =  responseFromAuthenticatedJetStarInternalWSO2GatewayForJWT.response.jwt
* def decodedJWTToken =  responseFromAuthenticatedJetStarInternalWSO2GatewayForJWT.response.verified 
* print ' decoded token', decodedJWTToken
* match decodedJWTToken['http://wso2.org/claims/keytype'] == 'PRODUCTION'
* match decodedJWTToken['http://wso2.org/claims/version'] == 'v1'
* match decodedJWTToken['http://wso2.org/claims/applicationname'] == 'JWTApp'
* match decodedJWTToken['http://wso2.org/claims/enduser'] == 'admin@carbon.super'
* match decodedJWTToken['http://wso2.org/claims/subscriber'] == subscriber
* match decodedJWTToken['http://wso2.org/claims/tier'] == tier


# Delete API 
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationIDJWT)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPubForJWT)'  }

#Examples:
#|title            |path          |basepath           |domain   |ProdURL                                                                   |internalGatewayResponse|externalGatewayResponse|
#|'Regtest_JavaWbToken'    |'/'    |'jwt'              |'notification'      |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api'    |200                    |200                    |

  @parallel=false  
Scenario Outline: test JWT for production
Given url Admin
* json myReq = read('Swagger-JWT.json')
* set myReq.swagger.host = <ProdURL>
#* def name = '1-' + now()
#* def title = <title> + name
* set myReq.swagger.info.title = <title>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
And request myReq
When method post
* retry until responseStatus == 200 

# Declaration of variables 
* def domain = <domain>
* def basepath = <basepath>
* def path = <path>


# Go to store and fetch the jwt token
* def utils = Java.type('examples.JWT.VerifyJWTToken')
* json responseJWT = utils.main()
* def JWT = responseJWT.jwt
* def verified = responseJWT.verified
* print ' token from UI ', responseJWT.jwt
* print ' verification from UI ', responseJWT.verified
* def verified = responseJWT.verified
* match verified['http://wso2.org/claims/username'] == 'user@random.com'
* match verified['http://wso2.org/claims/applicationtier'] == 'Unlimited'
* match verified['http://wso2.org/claims/keytype'] == 'PRODUCTION'
* match verified['http://wso2.org/claims/version'] == 'v1'
* match verified['http://wso2.org/claims/applicationname'] == applicationName
* match verified['http://wso2.org/claims/enduser'] == 'user@random.com@carbon.super'
* match verified['http://wso2.org/claims/subscriber'] == subscriber
* match verified['http://wso2.org/claims/tier'] ==  'Bronze_Auto-Approved'
# extra fields for SSO users
* match verified['http://wso2.org/claims/groups'] == '#notnull'
* match verified['http://wso2.org/claims/fullname'] == 'user'
* match verified['http://wso2.org/claims/emailaddress'] == 'user@random.com'

Examples:
|title            |path          |basepath           |domain   |ProdURL                                                                   |internalGatewayResponse|externalGatewayResponse|
|'Regtest_JWTSSO'    |'v1/poker'|'countryjwt'              |'car'      |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api'    |200                    |200                    |

 @parallel=false 
Scenario Outline: test JWT with password
Given url Admin
* json myReq = read('Swagger-JWT.json')
* set myReq.swagger.host = <ProdURL>
#* def name = '1-' + now()
#* def title = <title> + name
* set myReq.swagger.info.title = <title>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
And request myReq
When method post
* retry until responseStatus == 200 

# Declaration of variables 
* def domain = <domain>
* def basepath = <basepath>
* def path = <path>
* def title = <title>


# Wait for 5 secs after registration
* call read('classpath:examples/Polling/Polling.feature') 


# Get API ID from publisher 
* def APPIDFromPublisherForJWT = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPubForJWT = APPIDFromPublisherForJWT.APIIDPub

# Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

# Create subscribe token
Given url authURL
And header Authorization = Authorization
And form field grant_type = <grantType>
And form field username = <Username>
And form field password = <Password>
And form field scope = 'apim:subscribe'
When method post
Then status 200
* def subscribeToken = 'Bearer ' + response.access_token
* print 'SubscriberToken is ', subscribeToken

* def Username = <Username>
# Create an Application
Given url applicationURL
And path 'applications'
And header Authorization = subscribeToken
* def name = 'JWTApp-' + now()
And request {"throttlingTier": "Unlimited","description": "sample app description","name": '#(name)' ,"callbackUrl": "https://oidc-demo-implicit-dev-a878-21-ams10-nonp.cloud.random.com/"}
When method post
Then status 201
* def applicationID = response.applicationId
* print 'applicationId is ', applicationID
* def applicationName = response.name
* def subscriber = response.subscriber


# Subscribe to an API
Given url applicationURL
And path 'subscriptions'
And header Authorization = subscribeToken
And request {'tier': 'Bronze_Auto-Approved' ,'apiIdentifier': '#(APIIDStr)','applicationId': '#(applicationID)'}
When method post
Then status 201
* def subscriptionId = response.subscriptionId
* print 'subscriptionID is ', subscriptionId 
* def status = response.status
* print 'subscribed with status ', status , ' and subscriptionID ' , subscriptionId  


# Get details of subscription
Given url applicationURL 
And path '/subscriptions/' + subscriptionId
And header Authorization = subscribeToken
When method get
Then status 200
* print 'responseStatus of subscription', response.status , ' for tier' , response.tier

# Generate keys for the application
Given url applicationURL + '/applications/generate-keys?'
And param applicationId = applicationID
And header Authorization = subscribeToken
And request {"validityTime": "3600","keyType": "PRODUCTION","accessAllowDomains": ["password"]}
When method post
Then status 200
* def accessTokenforInvokation = 'Bearer '+ response.token.accessToken
* print 'accessTokenforInvokation is ', accessTokenforInvokation 

# Generate keys for the application for sandbox
Given url applicationURL + '/applications/generate-keys?'
And param applicationId = applicationID
And header Authorization = subscribeToken
And request {"validityTime": "3600","keyType": "SANDBOX","accessAllowDomains": ["password"]}
When method post
Then status 200
* def accessTokenforInvokationSandbox = 'Bearer '+ response.token.accessToken
* print 'accessTokenforInvokation for sandbox is ', accessTokenforInvokationSandbox 


* def responseFromAuthenticatedExternalWSO2GatewaySandbox = call read('classpath:examples/Services/InvokeAuthenticatedSandboxrandomExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '200' , 'requestMethod': 'get' , 'accessTokenforSandbox': '#(accessTokenforInvokationSandbox)' }
* match responseFromAuthenticatedExternalWSO2GatewaySandbox.responseStatus == 200

* print ' JWT token : ', responseFromAuthenticatedExternalWSO2GatewaySandbox.response.jwt
* def JWT = responseFromAuthenticatedExternalWSO2GatewaySandbox.response.jwt
* print ' verified values : ', responseFromAuthenticatedExternalWSO2GatewaySandbox.response.verified
* json verified = responseFromAuthenticatedExternalWSO2GatewaySandbox.response.verified
* match verified['http://wso2.org/claims/applicationtier'] == 'Unlimited'
* match verified['http://wso2.org/claims/keytype'] == 'PRODUCTION'
* match verified['http://wso2.org/claims/version'] == 'v1'
* match verified['http://wso2.org/claims/applicationname'] == applicationName
* match verified['http://wso2.org/claims/enduser'] == 'regtest_buss@random.com@carbon.super'
* match verified['http://wso2.org/claims/subscriber'] == subscriber
* match verified['http://wso2.org/claims/tier'] ==  'Bronze_Auto-Approved'


# Delete Application
Given url applicationURL + '/applications/'
And path applicationID

* header Authorization = subscribeToken
* retry until responseStatus == 200 
When method delete
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPubForJWT)'  }



Examples:
|grantType |Username                    |Password  |title         |path       |basepath|domain        |ProdURL                                                            |internalGatewayResponse|externalGatewayResponse|
|'password'|'regtest_buss@random.com'|'admin'   |'Regtest_JWT' |'v1/poker' |'country3jwt'   |'partner'|'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api'    |200                    |200                    |

 @parallel=false  
Scenario Outline: test JWT with client credentials
Given url Admin
* json myReq = read('Swagger-JWT.json')
* set myReq.swagger.host = <ProdURL>
#* def name = '1-' + now()
#* def title = <title> + name
* set myReq.swagger.info.title = <title>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
And request myReq
When method post
* retry until responseStatus == 200 

# Declaration of variables 
* def domain = <domain>
* def basepath = <basepath>
* def path = <path>
* def title = <title>


# Wait for 5 secs after registration
* call read('classpath:examples/Polling/Polling.feature') 


# Get API ID from publisher 
* def APPIDFromPublisherForJWT = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPubForJWT = APPIDFromPublisherForJWT.APIIDPub

# Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

# Create subscribe token
Given url authURL
And header Authorization = Authorization
And form field grant_type = <grantType>
And form field scope = 'apim:subscribe'
When method post
Then status 200
* def subscribeToken = 'Bearer ' + response.access_token
* print 'SubscriberToken is ', subscribeToken

* def Username = <Username>
# Create an Application
Given url applicationURL
And path 'applications'
And header Authorization = subscribeToken
* def name = 'JWTApp-' + now()
And request {"throttlingTier": "Unlimited","description": "sample app description","name": '#(name)' ,"callbackUrl": "https://oidc-demo-implicit-dev-a878-21-ams10-nonp.cloud.random.com/"}
When method post
Then status 201
* def applicationID = response.applicationId
* print 'applicationId is ', applicationID
* def applicationName = response.name
* def subscriber = response.subscriber


# Subscribe to an API
Given url applicationURL
And path 'subscriptions'
And header Authorization = subscribeToken
And request {'tier': 'Bronze_Auto-Approved' ,'apiIdentifier': '#(APIIDStr)','applicationId': '#(applicationID)'}
When method post
Then status 201
* def subscriptionId = response.subscriptionId
* print 'subscriptionID is ', subscriptionId 
* def status = response.status
* print 'subscribed with status ', status , ' and subscriptionID ' , subscriptionId  


# Get details of subscription
Given url applicationURL 
And path '/subscriptions/' + subscriptionId
And header Authorization = subscribeToken
When method get
Then status 200
* def tier = response.tier
* print 'responseStatus of subscription', response.status , ' for tier' , response.tier

# Generate keys for the application
Given url applicationURL + '/applications/generate-keys?'
And param applicationId = applicationID
And header Authorization = subscribeToken
And request {"validityTime": "3600","keyType": "PRODUCTION","accessAllowDomains": ["client_credentials"]}
When method post
Then status 200
* def accessTokenforInvokation = 'Bearer '+ response.token.accessToken
* print 'accessTokenforInvokation is ', accessTokenforInvokation 

# Generate keys for the application
Given url applicationURL + '/applications/generate-keys?'
And param applicationId = applicationID
And header Authorization = subscribeToken
And request {"validityTime": "3600","keyType": "SANDBOX","accessAllowDomains": ["client_credentials"]}
When method post
Then status 200
* def accessTokenforInvokationSandbox = 'Bearer '+ response.token.accessToken
* print 'accessTokenforInvokation is ', accessTokenforInvokationSandbox

#Invoke API through External Gateway
* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '200' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforInvokation)' }
* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == 200
* print ' JWT token : ', responseFromAuthenticatedExternalWSO2Gateway.response.jwt
* def JWT = responseFromAuthenticatedExternalWSO2Gateway.response.jwt
* print ' verified values : ', responseFromAuthenticatedExternalWSO2Gateway.response.verified
* def verified = responseFromAuthenticatedExternalWSO2Gateway.response.verified

* match verified['http://wso2.org/claims/applicationtier'] == 'Unlimited'

* match verified['http://wso2.org/claims/keytype'] == 'PRODUCTION'
* match verified['http://wso2.org/claims/version'] == 'v1'
* match verified['http://wso2.org/claims/applicationname'] == applicationName
* match verified['http://wso2.org/claims/enduser'] == 'admin@carbon.super'
* match verified['http://wso2.org/claims/subscriber'] == subscriber
* match verified['http://wso2.org/claims/tier'] ==  tier


# Sandbox
* def responseFromAuthenticatedExternalWSO2GatewaySand = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '200' , 'requestMethod': 'get' , 'accessTokenforProd': '#(accessTokenforInvokationSandbox)' }
* match responseFromAuthenticatedExternalWSO2GatewaySand.responseStatus == 200
* print ' JWT token : ', responseFromAuthenticatedExternalWSO2GatewaySand.response.jwt
* def JWT = responseFromAuthenticatedExternalWSO2Gateway.response.jwt
* print ' verified values : ', responseFromAuthenticatedExternalWSO2GatewaySand.response.verified
* def verified = responseFromAuthenticatedExternalWSO2GatewaySand.response.verified
* match verified['http://wso2.org/claims/applicationtier'] == 'Unlimited'

* match verified['http://wso2.org/claims/keytype'] == 'SANDBOX'
* match verified['http://wso2.org/claims/version'] == 'v1'
* match verified['http://wso2.org/claims/applicationname'] == applicationName
* match verified['http://wso2.org/claims/enduser'] == 'admin@carbon.super'
* match verified['http://wso2.org/claims/subscriber'] == subscriber
* match verified['http://wso2.org/claims/tier'] ==  tier



# Delete Application
Given url applicationURL + '/applications/'
And path applicationID

* header Authorization = subscribeToken
* retry until responseStatus == 200 
When method delete
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPubForJWT)'  }



Examples:
|grantType           |Username                    |Password  |title          |path       |basepath|domain   |ProdURL                                                            |internalGatewayResponse|externalGatewayResponse|
|'client_credentials'|'regtest_tech@random.com'|'admin'   |'Regtest_JWT1' |'v1/poker' |'jwt'   |'business'|'demo.soam-960.dev.a878-02.ams10.nonp.cloud.random.com/api'    |200                    |200                    |
#|'SAML2'             |'regtest_tech@random.com'|'admin'   |'Regtest_JWT1' |'v1/poker' |'jwt'   |'partner'|'demo.soam-960.dev.a878-02.ams10.nonp.cloud.random.com/api'    |200                    |200                    |


 @parallel=false 
Scenario: test JWT with Implicit
Given url Admin
* json myReq = read('Swagger-JWT.json')
#* def name = '1-' + now()
#* def title = <title> + name
* set myReq.swagger.info.title = 'Regtest_'
* set myReq.apiConf.domain = 'partner'
* set myReq.swagger.basePath = 'jwt'
And request myReq
When method post
* retry until responseStatus == 200 

* def util = Java.type('examples.JWT.AddApplication')
* def result = util.main()

* def utils = Java.type('examples.JWT.Implicit')
* def responseJWT = utils.main()
* def url = responseJWT






#------------------------------------------------ **** END **** --------------------------------------------------#