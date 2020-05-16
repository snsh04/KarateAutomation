Feature: This feature tests the NGINX external and internal URLs using /api

Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }

#-------------------------- **** GATEWAY **** --------------------------------#
#* configure afterFeature = function(){ karate.call('Gateway-Cleanup.feature'); }
@randomNGINX @parallel=false  @NGINX @All
Scenario Outline: External NGINX Gateway with GET
#Register an API
Given url Admin
* json myReq = read('Swagger-NGINX2.json')
* def name = '6Q-' + now()
* def title = <title> + name
* def basepath = <basepath> + name
* set myReq.swagger.info.title = title
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = basepath
* set myReq.swagger.info.version = <version>
* set myReq.apiConf.externalGateway = <externalFlag>
* set myReq.apiConf.internalGateway = <internalFlag>
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

* print ' Title i am looking for is ', title
#Get the APIID from Store 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher for random Gateway API: ' , APPIDFromPublisher.APIIDPub

#Invoke API through NGINX External Gateway
* def responseFromNGINXExternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXAPIExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' ,'requestMethod': '#(requestMethod)' }

#Invoke API through NGINX Internal Gateway
* def responseFromNGINXInternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXAPIInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' ,'requestMethod': '#(requestMethod)'  }

* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
Examples:
|version|title            |domain                |basepath     |externalFlag  |internalFlag  |externalGatewayResponse|internalGatewayResponse|path|method|
|'v31'  |'REGTEST_Gate21' |'virtualassistant'    |'countryNA1' |true          |false         |200                 |404                 |'test-1'|'get'|
|'v32'  |'REGTEST_Gate22' |'flight'              |'countryNA2' |false         |false         |404                 |404                 |'test-1'|'get'|
|'v33'  |'REGTEST_Gate23' |'entertainment'       |'countryNA3' |false         |true          |404                 |200                 |'test-1'|'get'|
|'v34'  |'REGTEST_Gate24' |'loyalty'             |'countrtNA4' |true          |true          |200                 |200                 |'test-1'|'get'|



