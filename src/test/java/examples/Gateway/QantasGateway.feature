Feature: This feature file validates the random gateway invokations  

Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }


#-------------------------- **** GATEWAY **** --------------------------------#

#* configure afterFeature = function(){ karate.call('Gateway-Cleanup.feature'); }

@gateway @parallel=false @All @randomGateway
Scenario Outline: Gateway Inputs
#register
Given url Admin
* json myReq = read('Swagger-Gateway1.json')
* set myReq.apiConf.subscriptionTiers = ['Silver_Auto-Approved','Gold_Auto-Approved','Bronze_Auto-Approved']
* set myReq.apiConf.internalGateway = <internal>
* set myReq.apiConf.externalGateway = <external> 
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

#Get the APIID from Publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher for random Gateway API: ' , APPIDFromPublisher.APIIDPub

* call read('classpath:examples/Polling/Polling.feature') 

#Invoke API through Internal Gateway
* def responseFromExternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' ,'requestMethod': '#(requestMethod)' }

* call read('classpath:examples/Polling/Polling.feature') 

#Invoke API through External Gateway
* def responseFromInternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' ,'requestMethod': '#(requestMethod)'  }

* call read('classpath:examples/Polling/Polling.feature') 

#Delete

* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }


Examples:	
|title             |version|domain    |basepath   |internal|external   |internalGatewayResponse | externalGatewayResponse |path    |method|
|'REGTEST_invoke1'|'v200' |'test'    |'countryinvokeG1'|true    |false      |200					    |404                      |'test-1'|'get'|
|'REGTEST_invoke2'|'v201' |'customer'|'countryinvokeG2'|false   |true       |404                     |200                      |'test-1'|'get'|
|'REGTEST_invoke3'|'v202' |'partner' |'countryinvokeG3'|false   |false      |404                     |404                      |'test-1'|'get'|
|'REGTEST_invoke4'|'v203' |'event'   |'countryinvokeG4'|true    |true       |200                     |200                      |'test-1'|'get'|

