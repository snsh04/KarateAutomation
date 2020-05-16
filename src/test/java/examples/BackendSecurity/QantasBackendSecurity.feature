Feature: This feature tests the random backend Security by setting secure username and password in the Auth setting and make sure that the security is et even after updates.

Background:
#* configure afterFeature = function(){ karate.call('BackendSecurity-Cleanup.feature');karate.call('BackendSecurity-Cleanup.feature');karate.call('BackendSecurity-Cleanup.feature'); }

#---------------------------------------------------------------------------------
#****************------ PUBLISHER ---------*****************
@Backend @All @parallel=false  @randomBackend
Scenario: Check the definition from the publisher 
Given url Admin
And request read('Swagger-Backend.json')
When method post
Then status 200

#Get APIID
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'REGTEST_Secure'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

#Validate the API definition 
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': 'REGTEST_Secure'  }
* match DefFromPub.response.endpointSecurity == '#null'
* print 'Endpoint security is null'

# update API definition in publisher
Given url PublisherURL
And path APIIDPub
* def auth = callonce read('classpath:examples/Tokens/CreateToken.feature') {'createAccessToken': 'createAccessToken'  } 
* print 'auth token for large swagger' , auth.createAccessToken
And  header Authorization = auth.createAccessToken
And request read('Swagger-updateSecurity.json')
When method put
Then status 200

#Validate the API definition 
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': 'REGTEST_Secure'  }
* match DefFromPub.response.endpointSecurity == '#notnull'
* print 'Endpoint security is  not null and contains', DefFromPub.response.endpointSecurity
* match DefFromPub.response.endpointSecurity.username == 'regtest'
#* match DefFromPub.response.endpointSecurity.password == 'secretshhh'

#Invoke internal gateway
* def responseFromJetStarInternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomInternalWSO2Gateway.feature') {'domain': 'partner' , 'basepath': 'secure' , 'path': 'v1/country/countries' , 'internalGatewayResponse': '200' , 'requestMethod': 'get'  }


#Invoke external gateway
* def responseFromJetStarExternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomExternalWSO2Gateway.feature') {'domain': 'partner' , 'basepath': 'secure' , 'path': 'v1/country/countries' , 'externalGatewayResponse': '200' , 'requestMethod': 'get'  }
 
 @Backend @All @parallel=false @randomBackend
Scenario Outline: Update API and check that security is still set 
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = 'REGTEST_REGTEST'
And header apigateway-basepath = 'secure'
* json myReq = read('Swagger-Backend.json')
* set myReq.swagger.info.version = <version>
* set myReq.swagger.info.description = <description>
* set myReq.apiConf.defaultVersion = <defaultVersion>
* set myReq.apiConf.includeVersion = <includeVersion>
And request myReq
When method post
Then status 200
* call read('classpath:examples/Polling/Polling.feature') 

* def domain = <domain>
* def basepath = <basepath>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def requestMethod = <method>
* def path = <path>

#Get APIID
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'REGTEST_Secure'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

# update API definition in publisher
Given url PublisherURL
And path APIIDPub
* def auth = call read('classpath:examples/Tokens/CreateToken.feature') {'createAccessToken': 'createAccessToken'  } 
* print 'auth token for large swagger' , auth.createAccessToken
And  header Authorization = auth.createAccessToken
And request read('<Scenario>.json')
When method put
Then status 200

#Validate the API definition 
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': 'REGTEST_Secure'  }
* match DefFromPub.response.endpointSecurity == '#notnull'
* print 'Endpoint security is  not null and contains', DefFromPub.response.endpointSecurity
* match DefFromPub.response.endpointSecurity.username == <username>
#* match DefFromPub.response.endpointSecurity.password == <password>


#Invoke internal gateway
* def responseFromInternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' , 'method': '#(requestMethod)'  }


#Invoke external gateway
* def responseFromExternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'method': '#(requestMethod)'  }


#Invoke NGINX internal
#* def responseFromNGINXInternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXInternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'internalGatewayResponse': '#(internalGatewayResponse)' , 'method': '#(requestMethod)'  }
#* match responseFromNGINXInternalWSO2Gateway.responseStatus == internalGatewayResponse

#Invoke internal gateway
#* def responseFromNGINXExternalWSO2Gateway = call read('classpath:examples/Services/InvokerandomNGINXExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '#(externalGatewayResponse)' , 'method': '#(requestMethod)'  }
#* match responseFromNGINXExternalWSO2Gateway.responseStatus == externalGatewayResponse

* call read('classpath:examples/Polling/Polling.feature')
Examples:
|Scenario                     |version|defaultVersion|includeVersion|description       |internalGatewayResponse|externalGatewayResponse|path                  |domain   |basepath   |method|username |password    |
|Swagger-updateSecurity       |'v2'   |true          |true          |'I am changed'    |200                    |200                    |'v2/country/countries'|'partner'|'secure'   |'get' |'regtest'|'secretshhh'|
|Swagger-updateInvalidSecurity|'v3'   |false         |false         |'I am not changed'|401                    |401                    |'v3/country/countries'|'partner'|'secure'   |'get' |'regt'   |'secret'    |
|Swagger-updateInvalidUsername|'v2'   |false         |true          |'I am changed'    |401                    |401                    |'v2/country/countries'|'partner'|'secure'   |'get' |'reg'    |'secretshhh'|
|Swagger-updateInvalidPassword|'v2'   |true          |false         |'I am not changed'|401                    |401                    |'v2/country/countries'|'partner'|'secure'   |'get' |'regtest'|'secret'    |