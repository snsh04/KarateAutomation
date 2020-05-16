Feature: API Admin - Lambda registration

Background: 
* def now = function(){ return java.lang.System.currentTimeMillis() }
  
  # not required
  @parallel=false 
Scenario Outline: Lambda API registration
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = apiGatewayKey
And header apigateway-basepath = 'lambda-migration'
* json myReq = read('swagger-JetStarlambda.json')
* set myReq.apiConf.subscriptionTiers = <subscriptionTiers>
* set myReq.swagger.info.title = 'JetStar_REGTEST_AUTO_Regression_Lambda_Quote_Function'
* set myReq.swagger.basePath = 'lambda-migration'
* set myReq.swagger.info.version = 'v1'
And request myReq
When method post
Then status <responseCode>
* def requestMethod = <method>
* def path = <path>

 #Get the APIID from Publisher
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'JetStar_REGTEST_AUTO_Regression_Lambda_Quote_Function'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher for JetStar Gateway API: ' , APPIDFromPublisher.APIIDPub

#Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': 'JetStar_REGTEST_AUTO_Regression_Lambda_Quote_Function'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for JetStar Gateway API: ' , APPIDFromStore.APIIDStr

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

#Invoke API through External Gateway
* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarExternalWSO2Gateway.feature') {'domain': 'car' , 'basepath': 'lambda-migration' , 'path': '#(path)' , 'externalGatewayResponse': '200' , 'method': '#(requestMethod)' , 'accessTokenforProd': '#(accessTokenforProd)' }
* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == 200
 
 # Delete the Application and API
#* call read('Sleep.feature')
* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
Examples: 
| subscriptionTiers                  | responseCode | scenario |path   |method|
| [Bronze_Auto-Approved,Gold,Silver] |          200 | Positive |'quote'|'get'|

@lambda  @parallel=false
Scenario Outline: Lambda API registration with default single version
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = apiGatewayKey
And header apigateway-basepath = <basepath>
* json myReq = read('swagger-JetStarlambda.json')
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

#Get the APIID from Publisher
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher for JetStar Gateway API: ' , APPIDFromPublisher.APIIDPub

#Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for JetStar Gateway API: ' , APPIDFromStore.APIIDStr

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

#Invoke API through External Gateway
* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'method': '#(requestMethod)' , 'accessTokenforProd': '#(accessTokenforProd)' }
* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == <externalGatewayResponse>
 
# Delete the Application and API
#* call read('Sleep.feature')
* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples: 
|domain         |basepath          |title               | subscriptionTiers                            | responseCode | defaultVersion | externalGatewayResponse | version | path  |method|
|'product'      |'lambda-migration'|'REGTEST_LAMBDADEF4'| [Bronze_Auto-Approved,Gold,Silver,Unlimited] |          200 | false          |                200 | v1      | 'v1/quote' |'get'|
|'car'          |'lambda-resource' |'REGTEST_LAMBDADEF5'| [Bronze_Auto-Approved,Gold,Silver,Unlimited] |          200 | true           |                200 | v1      | 'quote'    |'get'|
|'entertainment'|'lambdaTester'    |'REGTEST_LAMBDADEF6'| [Bronze_Auto-Approved,Gold,Silver,Unlimited] |          200 | false          |                404 | v1      | 'quote'    |'get'|

  @parallel=false 
Scenario Outline: Lambda API registration with multi version
# Register and subscribe first Version
#Given url ApiAdminURL
#And path AdminPath
#And header apigateway-apikey = apiGatewayKey
#And header apigateway-basepath = 'lambda-resource1'
#* json myReq = read('swagger-JetStarlambda.json')
#* set myReq.apiConf.subscriptionTiers = <subscriptionTiers>
#* def name = '1-' + now()
#* def title = <title> + name
#* set myReq.swagger.info.title = title
#* set myReq.swagger.basePath = 'lambda-resource1'
#* set myReq.swagger.info.version = 'v1'
#* set myReq.apiConf.defaultVersion = 'true'
#And request myReq
#When method post	
#Then status <responseCode>
#* def requestMethod = <method>
#* call read('classpath:examples/Polling/Polling.feature') 
#     
## Get the APIID from Publisher
#* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
#* def APIIDPub = APPIDFromPublisher.APIIDPub
#* print 'APPIDFromPublisher for JetStar Gateway API: ' , APPIDFromPublisher.APIIDPub
#
## Get the APIID from Store
#* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
#* def APIIDStr = APPIDFromStore.APIIDStr
#* print 'APPIDFromStore for JetStar Gateway API: ' , APPIDFromStore.APIIDStr
#
## Subscribe
## create application
#* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
#* def applicationID = applicationDetails.response.applicationId
#
## Generate keys
#* def applicationKeyDetails = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
#* def accessTokenforProd = 'Bearer '+ applicationKeyDetails.response.token.accessToken
#
## Subscribe
#* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
#* def subscriptionId = subscriptionDetails.response.subscriptionId
#* def externalGatewayResponse = <externalGatewayResponse>
#
## Invoke as v1 Version
## Invoke API through External Gateway
#* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarExternalWSO2Gateway.feature') {'domain': 'aircraft' , 'basepath': 'lambda-resource1' , 'path': 'v1/quote' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'method': '#(requestMethod)' , 'accessTokenforProd': '#(accessTokenforProd)' }
#* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == 200
#
## Invoke as Default Version
#* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarExternalWSO2Gateway.feature') {'domain': 'aircraft' , 'basepath': 'lambda-resource1' , 'path': 'quote' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'method': '#(requestMethod)' , 'accessTokenforProd': '#(accessTokenforProd)' }
#* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == 200
#    
#* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
#* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

# Register Second Version again as default version
Given url Admin
* json myReq = read('swagger-JetStarlambda.json')
#* set myReq.apiConf.subscriptionTiers = <subscriptionTiers>
* set myReq.swagger.info.title = 'test'
* set myReq.swagger.basePath = 'lambda-resource1'
* set myReq.swagger.info.version = 'v2'
* set myReq.apiConf.defaultVersion = 'true'
And request myReq
When method post
Then status 200
 
## Get the APIID from Publisher
#* def APPIDFromPublisher2 = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
#* def APIIDPub2 = APPIDFromPublisher2.APIIDPub
#* print 'APPIDFromPublisher for random Gateway API2: ' , APPIDFromPublisher2.APIIDPub    
#    
## Get the APIID from Store
#* def APPIDFromStore2 = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
#* def APIIDStr2 = APPIDFromStore2.APIIDStr
#* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

## subscribe
## create application
#* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
#* def applicationID = applicationDetails.response.applicationId
#
## generate keys
#* def applicationKeyDetails = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
#* def accessTokenforProd = 'Bearer '+ applicationKeyDetails.response.token.accessToken
#
## subscribe
#* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr2)' , 'applicationID': '#(applicationID)' }
#* def subscriptionId = subscriptionDetails.response.subscriptionId  
#    
## Invoke Default Version Again using v1 token
#* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarExternalWSO2Gateway.feature') {'domain': 'event' , 'basepath': 'lambda-resource1' , 'path': 'v2/quote' , 'externalGatewayResponse': '200' , 'method': '#(requestMethod)' , 'accessTokenforProd': '#(accessTokenforProd)' }
#* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == 200
#
## Delete the Application and API
##* call read('Sleep.feature')
#* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
#* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub2)'  }

Examples: 
|title              | subscriptionTiers                            | responseCode |externalGatewayResponse|method|
|'REGTEST_LAMBDAMULTI2'| [Bronze_Auto-Approved,Gold,Silver,Unlimited] | 200          |200                    |'get'|

  @parallel=false @retesterr 
Scenario Outline: Lambda API registration when ARN is invalid
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = apiGatewayKey
And header apigateway-basepath = 'lambdaTesting'
* json myReq = read('swagger-JetStarlambda.json')
And request myReq
When method post
Then status 200
#* def requestMethod = <method>
#* def path = <path>
#* def domain = <domain>
#* def basepath = <basepath>
#
## Get the APIID from Publisher
#* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
#* def APIIDPub = APPIDFromPublisher.APIIDPub
#* print 'APPIDFromPublisher for JetStar Gateway API: ' , APPIDFromPublisher.APIIDPub
#
## Get the APIID from Store
#* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
#* def APIIDStr = APPIDFromStore.APIIDStr
#* print 'APPIDFromStore for JetStar Gateway API: ' , APPIDFromStore.APIIDStr
#
## Subscribe
## Create application
#* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
#* def applicationID = applicationDetails.response.applicationId
#
## Generate keys
#* def applicationKeyDetails = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
#* def accessTokenforProd = 'Bearer '+ applicationKeyDetails.response.token.accessToken
#
## Subscribe
#* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
#* def subscriptionId = subscriptionDetails.response.subscriptionId
#
## Invoke API through External Gateway
#* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '404' , 'method': '#(requestMethod)' , 'accessTokenforProd': '#(accessTokenforProd)' }
#* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == 404
# 
## Delete the Application and API
##* call read('Sleep.feature')
#* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
#* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples: 
|path   |domain    |basepath       |title         | subscriptionTiers                            | arn                                                           | responseCode |method|
#|'v1/quote' |'partner' |'lambdaTesting'|'REGTEST_ARN3'| [Bronze_Auto-Approved,Gold,Silver,Unlimited] | 'bananas'                                                     |          200 |'get'|
#|'v1/quote'|'customer'|'lambdaTesting'|'REGTEST_ARN4'| [Bronze_Auto-Approved,Gold,Silver,Unlimited] | 'arn-aws-lambda-ap-southeast-2-196238444021-function-bananas' |          200 |'get'|

    

Scenario Outline: Lambda validation of resource path
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = apiGatewayKey
And header apigateway-basepath = 'lambda-migration'
* json myReq = read('swagger-lambdaResource.json')
* set myReq.swagger.info.title = 'JetStar_REGTEST_paths'
* set myReq.swagger.basePath = 'lambda-migration'
* set myReq.swagger.info.version = 'v1'
And request myReq
When method post
Then status 200
* call read('Lambda-Sleep.feature')
* def responsefromsubscriber = call read('Lambda-APIDefinition.feature') { APIIDPub: '#(APIIDPub)' ,title: "JetStar_REGTEST_AUTO_Regression" }
* def testpath = <testpath>
* def responsefromInvoke = call read('Lambda-InvokeNoAuth.feature') { testpath: '#(testpath)' }
* match responsefromInvoke.InvokeStatus == <responseCode>
    
# Create Token for deletion 
Given  url authURL 
And  header Authorization = Authorization 
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

* call read('Lambda-Delete.feature') 
Examples: 
| responseCode    | testpath                                 | 
| 200             | 'test/lambda-migration/v1/quote-1'       |
| 200             | 'test/lambda-migration/v1/quote/{quote}' |
| 200             | 'test/lambda-migration/v1/quote/9lB019'  |
| 200             | 'test/lambda-migration/v1/'  |
    
