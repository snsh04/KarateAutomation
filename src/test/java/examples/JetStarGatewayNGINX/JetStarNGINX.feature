Feature: This feature tests the jetstar nginx url

Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }

#-------------------------- **** GATEWAY **** --------------------------------#
#* configure afterFeature = function(){ karate.call('Gateway-CleanupNGINX.feature'); }
@NGINX @parallel=false @All @JetstarNGINX @tersss
Scenario Outline: External NGINX Gateway with GET
#Register an API
Given url Admin
* json myReq = read('Swagger-JetStarNGINX.json')
* def name = '1-' + now()
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
* def responseFromJetStarNGINXExternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarNGINXExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' ,'requestMethod': '#(requestMethod)' }

#Invoke API through NGINX Internal Gateway
* def responseFromJetStarNGINXInternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarNGINXInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' ,'requestMethod': '#(requestMethod)'  }

* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
Examples:
|version |title            |domain    |basepath    |externalFlag  |internalFlag  |externalGatewayResponse|internalGatewayResponse|path|method|
|'v300'  |'REGTEST_JGateN1'|'test'    |'countryJN1'|true          |false         |200                    |404                 |'test-1'|'get'|
|'v301'  |'REGTEST_JGateN2'|'partner' |'countryJN2'|false         |false         |404                    |404                 |'test-1'|'get'|
|'v302'  |'REGTEST_JGateN3'|'event'   |'countryJN3'|false         |true          |404                    |200                 |'test-1'|'get'|
|'v303'  |'REGTEST_JGateN4'|'customer'|'countryJN4'|true          |true          |200                    |200                 |'test-1'|'get'|

@NGINXJetStarComplete @parallel=false @All @NGINX @JetstarNGINX
Scenario Outline: External NGINX Gateway with POST
#Register an API 
Given url Admin
* json myReq = read('Swagger-JetStarNGINX.json')
* def name = '2-' + now()
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
* def responseFromJetStarNGINXExternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarNGINXExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' ,'requestMethod': '#(requestMethod)' }

#Invoke API through NGINX Internal Gateway
* def responseFromJetStarNGINXInternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarNGINXInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' ,'requestMethod': '#(requestMethod)'  }

* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
Examples:
|version |title           |domain    |basepath    |externalFlag  |internalFlag  |externalGatewayResponse|internalGatewayResponse|path|method|
|'v304'  |'REGTEST_JGate5'|'test'    |'countryJN5'|true          |false         |200                 |404                 |'test-1'|'post'|
|'v305'  |'REGTEST_JGate6'|'partner' |'countryJN6'|false         |false         |404                 |404                 |'test-1'|'post'|
|'v306'  |'REGTEST_JGate7'|'event'   |'countryJN7'|false         |true          |404                 |200                 |'test-1'|'post'|
|'v307'  |'REGTEST_JGate8'|'customer'|'countrtJN8'|true          |true          |200                 |200                 |'test-1'|'post'|

@NGINXJetStarComplete @parallel=false @All @NGINX @JetstarNGINX
Scenario Outline: External NGINX Gateway with DELETE
#Register an API
Given url Admin
* json myReq = read('Swagger-JetStarNGINX.json')
* def name = '3-' + now()
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
* def responseFromJetStarNGINXExternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarNGINXExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' ,'requestMethod': '#(requestMethod)' }

#Invoke API through NGINX Internal Gateway
* def responseFromJetStarNGINXInternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarNGINXInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' ,'requestMethod': '#(requestMethod)'  }

* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
Examples:
|version|title            |domain    |basepath     |externalFlag  |internalFlag  |externalGatewayResponse|internalGatewayResponse|path|method|
|'v308' |'REGTEST_JGate9' |'test'    |'countryJN9' |true          |false         |200                 |404                 |'test2'|'delete'|
|'v309' |'REGTEST_JGate10'|'partner' |'countryJN10'|false         |false         |404                 |404                 |'test2'|'delete'|
|'v310' |'REGTEST_JGate11'|'event'   |'countryJN11'|false         |true          |404                 |200                 |'test2'|'delete'|
|'v311' |'REGTEST_JGate12'|'customer'|'countrtJN12'|true          |true          |200                 |200                 |'test2'|'delete'|


@NGINXJetStarComplete @parallel=false @All @NGINX @JetstarNGINX
Scenario Outline: External NGINX Gateway with PUT
#Register an API
Given url Admin
* json myReq = read('Swagger-JetStarNGINX.json')
* def name = '4-' + now()
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
* def responseFromJetStarNGINXExternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarNGINXExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' ,'requestMethod': '#(requestMethod)' }

#Invoke API through NGINX Internal Gateway
* def responseFromJetStarNGINXInternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarNGINXInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' ,'requestMethod': '#(requestMethod)'  }

* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
Examples:
|version|title              |domain    |basepath      |externalFlag  |internalFlag  |externalGatewayResponse|internalGatewayResponse|path|method|
|'v312'  |'REGTEST_JGate13' |'test'    |'countryJN13' |true          |false         |200                 |404                 |'test2'|'put'|
|'v313'  |'REGTEST_JGate14' |'partner' |'countryJN14' |false         |false         |404                 |404                 |'test2'|'put'|
|'v314'  |'REGTEST_JGate15' |'event'   |'countryJN15' |false         |true          |404                 |200                 |'test2'|'put'|
|'v315'  |'REGTEST_JGate16' |'customer'|'countrtJN16' |true          |true          |200                 |200                 |'test2'|'put'|

@NGINXJetStarComplete @parallel=false @All @NGINX @JetstarNGINX
Scenario Outline: External NGINX Gateway with PATCH
#Register an API
Given url Admin
* json myReq = read('Swagger-JetStarNGINX.json')
* def name = '5-' + now()
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
* def responseFromJetStarNGINXExternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarNGINXExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' ,'requestMethod': '#(requestMethod)' }

#Invoke API through NGINX Internal Gateway
* def responseFromJetStarNGINXInternalWSO2Gateway = call read('classpath:examples/Services/InvokeJetStarNGINXInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' ,'requestMethod': '#(requestMethod)'  }

* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
Examples: 
|version|title              |domain    |basepath      |externalFlag  |internalFlag  |externalGatewayResponse|internalGatewayResponse|path|method|
|'v316'  |'REGTEST_JGate17' |'test'    |'countryJN17' |true          |false         |200                 |404                 |'test2'|'patch'|
|'v317'  |'REGTEST_JGate18' |'partner' |'countryJN18' |false         |false         |404                 |404                 |'test2'|'patch'|
|'v318'  |'REGTEST_JGate19' |'event'   |'countryJN19' |false         |true          |404                 |200                 |'test2'|'patch'|
|'v319'  |'REGTEST_JGate20' |'customer'|'countrtJN20' |true          |true          |200                 |200                 |'test2'|'patch'|


