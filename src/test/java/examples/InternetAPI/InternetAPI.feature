Feature: Connect to internetAPI and test the connections

Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }
* configure retry = { count: 7, interval: 5000 }
#---------------------------------------------------------------------------------
#****************------ PUBLISHER ---------*****************

@InternetAPI  @parallel=false
Scenario Outline: Register an API with public API on internet
#Test1 : Set host as github and run on all 4 gateways 
#Test2 : Check with POST/PATCH/PUT/DELETE
#Test3 : Tests with query parameters
#Test4 : Tests invalid url

Given url Admin
* json myReq = read('Swagger-InternetAPI.json')
* set myReq.apiConf.internalGateway = <internal>
* set myReq.apiConf.externalGateway = <external>
* set myReq.apiConf.jetstarExternalGateway = <external>
* set myReq.apiConf.jetstarInternalGateway = <internal>
* def name = '1-' + now()
* def title = <title> + name
* def basepath = <basepath> + name
* set myReq.swagger.info.title = title
* set myReq.swagger.info.version = <version>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = basepath
* request myReq
When method post
Then status 200
* def domain = <domain>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def requestMethod = <method>

# Get the APIID from Publisher
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher for random Gateway API: ' , APPIDFromPublisher.APIIDPub


#Invoke External gateway
Given url externalGateway
And path domain + '/' + basepath + '/' +  path
* request 'test'
* retry until responseStatus == externalGatewayResponse && response.documentation_url == 'https://developer.github.com/v3'
When method requestMethod



#Invoke Internal gateway
Given url internalGateway
And path domain + '/' + basepath + '/' +  path
* request 'test'
* retry until responseStatus == externalGatewayResponse && response.documentation_url == 'https://developer.github.com/v3'
When method requestMethod


#Invoke Jetstar External gateway
Given url jetstarExternalGateway
And path domain + '/' + basepath + '/' +  path
* request 'test'
* retry until responseStatus == externalGatewayResponse && response.documentation_url == 'https://developer.github.com/v3'
When method requestMethod

#Invoke Jetstar Internal gateway
Given url jetstarInternalGateway
And path domain + '/' + basepath + '/' +  path
* request 'test'
* retry until responseStatus == externalGatewayResponse && response.documentation_url == 'https://developer.github.com/v3'
When method requestMethod


# Delete the API

* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:	
|title              |version|domain         |basepath   |internal |external    |internalGatewayResponse | externalGatewayResponse |path     |method|
|'REGTEST_Internet1'|'v880' |'test'         |'countryI1'|true     |true        |404				       |404                      |'events' |'get'|
|'REGTEST_Internet2'|'v888' |'car'          |'countryI2'|true     |true        |404				       |404                      |'events' |'post'|
|'REGTEST_Internet3'|'v880' |'partner'      |'countryI3'|true     |true        |404				       |404                      |'events' |'patch'|
|'REGTEST_Internet4'|'v889' |'customer'     |'countryI4'|true     |true        |404				       |404                      |'events' |'put'|
#|'REGTEST_Internet4'|'v889' |'customer'     |'countryI4'|true     |true        |404				       |404                     |'events' |'delete '|
#|'REGTEST_Interne10'|'v688' |'car'          |'country1I0'|false    |true       |404	    			   |404                      |'{org}?org=12'|'get'|

 @parallel=false @InternetAPI
Scenario Outline: validation with Sandbox
# Test to make sure internt API works with Authenticated APIs as well.
# Test to make sure internt API works as sandbox url as well.
Given url Admin
* json myReq = read('Swagger-AuthenticatedInternetAPI.json')
* set myReq.apiConf.internalGateway = <internal>
* set myReq.apiConf.externalGateway = <external>
* set myReq.apiConf.jetstarExternalGateway = <external>
* set myReq.apiConf.jetstarInternalGateway = <internal>
* def name = '1-' + now()
* def title = <title> + name
* set myReq.swagger.info.title = title
* set myReq.swagger.info.version = <version>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
* request myReq
When method post
Then status 200
* def domain = <domain>
* def basepath = <basepath>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def requestMethod = <method>
#Get the APIID from Publisher
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher for random Gateway API: ' , APPIDFromPublisher.APIIDPub

#Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

# subscribe
# create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
* def applicationID = applicationDetails.response.applicationId

# generate keys
* def applicationKeyDetails = call read('classpath:examples/Services/GenerateSandboxApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforSandbox = 'Bearer '+ applicationKeyDetails.response.token.accessToken

# subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
* def subscriptionId = subscriptionDetails.response.subscriptionId

#Invoke External gateway
Given url externalGateway
And path domain + '/' + basepath + '/' +  path
* request 'test'
* retry until responseStatus == externalGatewayResponse && response.documentation_url == 'https://developer.github.com/v3'
When method requestMethod

# Delete the Application and API

* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:	
|title                  |version|domain |basepath       |internal |external    |internalGatewayResponse | externalGatewayResponse |path     |method|
|'REGTEST_AuthInternet1'|'v789' |'car'  |'countryAuthI199'|true     |true        |404				        |404                      |'events' |'get'|

