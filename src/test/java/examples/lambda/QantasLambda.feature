Feature: API Admin - Lambda registration

Background: 
* def now = function(){ return java.lang.System.currentTimeMillis() }
  

@lambda  @parallel=false  @randomlambda
Scenario Outline: Lambda API registration
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = apiGatewayKey
And header apigateway-basepath = 'lambda-migration'
* json myReq = read('swagger-lambda.json')
* set myReq.apiConf.subscriptionTiers = <subscriptionTiers>
* set myReq.swagger.info.title = 'REGTEST_AUTO_Regression_Lambda_Quote_Function'
* set myReq.swagger.basePath = 'lambda-migration'
* set myReq.swagger.info.version = 'v1'
And request myReq
When method post
Then status <responseCode>
* def requestMethod = <method>
* def path = <path>

# Get the APIID from Publisher
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'REGTEST_AUTO_Regression_Lambda_Quote_Function'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher for random Gateway API: ' , APPIDFromPublisher.APIIDPub

# Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': 'REGTEST_AUTO_Regression_Lambda_Quote_Function'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

# Subscribe
# create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
* def applicationID = applicationDetails.response.applicationId

# Generate keys
* def applicationKeyDetails = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforProd = 'Bearer '+ applicationKeyDetails.response.token.accessToken

# Subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
* def subscriptionId = subscriptionDetails.response.subscriptionId

# Invoke API through External Gateway
* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomExternalWSO2Gateway.feature') {'domain': 'aircraft' , 'basepath': 'lambda-migration' , 'path': '#(path)' , 'externalGatewayResponse': '200' , 'method': '#(requestMethod)' , 'accessTokenforProd': '#(accessTokenforProd)' }
* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == 200
 
# Delete the Application and API
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
Examples: 
| subscriptionTiers                            | responseCode | scenario |path   |method|
| [Bronze_Auto-Approved,Gold,Silver] |          200 | Positive |'quote'|'get'|

@lambda  @parallel=false @All @randomlambda
Scenario Outline: Lambda API registration with default single version
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = apiGatewayKey
And header apigateway-basepath = <basepath>
* json myReq = read('swagger-lambda.json')
* set myReq.apiConf.subscriptionTiers = <subscriptionTiers>
* def name = '1-' + now()
* def title = <title> + name
* set myReq.swagger.info.title = title
* set myReq.swagger.basePath = <basepath>
* set myReq.swagger.info.version = 'v1'
* set myReq.apiConf.domain = <domain>
* set myReq.apiConf.defaultVersion = <defaultVersion>
And request myReq
When method post
Then status <responseCode>
* call read('classpath:examples/Polling/Polling.feature') 
* def domain = <domain>
* def basepath = <basepath>
* def requestMethod = <method>
* def path = <path>
* def externalGatewayResponse = <externalGatewayResponse>

# Get the APIID from Publisher
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher for random Gateway API: ' , APPIDFromPublisher.APIIDPub

# Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

# Subscribe
# create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
* def applicationID = applicationDetails.response.applicationId

# Generate keys
* def applicationKeyDetails = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforProd = 'Bearer '+ applicationKeyDetails.response.token.accessToken

# Subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
* def subscriptionId = subscriptionDetails.response.subscriptionId

# Invoke API through External Gateway
* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'method': '#(requestMethod)' , 'accessTokenforProd': '#(accessTokenforProd)' }
* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == <externalGatewayResponse>

# Delete the Application and API
#* call read('Sleep.feature')
* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
Examples: 
|domain    |basepath          |title               | subscriptionTiers                            | responseCode | defaultVersion | externalGatewayResponse | version | path       |method|
|'test'    |'lambda-migration'|'REGTEST_LAMBDADEF1'| [Bronze_Auto-Approved,Gold,Silver,Unlimited] |          200 | false          | 200      | v1      | 'v1/quote' |'get'|
|'partner' |'lambda-resource' |'REGTEST_LAMBDADEF2'| [Bronze_Auto-Approved,Gold,Silver,Unlimited] |          200 | true           | 200      | v1      | 'quote'    |'get'|
|'aircraft'|'lambdaTester'    |'REGTEST_LAMBDADEF3'| [Bronze_Auto-Approved,Gold,Silver,Unlimited] |          200 | false          | 404      | v1      | 'quote'    |'get'|

@lambda  @parallel=false @randomlambda
Scenario Outline: Lambda API registration with multi version
# Register and subscribe first Version
Given url Admin
* json myReq = read('swagger-lambda.json')
* set myReq.apiConf.subscriptionTiers = <subscriptionTiers>
* def title = <title> 
* set myReq.swagger.info.title = title
* set myReq.swagger.basePath = 'lambda-resource1'
* set myReq.swagger.info.version = 'v1'
* set myReq.apiConf.defaultVersion = 'true'
And request myReq
When method post	
Then status <responseCode>
* def requestMethod = <method>
* call read('classpath:examples/Polling/Polling.feature') 

# Get the APIID from Publisher
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher for random Gateway API: ' , APPIDFromPublisher.APIIDPub

# Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

# subscribe
# create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
* def applicationID = applicationDetails.response.applicationId

# generate keys
* def applicationKeyDetails = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforProd = 'Bearer '+ applicationKeyDetails.response.token.accessToken

# subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
* def subscriptionId = subscriptionDetails.response.subscriptionId
* def externalGatewayResponse = <externalGatewayResponse>

# Invoke as v1 Version
# Invoke API through External Gateway
* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomExternalWSO2Gateway.feature') {'domain': 'aircraft' , 'basepath': 'lambda-resource1' , 'path': 'v1/quote' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'method': '#(requestMethod)' , 'accessTokenforProd': '#(accessTokenforProd)' }
* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == 200

# Invoke as Default Version
* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomExternalWSO2Gateway.feature') {'domain': 'aircraft' , 'basepath': 'lambda-resource1' , 'path': 'quote' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'method': '#(requestMethod)' , 'accessTokenforProd': '#(accessTokenforProd)' }
* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == 200
    
* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

# Register Second Version again as default version
Given url Admin
* json myReq = read('swagger-lambda.json')
* set myReq.apiConf.subscriptionTiers = <subscriptionTiers>
* set myReq.swagger.info.title = title
* set myReq.swagger.basePath = 'lambda-resource1'
* set myReq.swagger.info.version = 'v2'
* set myReq.apiConf.defaultVersion = 'true'
And request myReq
When method post
Then status <responseCode>

# Get the APIID from Publisher
* def APPIDFromPublisher2 = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub2 = APPIDFromPublisher2.APIIDPub
* print 'APPIDFromPublisher for random Gateway API2: ' , APPIDFromPublisher2.APIIDPub    
    
# Get the APIID from Store
* def APPIDFromStore2 = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr2 = APPIDFromStore2.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

# subscribe
# create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
* def applicationID = applicationDetails.response.applicationId

# generate keys
* def applicationKeyDetails = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforProd = 'Bearer '+ applicationKeyDetails.response.token.accessToken

# subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr2)' , 'applicationID': '#(applicationID)' }
* def subscriptionId = subscriptionDetails.response.subscriptionId  
    
# Invoke Default Version Again using v1 token
* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomExternalWSO2Gateway.feature') {'domain': 'aircraft' , 'basepath': 'lambda-resource1' , 'path': 'v2/quote' , 'externalGatewayResponse': '200' , 'method': '#(requestMethod)' , 'accessTokenforProd': '#(accessTokenforProd)' }
* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == 200

# Delete the Application and API
#* call read('Sleep.feature')
* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub2)'  }

Examples: 
|title              | subscriptionTiers                            | responseCode |externalGatewayResponse|method|
|'REGTEST_LAMBDAMUL'| [Bronze_Auto-Approved,Gold,Silver,Unlimited] | 200          |200                    |'get'|

@lambda  @parallel=false @All @randomlambda
Scenario Outline: Lambda API registration when ARN is invalid
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = apiGatewayKey
And header apigateway-basepath = <basepath>
* json myReq = read('swagger-lambda.json')
* set myReq.apiConf.subscriptionTiers = <subscriptionTiers>
* def name = '1-' + now()
* def title = <title> + name
* set myReq.swagger.info.title = title
* set myReq.swagger.basePath = <basepath>
* set myReq.swagger.info.version = 'v1'
* set myReq.swagger.x-lambda-arn = <arn>
And request myReq
When method post
Then status <responseCode>
* eval if (responseStatus == 400) karate.abort()
* def requestMethod = <method>
* def path = <path>
* def domain = <domain>
* def basepath = <basepath>

# Get the APIID from Publisher
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher for random Gateway API: ' , APPIDFromPublisher.APIIDPub

# Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

# Subscribe
# Create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
* def applicationID = applicationDetails.response.applicationId

# Generate keys
* def applicationKeyDetails = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforProd = 'Bearer '+ applicationKeyDetails.response.token.accessToken

# Subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
* def subscriptionId = subscriptionDetails.response.subscriptionId

# Invoke API through External Gateway
* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '404' , 'method': '#(requestMethod)' , 'accessTokenforProd': '#(accessTokenforProd)' }
* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == 404
 
# Delete the Application and API
#* call read('Sleep.feature')
* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
Examples: 
|path   |domain    |basepath       |title         | subscriptionTiers                            | arn                                                           | responseCode |method|
|'v1/quote' |'customer' |'lambdaTesting'|'REGTEST_ARNss1'| [Bronze_Auto-Approved,Gold,Silver,Unlimited] | 'bananas'                                                     |          200 |'get'|
|'v1/quote'|'flight'|'lambdaTesting'|'REGTEST_ARNss2'| [Bronze_Auto-Approved,Gold,Silver,Unlimited] | 'arn-aws-lambda-ap-southeast-2-196238444021-function-bananas' |          200 |'get'|


@lambda  @parallel=false @All @randomlambda
Scenario Outline: Lambda API registration with invalid swagger
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = apiGatewayKey
And header apigateway-basepath = 'lambda-migration'
* json myReq = read('<invalidSwagger>.json')
* set myReq.apiConf.subscriptionTiers = <subscriptionTiers>
* set myReq.swagger.info.title = 'REGTEST_AUTO_Regression_Lambda_Quote_Function'
* set myReq.swagger.basePath = 'lambda-migration'
* set myReq.swagger.info.version = 'v1'
And request myReq
When method post
Then status <responseCode>

Examples: 
| subscriptionTiers                            | invalidSwagger                         | responseCode |
| [Bronze_Auto-Approved,Gold,Silver,Unlimited] | swagger-missing-lambda-arn             |          400 |
| [Bronze_Auto-Approved,Gold,Silver,Unlimited] | swagger-lambda-arn-not-under-HTTP-verb |          400 |
| [Bronze_Auto-Approved,Gold,Silver,Unlimited] | swagger-one-x-lambda-arn-missing       |          400 |
| [Bronze_Auto-Approved,Gold,Silver,Unlimited] | swagger-empty-x-lambda-arn             |          400 |

@ResourceValidation 
Scenario Outline: Lambda validation of resource path
Given url Admin
* json myReq = read('swagger-lambdaResource.json')
* set myReq.swagger.info.title = 'REGTEST_Paths'
* set myReq.swagger.basePath = 'lambda-quote'
* set myReq.swagger.info.version = 'v1'
And request myReq
When method post
Then status 200
* def title = 'REGTEST_Paths'
* call read('Lambda-Sleep.feature')
* def responsefromsubscriber = call read('Lambda-APIDefinition.feature') { APIIDPub: '#(APIIDPub)' ,title: '#(title)' }
* def testpath = <testpath>
* def responsefromInvoke = call read('Lambda-InvokeNoAuth.feature') { testpath: '#(testpath)' }
* match responsefromInvoke.InvokeStatus == <responseCode>
    
# Create Token for deletion 
Given url authURL 
And   header Authorization = Authorization 
And   form field grant_type = 'client_credentials' 
And   form field scope = 'apim:api_create' 
When   method post 
Then   status 200 
* def createAccessToken = 'Bearer ' + response.access_token
# Delete API with valid token
Given url PublisherURL + '/' + responsefromsubscriber.APIIDPub
And header Authorization = createAccessToken 
When method delete
Then status 200 

#* call read('Lambda-Delete.feature') 
Examples: 
| responseCode    | testpath                          | 
| 200             | 'test/lambda-quote/v1/quote-1' |
| 200             | 'test/lambda-quote/v1/quote/{quote}' |
| 200             | 'test/lambda-quote/v1/quote/9lB019'|
| 200             | 'test/lambda-quote/v1/'|
    
@lambda  @parallel=false @All @randomlambda
Scenario Outline: Add User Groups in the header using wso2 gateway
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = apiGatewayKey
And header apigateway-basepath = <basepath>
* json myReq = read('swagger-Echo.json')
* set myReq.apiConf.domain = <Domain>
* def name = '1-' + now()
* def title = <title> + name
* set myReq.swagger.info.title = title
* set myReq.swagger.basePath = <basepath>
* set myReq.swagger.info.version = 'v1'
And request myReq
When method post
Then status <InvokeResponseCode>
* call read('classpath:examples/Polling/Polling.feature') 
* eval if (responseStatus == 400) karate.abort()

# Get the APIID from Publisher
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher for random Gateway API: ' , APPIDFromPublisher.APIIDPub

# Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

# Subscribe
# create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
* def applicationID = applicationDetails.response.applicationId

# Generate keys
* def applicationKeyDetails = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforProd = 'Bearer '+ applicationKeyDetails.response.token.accessToken

# Subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
* def subscriptionId = subscriptionDetails.response.subscriptionId
   
* def testpath = <testpath>
* def InvokeResponseCode = <InvokeResponseCode>
* def UserGroup = <UserGroup>
* def flag = <flag>
Given url internalGateway
And path <testpath>
And header Authorization = accessTokenforProd
And header x-include-headers-in-body = <flag>
When method get
* retry until responseStatus = 200
* print 'responseHeaders' , response.headers.user-agent
#* match response.headers.user-agent contains UserGroup
# Delete the Application and API
#* call read('Sleep.feature')
* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples: 
|testpath                             |Domain     |basepath          |title               | InvokeResponseCode  |flag |UserGroup                                   |
|'partner/lambda-migration/v1/test-1' |'partner'  |'lambda-migration'|'REGTEST_UserGroup1'|          200        |true |'Apache-HttpClient/4.5.5 (Java/1.8.0_181)'  |
|'customer/lambda-migration/v1/test-1'|'customer' |'lambda-migration'|'REGTEST_UserGroup2'|          200        |false|null |
  
@lambda  @parallel=false @All @randomlambda
Scenario Outline: Add User Groups in the header using nginx gateway
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = apiGatewayKey
And header apigateway-basepath = <basepath>
* json myReq = read('swagger-Echo.json')
* set myReq.apiConf.domain = <domain>
* def name = '1-' + now()
* def title = <title> + name
* set myReq.swagger.info.title = title
* set myReq.swagger.basePath = <basepath>
* set myReq.swagger.info.version = 'v1'
And request myReq
When method post
Then status <InvokeResponseCode>
* call read('classpath:examples/Polling/Polling.feature') 
* eval if (responseStatus == 400) karate.abort()

# Get the APIID from Publisher
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher for random Gateway API: ' , APPIDFromPublisher.APIIDPub

# Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

# Subscribe
# Create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
* def applicationID = applicationDetails.response.applicationId

# Generate keys
* def applicationKeyDetails = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforProd = 'Bearer '+ applicationKeyDetails.response.token.accessToken

# Subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
* def subscriptionId = subscriptionDetails.response.subscriptionId
* def testpath = <testpath>
* def InvokeResponseCode = <InvokeResponseCode>
* def UserGroup = <UserGroup>
* def flag = <flag>
Given url gatewayNGINX
And path <testpath>
And header Authorization = accessTokenforProd
And header x-include-headers-in-body = <flag>
When method get
* retry until responseStatus = 200
* print 'responseHeaders' , response.headers.user-agent
#* match response.headers.user-agent contains UserGroup
* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
Examples: 
|testpath                              |domain       |basepath            |title               | InvokeResponseCode  |flag |UserGroup                                   |
|'aircraft/lambda-migration/v1/test-1' |'aircraft'   |'lambda-migration'  |'REGTEST_UserGroup3'|          200        |true |'Apache-HttpClient/4.5.5 (Java/1.8.0_181)'  |
|'car/lambda-migration/v1/test-1'      |'car'        |'lambda-migration'  |'REGTEST_UserGroup4'|          200        |false|null |
  
@jsoncheck
Scenario: Check json sent while invokation 
* configure retry = { count: 5 , interval: 5000 }
Given url AdminDev
* json myReq = read('openLambda.json')
* def name = '1-' + now()
* def title = 'Regtest_jsoncheck' + name
* def basepath = 'lambda' + name
* set myReq.swagger.info.title = title
* set myReq.swagger.basePath = basepath
* print 'my subscriptions : ', myReq.apiConf
And request myReq 
When method post



#Invoke External gateway
Given url externalGatewayDev
And path '/test/' + basepath + '/v1/test-1'
* request '[ { "id":0, "properties":[ { "name":"myProperty1", "type":"string", "value":"myProperty1_value" }], "terrain":[0, 0, 0, 0] }, { "id":11, "properties":[ { "name":"myProperty2", "type":"string", "value":"myProperty2_value" }], "terrain":[0, 1, 0, 1] }, { "id":12, "properties":[ { "name":"myProperty3", "type":"string", "value":"myProperty3_value" }], "terrain":[1, 1, 1, 1] } ]'
* retry until responseStatus == '200'
When method post
* print ' response code from random External Gateway: ' , responseStatus
* call read('classpath:examples/Polling/Polling.feature') 


#Invoke Internal gateway
Given url internalGatewayDev
And path '/test/' + basepath + '/v1/test-1'
* request '[ { "id":0, "properties":[ { "name":"myProperty1", "type":"string", "value":"myProperty1_value" }], "terrain":[0, 0, 0, 0] }, { "id":11, "properties":[ { "name":"myProperty2", "type":"string", "value":"myProperty2_value" }], "terrain":[0, 1, 0, 1] }, { "id":12, "properties":[ { "name":"myProperty3", "type":"string", "value":"myProperty3_value" }], "terrain":[1, 1, 1, 1] } ]'
* retry until responseStatus == '200'
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* call read('classpath:examples/Polling/Polling.feature') 



# invalid json 
#Invoke External gateway
Given url externalGatewayDev
And path '/test/' + basepath + '/v1/test-1'
And header Content-Type = 'application/json; charset=utf-8'
* json invalidJson = read('invalidJson.json')
* request invalidJson
Given header Accept = 'application/json'
When method post
* print ' response code from random External Gateway: ' , responseStatus
* call read('classpath:examples/Polling/Polling.feature') 


#Invoke Internal gateway
Given url internalGatewayDev
And path '/test/' + basepath + '/v1/test-1'
And header Content-Type = 'application/json; charset=utf-8'
* json invalidJson = read('invalidJson.json')
* request invalidJson
Given header Accept = 'application/json'
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* call read('classpath:examples/Polling/Polling.feature') 


#Invoke External gateway
Given url externalGatewayDev
And path '/test/' + basepath + '/v1/test-1'
And header Content-Type = 'application/json; charset=utf-8'
* json invalidJson2 = read('invalidJson2.json')
* request invalidJson2
And header Accept = 'application/json'
When method post
* print ' response code from random External Gateway: ' , responseStatus
* call read('classpath:examples/Polling/Polling.feature') 


#Invoke Internal gateway
Given url internalGatewayDev
And path '/test/' + basepath + '/v1/test-1'
And header Content-Type = 'application/json; charset=utf-8'
* json invalidJson2 = read('invalidJson2.json')
* request invalidJson2
And header Accept = 'application/json'
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* call read('classpath:examples/Polling/Polling.feature') 


#* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
