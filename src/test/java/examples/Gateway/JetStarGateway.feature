Feature: This feature tests the Jetstar Gateway Functionality

Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }


#-------------------------- **** GATEWAY **** --------------------------------#

#* configure afterFeature = function(){ karate.call('Gateway-Cleanup.feature'); }
@gateway @parallel=false @All
Scenario Outline: Gateway Inputs
#register
Given url Admin
* json myReq = read('Swagger-JetStarGateway.json')
* set myReq.apiConf.subscriptionTiers = ['Silver_Auto-Approved','Gold_Auto-Approved','Bronze_Auto-Approved']
* set myReq.apiConf.jetstarExternalGateway = <jetstarExternalFlag>
* set myReq.apiConf.jetstarInternalGateway = <jetstarInternalFlag>
* def name = '1-' + now()
* def title = <title> + name
* def basepath = <basepath> + name
* set myReq.swagger.info.title = title
* set myReq.swagger.info.version = <version>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = basepath
And request myReq
When method post
Then status 200
* def domain = <domain>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def requestMethod = <method>

* call read('classpath:examples/Polling/Polling.feature') 

#Get the APIID from Store 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher for JetStar Gateway API: ' , APPIDFromPublisher.APIIDPub

* call read('classpath:examples/Polling/Polling.feature') 

#Invoke API through Internal Gateway
* def responseFromJetStarInternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'requestMethod': '#(requestMethod)' }


* call read('classpath:examples/Polling/Polling.feature') 

#Invoke API through External Gateway
* def responseFromJetStarInternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' , 'requestMethod': '#(requestMethod)' }
* call read('classpath:examples/Polling/Polling.feature') 

* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:
|title             |version|domain    |basepath      |jetstarInternalFlag|jetstarExternalFlag|internalGatewayResponse | externalGatewayResponse |path    |method|
|'REGTEST_Jinvoke5'|'v991' |'aircraft'|'countryJinvokeG1'|true               |false              |200        			  |404                      |'test-1'|'get'|
#|'REGTEST_Jinvoke6'|'v992' |'customer'|'countryJinvokeG2'|false              |true               |404                     |200                      |'test-1'|'get'|
|'REGTEST_Jinvoke7'|'v993' |'partner' |'countryJinvokeG3'|false              |false              |404                     |404                      |'test-1'|'get'|
|'REGTEST_Jinvoke8'|'v994' |'event'   |'countryJinvokeG4'|true               |true               |200                     |200                      |'test-1'|'get'|

