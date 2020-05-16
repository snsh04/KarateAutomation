Feature: This feature tests the NGINX external and internal URLs
Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }

#-------------------------- **** GATEWAY **** --------------------------------#
#* configure afterFeature = function(){ karate.call('Gateway-CleanupNGINX.feature'); }
@NGINX @All @parallel=false @randomNGINX
Scenario Outline: External NGINX Gateway with GET
#Register an API
Given url Admin
* json myReq = read('Swagger-NGINX2.json')
* def name = '1Q-' + now()
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
#* match response.success == true
* def domain = <domain>
* def externalGatewayResponse = <externalGatewayResponse>
* def internalGatewayResponse = <internalGatewayResponse>
* def requestMethod = <method>
* def path = <path>
* print 'title i am looking for is ' , title

# get ID from the store
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher for random Gateway API: ' , APPIDFromPublisher.APIIDPub

#Invoke API through NGINX External Gateway
* def responseFromNGINXExternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' ,'requestMethod': '#(requestMethod)' }

#Invoke API through NGINX Internal Gateway
* def responseFromNGINXInternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' ,'requestMethod': '#(requestMethod)'  }

* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
Examples:
|version|title           |domain    |basepath   |externalFlag  |internalFlag  |externalGatewayResponse|internalGatewayResponse|path    |method|
|'v10'  |'REGTEST_GateN1'|'test'    |'countryN1'|true          |false         |200                    |404                    |'test-1'|'get'|
|'v12'  |'REGTEST_GateN2'|'partner' |'countryN2'|false         |false         |404                    |404                    |'test-1'|'get'|
|'v13'  |'REGTEST_GateN3'|'event'   |'countryN3'|false         |true          |404                    |200                    |'test-1'|'get'|
|'v14'  |'REGTEST_GateN4'|'customer'|'countryN4'|true          |true          |200                    |200                    |'test-1'|'get'|


@NGINX @All @parallel=false @randomNGINX
Scenario Outline: External NGINX Gateway with POST
#Register an API 
Given url Admin
* json myReq = read('Swagger-NGINX2.json')
* def name = '2Q-' + now()
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
#* match response.success == true
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
* def responseFromNGINXExternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' ,'requestMethod': '#(requestMethod)' }

#Invoke API through NGINX Internal Gateway
* def responseFromNGINXInternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' ,'requestMethod': '#(requestMethod)'  }

* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
Examples:
|version|title          |domain    |basepath   |externalFlag  |internalFlag  |externalGatewayResponse|internalGatewayResponse|path    |method|
|'v15'  |'REGTEST_Gate5'|'test'    |'countryN5'|true          |false         |200                    |404                    |'test-1'|'post'|
|'v16'  |'REGTEST_Gate6'|'partner' |'countryN6'|false         |false         |404                    |404                    |'test-1'|'post'|
|'v17'  |'REGTEST_Gate7'|'event'   |'countryN7'|false         |true          |404                    |200                    |'test-1'|'post'|
|'v18'  |'REGTEST_Gate8'|'customer'|'countrtN8'|true          |true          |200                    |200                    |'test-1'|'post'|

@NGINX @All @parallel=false @randomNGINX
Scenario Outline: External NGINX Gateway with DELETE
#Register an API
Given url Admin
* json myReq = read('Swagger-NGINX2.json')
* def name = '3Q-' + now()
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
#* match response.success == true
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
* def responseFromNGINXExternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' ,'requestMethod': '#(requestMethod)' }

#Invoke API through NGINX Internal Gateway
* def responseFromNGINXInternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' ,'requestMethod': '#(requestMethod)'  }

* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
Examples:
|version|title            |domain    |basepath    |externalFlag  |internalFlag  |externalGatewayResponse|internalGatewayResponse|path  |method  |
|'v19' |'REGTEST_Gate9' |'test'    |'countryN9' |true          |false         |200                 |404                 |'test2'|'delete'|
|'v20' |'REGTEST_Gate10'|'partner' |'countryN10'|false         |false         |404                 |404                 |'test2'|'delete'|
|'v21' |'REGTEST_Gate11'|'event'   |'countryN11'|false         |true          |404                 |200                 |'test2'|'delete'|
|'v22' |'REGTEST_Gate12'|'customer'|'countrtN12'|true          |true          |200                 |200                 |'test2'|'delete'|

@NGINX @All @parallel=false @randomNGINX
Scenario Outline: External NGINX Gateway with PUT
#Register an API
Given url Admin
* json myReq = read('Swagger-NGINX2.json')
* def name = '4Q-' + now()
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
#* match response.success == true
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
* def responseFromNGINXExternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' ,'requestMethod': '#(requestMethod)' }

#Invoke API through NGINX Internal Gateway
* def responseFromNGINXInternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' ,'requestMethod': '#(requestMethod)'  }

* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
Examples:
|version|title             |domain    |basepath     |externalFlag  |internalFlag  |externalGatewayResponse|internalGatewayResponse|path|method|
|'v23'|'REGTEST_Gate13' |'test'    |'countryN13' |true          |false         |200                 |404                 |'test2'|'put'|
|'v24'|'REGTEST_Gate14' |'partner' |'countryN14' |false         |false         |404                 |404                 |'test2'|'put'|
|'v25'|'REGTEST_Gate15' |'event'   |'countryN15' |false         |true          |404                 |200                 |'test2'|'put'|
|'v26'|'REGTEST_Gate16' |'customer'|'countrtN16' |true          |true          |200                 |200                 |'test2'|'put'|

@NGINX @All @parallel=false @randomNGINX
Scenario Outline: External NGINX Gateway with PATCH
#Register an API
Given url Admin
* json myReq = read('Swagger-NGINX2.json')
* def name = '5Q-' + now()
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
#* match response.success == true
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
* def responseFromNGINXExternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' ,'requestMethod': '#(requestMethod)' }

#Invoke API through NGINX Internal Gateway
* def responseFromNGINXInternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' ,'requestMethod': '#(requestMethod)'  }

* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
Examples:
|version|title             |domain    |basepath     |externalFlag  |internalFlag  |externalGatewayResponse|internalGatewayResponse|path|method|
|'v27'  |'REGTEST_Gate17' |'test'    |'countryN17' |true          |false         |200                 |404                 |'test2'|'patch'|
|'v28'  |'REGTEST_Gate18' |'partner' |'countryN18' |false         |false         |404                 |404                 |'test2'|'patch'|
|'v29'  |'REGTEST_Gate19' |'event'   |'countryN19' |false         |true          |404                 |200                 |'test2'|'patch'|
|'v30'  |'REGTEST_Gate20' |'customer'|'countrtN20' |true          |true          |200                 |200                 |'test2'|'patch'|


