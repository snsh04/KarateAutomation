Feature: This feature tests the jetstar nginx using api url

Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }

#-------------------------- **** GATEWAY **** --------------------------------#
#* configure afterFeature = function(){ karate.call('Gateway-Cleanup.feature'); }
@NGINX @parallel=false @All @JetstarNGINX
Scenario Outline: External NGINX Gateway with GET
#Register an API
Given url Admin
* json myReq = read('Swagger-JetStarNGINX.json')
* def name = '6-' + now()
* def title = <title> + name
* def basepath = <basepath> + name
* set myReq.swagger.info.title = title
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = basepath
* set myReq.swagger.info.version = <version>
* set myReq.apiConf.jetstarExternalGateway = <externalFlag>
* set myReq.apiConf.jetstarInternalGateway = <internalFlag>
* set myReq.apiConf.subscriptionTiers = ['Silver_Auto-Approved','Gold_Auto-Approved','Bronze_Auto-Approved']
And request myReq
When method post
Then status 200
* match response.success == true
* def domain = <domain>

* def externalGatewayResponse = <externalGatewayResponse>
* def internalGatewayResponse = <internalGatewayResponse>
* def requestMethod = <method>
* def path = <path>
* print 'title i am looking for is ' , title

# get ID from the store
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher for JetStar Gateway API: ' , APPIDFromPublisher.APIIDPub

#Invoke API through NGINX External Gateway
#* def responseFromJetStarNGINXExternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarNGINXAPIExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' ,'requestMethod': '#(requestMethod)' }

#Invoke API through NGINX Internal Gateway
#* def responseFromJetStarNGINXInternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarNGINXAPIInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' ,'requestMethod': '#(requestMethod)'  }

* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
Examples:
|version |title             |domain                |basepath      |externalFlag  |internalFlag  |externalGatewayResponse|internalGatewayResponse|path|method|
|'v320'  |'REGTEST_JGate21' |'virtualassistant'    |'countryJNA1' |true          |false         |200                 |404                 |'test-1'|'get'|
|'v321'  |'REGTEST_JGate22' |'flight'              |'countryJNA2' |false         |false         |404                 |404                 |'test-1'|'get'|
|'v323'  |'REGTEST_JGate23' |'entertainment'       |'countryJNA3' |false         |true          |404                 |200                 |'test-1'|'get'|
|'v324'  |'REGTEST_JGate24' |'loyalty'             |'countrtJNA4' |true          |true          |200                 |200                 |'test-1'|'get'|



