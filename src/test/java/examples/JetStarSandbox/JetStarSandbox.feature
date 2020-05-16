Feature: This feature tests the sandbox url capabilities for all random APIs

Background:
* configure afterFeature = function(){ karate.call('Sandbox-JetStarDelete.feature'); }
* def now = function(){ return java.lang.System.currentTimeMillis() }
#-------------------------------------------------------------------------------


#Register API
@Sandbox @parallel=false @All @JetstarSandbox
Scenario Outline: Registering New API


# Register an API from Admin
Given url Admin
* json myReq = read('Swagger-JetStarSandbox.json')
* def title = <title>
* set myReq.swagger.info.title = title
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
* set myReq.swagger.info.version = <version>
* set myReq.apiConf.includeVersion = <includeVersion>
* set myReq.swagger.host = <ProdURL>
* set myReq.apiConf.sandboxHost = <Sandbox>
And request myReq
When method post
Then status 200

#Check the Prod URL and Sandbox URL from publisher 
* def domain = <domain>
* def basepath = <basepath>
* def version = <version>
* def path = <path>
* def requestMethod = <method>
* def externalGatewayResponse = <externalGatewayResponse>
* def responsefromSandboxPublisher = call read('classpath:examples/Services/GetAPIDefFromSandboxPublisher.feature') {title: '#(title)' , version: '#(version)' }
* print ' response ', responsefromSandboxPublisher


#Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr


* string endpoints = responsefromSandboxPublisher.response.endpointConfig
* print ' endpoints' , endpoints
* def start = endpoints.indexOf('production_endpoints":{"url":"')
* def Prodref = endpoints.substring(start + 23)
* def end = Prodref.indexOf('","config":null}')
* def Prodref = Prodref.substring(0, end)
* print 'prod host  ', Prodref

* def start = endpoints.indexOf('sandbox_endpoints":{"url":"')
* def Sandboxref = endpoints.substring(start + 23)
* def end = Sandboxref.indexOf('","config":null}')
* def Sandboxref = Sandboxref.substring(0, end)
* print 'Sandbox host  ', Sandboxref

#match expected URL
* match Prodref contains <ProdURL>
* match Sandboxref contains <SandboxURL>

# create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
* def applicationID = applicationDetails.response.applicationId

# generate keys
* def applicationKeyDetailsProd = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforProd = 'Bearer '+ applicationKeyDetailsProd.response.token.accessToken

* def applicationKeyDetailsSandbox = call read('classpath:examples/Services/GenerateSandboxApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforSandbox = 'Bearer '+ applicationKeyDetailsSandbox.response.token.accessToken

# subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
* def subscriptionId = subscriptionDetails.response.subscriptionId

## Production Invokation
#Invoke API through External Gateway
* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'method': '#(requestMethod)' , 'accessTokenforProd': '#(accessTokenforProd)' }
* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == 200

## Sandbox Invokation
#Invoke API through External Gateway
* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedJetStarExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'method': '#(requestMethod)' , 'accessTokenforSandbox': '#(accessTokenforSandbox)' }
* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == 200

Examples:
|path           |title                          |domain            |basepath                       |version |includeVersion|ProdURL                                                       |Sandbox                                                        |SandboxURL                                                                                    |externalGatewayResponse|method|
|'v1/countries' |'REGTEST_JnewAPINoSandboxfalse'|'car'             |'country-JNewAPINoSandboxfalse'|'v1'    |false         |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api' |''                                                             |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api/country-JNewAPINoSandboxfalse'   |200                    |'get' |
|'v1/countries' |'REGTEST_JnewAPISandboxfalse'  |'entertainment'   |'country-JNewAPISandboxfalse'  |'v1'    |false         |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api'|'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api'|'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api/country-JNewAPISandboxfalse'  |200                    |'get' |
|'v1/countries' |'REGTEST_JnewAPINoSandboxtrue' |'virtualassistant'|'country-JNewAPINoSandboxtrue' |'v1'    |true          |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api'|''                                                              |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api/country-JNewAPINoSandboxtrue/v1' |200                    |'get' |
|'v1/countries' |'REGTEST_JnewAPISandboxtrue'   |'notification'    |'country-JNewAPISandboxtrue'   |'v1'    |true          |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api'|'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api'|'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api/country-JNewAPISandboxtrue/v1'|200                    |'get' |
 
@Sandbox @parallel=false @All @JetstarSandbox
Scenario Outline: Registering New version of existing API

# Register an API from Admin
Given url Admin
* json myReq = read('Swagger-JetStarSandbox.json')
* def title = <title>
* set myReq.swagger.info.title = title
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
* set myReq.swagger.info.version = <version>
* set myReq.apiConf.includeVersion = <includeVersion>
* set myReq.swagger.host = <ProdURL>
* set myReq.apiConf.sandboxHost = <Sandbox>
And request myReq
When method post
Then status 200

#Check the Prod URL and Sandbox URL from publisher 
* def domain = <domain>
* def basepath = <basepath>
* def version = <version>
* def path = <path>
* def requestMethod = <method>
* def externalGatewayResponse = <externalGatewayResponse>
* def responsefromSandboxPublisher = call read('classpath:examples/Services/GetAPIDefFromSandboxPublisher.feature') {title: '#(title)' , version: '#(version)' }
* print ' response ', responsefromSandboxPublisher


#Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

* string endpoints = responsefromSandboxPublisher.response.endpointConfig
* print ' endpoints' , endpoints
* def start = endpoints.indexOf('production_endpoints":{"url":"')
* def Prodref = endpoints.substring(start + 23)
* def end = Prodref.indexOf('","config":null}')
* def Prodref = Prodref.substring(0, end)
* print 'prod host  ', Prodref

* def start = endpoints.indexOf('sandbox_endpoints":{"url":"')
* def Sandboxref = endpoints.substring(start + 23)
* def end = Sandboxref.indexOf('","config":null}')
* def Sandboxref = Sandboxref.substring(0, end)
* print 'Sandbox host  ', Sandboxref

#match expected URL
* match Prodref contains <ProdURL>
* match Sandboxref contains <SandboxURL>

# create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
* def applicationID = applicationDetails.response.applicationId

# generate keys
* def applicationKeyDetailsProd = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforProd = 'Bearer '+ applicationKeyDetailsProd.response.token.accessToken

* def applicationKeyDetailsSandbox = call read('classpath:examples/Services/GenerateSandboxApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforSandbox = 'Bearer '+ applicationKeyDetailsSandbox.response.token.accessToken

# subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
* def subscriptionId = subscriptionDetails.response.subscriptionId

## Production Invokation
#Invoke API through External Gateway
* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'method': '#(requestMethod)' , 'accessTokenforProd': '#(accessTokenforProd)' }
* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == 200


## Sandbox Invokation
#Invoke API through External Gateway
* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedJetStarExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'method': '#(requestMethod)' , 'accessTokenforSandbox': '#(accessTokenforSandbox)' }
* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == 200

Examples:
|path          |title                          |domain            |basepath                       |version|includeVersion|ProdURL                                                       |Sandbox                                                            |SandboxURL                                                                                      |externalGatewayResponse|method    |
|'v1/countries'|'REGTEST_JnewAPINoSandboxfalse'|'car'             |'country-JNewAPINoSandboxfalse'|'v2'   |false         |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api' |''                                                                 |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api/country-JNewAPINoSandboxfalse'     |200                    |'get'     |
|'v1/countries'|'REGTEST_JnewAPISandboxfalse'  |'entertainment'   |'country-JNewAPISandboxfalse'  |'v2'   |false         |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api' |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api' |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api/country-JNewAPISandboxfalse'  |200                    |'get'     |
|'v1/countries'|'REGTEST_JnewAPINoSandboxtrue' |'virtualassistant'|'country-JNewAPINoSandboxtrue' |'v2'   |true          |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api' |''                                                                 |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api/country-JNewAPINoSandboxtrue/v1'   |200                    |'get'     |
|'v1/countries'|'REGTEST_JnewAPISandboxtrue'   |'notification'    |'country-JNewAPISandboxtrue'   |'v2'   |true          |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api' |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api' |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api/country-JNewAPISandboxtrue/v2'|200                    |'get'     |
  
  @Sandbox @parallel=false @All @JetstarSandbox
Scenario Outline: Updating an existing API

# Register an API from Admin
Given url Admin
* json myReq = read('Swagger-JetStarSandbox.json')
* def title = <title> 
* set myReq.swagger.info.title = title
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
* set myReq.swagger.info.version = <version>
* set myReq.apiConf.includeVersion = <includeVersion>
* set myReq.swagger.host = <ProdURL>
* set myReq.apiConf.sandboxHost = <Sandbox>
* set myReq.swagger.info.description = <description>

And request myReq
When method post
Then status 200 

#Check the Prod URL and Sandbox URL from publisher 
* def domain = <domain>
* def basepath = <basepath>
* def version = <version>
* def path = <path>
* def requestMethod = <method>
* def externalGatewayResponse = <externalGatewayResponse>
* def responsefromSandboxPublisher = call read('classpath:examples/Services/GetAPIDefFromSandboxPublisher.feature') {title: '#(title)' , version: '#(version)' }
* print ' response ', responsefromSandboxPublisher


#Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

* string endpoints = responsefromSandboxPublisher.response.endpointConfig
* print ' endpoints' , endpoints
* def start = endpoints.indexOf('production_endpoints":{"url":"')
* def Prodref = endpoints.substring(start + 23)
* def end = Prodref.indexOf('","config":null}')
* def Prodref = Prodref.substring(0, end)
* print 'prod host  ', Prodref

* def start = endpoints.indexOf('sandbox_endpoints":{"url":"')
* def Sandboxref = endpoints.substring(start + 23)
* def end = Sandboxref.indexOf('","config":null}')
* def Sandboxref = Sandboxref.substring(0, end)
* print 'Sandbox host  ', Sandboxref

#match expected URL
* match Prodref contains <ProdURL>
* match Sandboxref contains <SandboxURL>

# create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
* def applicationID = applicationDetails.response.applicationId

# generate keys
* def applicationKeyDetailsProd = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforProd = 'Bearer '+ applicationKeyDetailsProd.response.token.accessToken

* def applicationKeyDetailsSandbox = call read('classpath:examples/Services/GenerateSandboxApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforSandbox = 'Bearer '+ applicationKeyDetailsSandbox.response.token.accessToken

# subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
* def subscriptionId = subscriptionDetails.response.subscriptionId

## Production Invokation
#Invoke API through External Gateway
* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdJetStarExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'method': '#(requestMethod)' , 'accessTokenforProd': '#(accessTokenforProd)' }
* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == 200

## Sandbox Invokation
#Invoke API through External Gateway
* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedJetStarExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'method': '#(requestMethod)' , 'accessTokenforSandbox': '#(accessTokenforSandbox)' }
* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == 200

Examples:
|description|path           |title                          |domain            |basepath                       |version|includeVersion|ProdURL                                                       |Sandbox                                                            |SandboxURL                                                                                       |externalGatewayResponse|method|
|'updating' |'v1/countries' |'REGTEST_JnewAPINoSandboxfalse'|'car'             |'country-JNewAPINoSandboxfalse'|'v1'   |false         |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api' |''                                                                 |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api/country-JNewAPINoSandboxfalse'       |200                |'get'            |
|'updating' |'v1/countries' |'REGTEST_JnewAPISandboxfalse'  |'entertainment'   |'country-JNewAPISandboxfalse'  |'v1'   |false         |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api' |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api' |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api/country-JNewAPISandboxfalse'  |200                |'get'           |
|'updating' |'v1/countries' |'REGTEST_JnewAPINoSandboxtrue' |'virtualassistant'|'country-JNewAPINoSandboxtrue' |'v1'   |true          |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api' |''                                                                 |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api/country-JNewAPINoSandboxtrue/v1'     |200                |'get'             |
|'updating' |'v1/countries' |'REGTEST_JnewAPISandboxtrue'   |'notification'    |'country-JNewAPISandboxtrue'   |'v1'   |true          |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api' |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api' |'demo.dev.dev.a878-02.ams10.nonp.cloud.random.com/api/country-JNewAPISandboxtrue/v1'  |200                |'get'            |
 
 
