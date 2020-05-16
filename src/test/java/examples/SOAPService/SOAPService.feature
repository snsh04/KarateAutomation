Feature: SOAPServices

Background:

#-----------------@@@@@@@ SOAP BACKEND @@@@@@@@@ ------------#

#-----------------@@@@@@@ random INTERNAL INVOKATION @@@@@@@@@ ------------#

@parellel=false @SOAP
Scenario: SOAP API
* def DemoClass = Java.type('examples.SOAPService.SOAPService')

* def myVar = DemoClass.main()

#Get the APIID from Store
* call read('classpath:examples/Polling/Polling.feature')
* call read('classpath:examples/Polling/Polling.feature')
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': 'SOAPBackendTest'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr


# create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature')
* def applicationID = applicationDetails.response.applicationId

# generate  prod keys
* def applicationKeyDetailsProd = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforProd = 'Bearer '+ applicationKeyDetailsProd.response.token.accessToken
* def accessTokenforProd = accessTokenforProd
* print ' prod keys ', accessTokenforProd


# generate sandbox keys
* def applicationKeyDetailsSandbox = call read('classpath:examples/Services/GenerateSandboxApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforSandbox = 'Bearer '+ applicationKeyDetailsSandbox.response.token.accessToken
* def accessTokenforSandbox = accessTokenforSandbox
* print ' Sand keys ', accessTokenforSandbox

# subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
* def subscriptionId = subscriptionDetails.response.subscriptionId


#### 1. Invoking SOAP API using random internal Gateway
Given url internalGateway
And path '/test/countrySOAPTest/v1/'
And header Authorization = accessTokenforProd
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
And match /Envelope/Body/getCountriesResponse/countries[1]/name == 'Poland'
#And print 'response: ', response

#-----------------@@@@@@@ random INTERNAL INVOKATION @@@@@@@@@ ------------#
#### 2. Invoking SOAP API using random external Gateway
Given url externalGateway
And path '/test/countrySOAPTest/v1/'
And header Authorization = accessTokenforProd
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
#And match /Envelope/Body/AddResponse/AddResult == 5
#And print 'response: ', response

#-----------------@@@@@@@ JETSTAR INTERNAL INVOKATION @@@@@@@@@ ------------#
#### 3. Invoking SOAP API using Jetstar internal Gateway
Given url jetstarInternalGateway
And path '/test/countrySOAPTest/v1/'
And header Authorization = accessTokenforProd
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
And match /Envelope/Body/getCountriesResponse/countries[1]/name == 'Poland'
#And print 'response: ', response

#-----------------@@@@@@@ JETSTAR EXTERNAL INVOKATION @@@@@@@@@ ------------#
#### 4. Invoking SOAP API using Jetstar external Gateway
Given url jetstarExternalGateway
And path '/test/countrySOAPTest/v1/'
And header Authorization = accessTokenforProd
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
And match /Envelope/Body/getCountriesResponse/countries[1]/name == 'Poland'
#And print 'response: ', response


#-----------------@@@@@@@ random INTERNAL NGINX INVOKATION @@@@@@@@@ ------------#
#### 5. Invoking SOAP API using random internal Gateway
Given url gatewayNGINX
And path '/test/countrySOAPTest/v1/'
And header Authorization = accessTokenforProd
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
Then status 200
And match /Envelope/Body/getCountriesResponse/countries[1]/name == 'Poland'
#And print 'response: ', response

#-----------------@@@@@@@ random INTERNAL NGINX INVOKATION @@@@@@@@@ ------------#
#### 6. Invoking SOAP API using random external Gateway
Given url gatewayNGINX
And path '/test/countrySOAPTest/v1/'
And header Authorization = accessTokenforProd
And header host = 'api-test.random.com'
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
Then status 200
And match /Envelope/Body/getCountriesResponse/countries[1]/name == 'Poland'
#And print 'response: ', response

#-----------------@@@@@@@ JETSTAR INTERNAL NGINX INVOKATION @@@@@@@@@ ------------#
#### 7. Invoking SOAP API using Jetstar internal Gateway
Given url jetstarGatewayNGINX
And path '/test/countrySOAPTest/v1/'
And header Authorization = accessTokenforProd
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
Then status 200
And match /Envelope/Body/getCountriesResponse/countries[1]/name == 'Poland'
#And print 'response: ', response

#-----------------@@@@@@@ JETSTAR EXTERNAL NGINX INVOKATION @@@@@@@@@ ------------#
#### 8. Invoking SOAP API using Jetstar external Gateway
Given url jetstarGatewayNGINX
And path '/test/countrySOAPTest/v1/'
And header Authorization = accessTokenforProd
And header host = 'apis-test.jetstar.com'
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
Then status 200
And match /Envelope/Body/getCountriesResponse/countries[1]/name == 'Poland'
#And print 'response: ', response

#-----------------@@@@@@@ JETSTAR EXTERNAL NGINX INVOKATION @@@@@@@@@ ------------#
#### 9. Invoking SOAP API using Jetstar external Gateway
Given url jetstarGatewayNGINX
And path '/test/countrySOAPTest/v1/'
And header Authorization = accessTokenforProd
And header host = 'apis-test.jetstar.com'
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
And match /Envelope/Body/getCountriesResponse/countries[1]/name == 'Poland'
#And print 'response: ', response

#-----------------@@@@@@@ SANDBOX INVOKATION @@@@@@@@@ ------------#
#### 10. Invoking SOAP API using  external Gateway
Given url externalGateway
And path  '/test/countrySOAPTest/v1/'
And header Authorization = accessTokenforSandbox
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
And match /Envelope/Body/getCountriesResponse/countries[1]/name == 'Poland'
#And print 'response: ', response


#-----------------@@@@@@@ SINGLE COUNTRY BODY @@@@@@@@@ ------------#
#### 11. Invoking SOAP API using  external Gateway
Given url externalGateway
And path '/test/countrySOAPTest/v1/'
And header Authorization = accessTokenforSandbox
And request read('SOAPRequestCountry.xml')
When soap action 'getCountryRequest'
Then status 200
#And match /Envelope/Body/getCountryRequest/country/name == 'Spain'
#And print 'response: ', response

#-----------------@@@@@@@ EMPTY BODY @@@@@@@@@ ------------#
#### 12. Invoking SOAP API using Jetstar external Gateway
Given url externalGateway
And path  '/test/countrySOAPTest/v1/'
And header Authorization = accessTokenforSandbox
And request read('SOAPRequestCountryEmpty.xml')
When soap action 'getCountryRequest'
Then status 404


#-----------------@@@@@@@ WSSECURITY USERNAME @@@@@@@@@ ------------#
#### 13. Invoking SOAP API using Jetstar external Gateway
Given url externalGateway
And path  '/test/countrySOAPTest/v1/'
And header Authorization = accessTokenforSandbox
And request read('SOAPRequestWSSecurityUsername.xml')
When soap action 'getCountriesRequest'
Then status 500
And match /Envelope/Body/Fault/faultstring contains 'The security token could not be authenticated or authorized'

#-----------------@@@@@@@ WSSECURITY PASSWORD @@@@@@@@@ ------------#
#### 14. Invoking SOAP API using Jetstar external Gateway
Given url externalGateway
And path  '/test/countrySOAPTest/v1/'
And header Authorization = accessTokenforSandbox
And request read('SOAPRequestWSSecurityPassword.xml')
When soap action 'getCountriesRequest'
Then status 500
And match /Envelope/Body/Fault/faultstring contains 'The security token could not be authenticated or authorized'

#-----------------@@@@@@@  NO WSSECURITY  @@@@@@@@@ ------------#
#### 15. Invoking SOAP API using Jetstar external Gateway
Given url externalGateway
And path  '/test/countrySOAPTest/v1/'
And header Authorization = accessTokenforSandbox
And request read('SOAPRequestEmptyWSSecurity.xml')
When soap action 'getCountriesRequest'
Then status 500
And match /Envelope/Body/Fault/faultstring contains 'The security token could not be authenticated or authorized'

#-----------------@@@@@@@  EMPTY HEADER  @@@@@@@@@ ------------#
#### 16. Invoking SOAP API using Jetstar external Gateway
Given url externalGateway
And path  '/test/countrySOAPTest/v1/'
And header Authorization = accessTokenforSandbox
And request read('SOAPRequestNoWSSecurity.xml')
When soap action 'getCountriesRequest'
Then status 500
And match /Envelope/Body/Fault/faultstring == 'No WS-Security header found'

####### ----------------------------------------------------#######
@parellel=false @SOAP
Scenario: Unauthenticated SOAP API
#* def DemoClass = Java.type('examples.SOAPService.SOAPService')

#* def myVar = DemoClass.main()


#### 1. Invoking SOAP API using random internal Gateway
Given url internalGateway
And path '/notification/countryNoAuthSOAP/v1/*'
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
And match /Envelope/Body/getCountriesResponse/countries[1]/name == 'Poland'
#And print 'response: ', response

#-----------------@@@@@@@ random INTERNAL INVOKATION @@@@@@@@@ ------------#
#### 2. Invoking SOAP API using random external Gateway
@parellel=false @SOAP
Scenario: Unauthenticated SOAP API
Given url externalGateway
And path '/notification/countryNoAuthSOAP/v1/*'
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
#And match /Envelope/Body/AddResponse/AddResult == 5
#And print 'response: ', response

#-----------------@@@@@@@ JETSTAR INTERNAL INVOKATION @@@@@@@@@ ------------#
#### 3. Invoking SOAP API using Jetstar internal Gateway
@parellel=false @SOAP
Scenario: Unauthenticated SOAP API
Given url jetstarInternalGateway
And path '/notification/countryNoAuthSOAP/v1/*'
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
And match /Envelope/Body/getCountriesResponse/countries[1]/name == 'Poland'
#And print 'response: ', response

#-----------------@@@@@@@ JETSTAR EXTERNAL INVOKATION @@@@@@@@@ ------------#
#### 4. Invoking SOAP API using Jetstar external Gateway
@parellel=false @SOAP
Scenario: Unauthenticated SOAP API
Given url jetstarExternalGateway
Scenario: Unauthenticated SOAP API
And path '/notification/countryNoAuthSOAP/v1/*'
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
And match /Envelope/Body/getCountriesResponse/countries[1]/name == 'Poland'
#And print 'response: ', response


#-----------------@@@@@@@ random INTERNAL NGINX INVOKATION @@@@@@@@@ ------------#
#### 5. Invoking SOAP API using random internal Gateway
@parellel=false @SOAP
Scenario: Unauthenticated SOAP API
Given url gatewayNGINX
And path '/notification/countryNoAuthSOAP/v1/*'
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
Then status 200
And match /Envelope/Body/getCountriesResponse/countries[1]/name == 'Poland'
#And print 'response: ', response

#-----------------@@@@@@@ random INTERNAL NGINX INVOKATION @@@@@@@@@ ------------#
#### 6. Invoking SOAP API using random external Gateway
@parellel=false @SOAP
Scenario: Unauthenticated SOAP API
Given url gatewayNGINX
And path '/notification/countryNoAuthSOAP/v1/*'
And header host = 'api-test.random.com'
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
Then status 200
And match /Envelope/Body/getCountriesResponse/countries[1]/name == 'Poland'
#And print 'response: ', response

#-----------------@@@@@@@ JETSTAR INTERNAL NGINX INVOKATION @@@@@@@@@ ------------#
#### 7. Invoking SOAP API using Jetstar internal Gateway
@parellel=false @SOAP
Scenario: Unauthenticated SOAP API
Given url jetstarGatewayNGINX
And path '/notification/countryNoAuthSOAP/v1/*'
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
Then status 200
And match /Envelope/Body/getCountriesResponse/countries[1]/name == 'Poland'
#And print 'response: ', response

#-----------------@@@@@@@ JETSTAR EXTERNAL NGINX INVOKATION @@@@@@@@@ ------------#
#### 8. Invoking SOAP API using Jetstar external Gateway
@parellel=false @SOAP
Scenario: Unauthenticated SOAP API
Given url jetstarGatewayNGINX
And path '/notification/countryNoAuthSOAP/v1/*'
And header host = 'apis-test.jetstar.com'
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
Then status 200
And match /Envelope/Body/getCountriesResponse/countries[1]/name == 'Poland'
#And print 'response: ', response

#-----------------@@@@@@@ JETSTAR EXTERNAL NGINX INVOKATION @@@@@@@@@ ------------#
#### 9. Invoking SOAP API using Jetstar external Gateway
@parellel=false @SOAP
Scenario: Unauthenticated SOAP API
Given url jetstarGatewayNGINX
And path '/notification/countryNoAuthSOAP/v1/*'
And header host = 'apis-test.jetstar.com'
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
And match /Envelope/Body/getCountriesResponse/countries[1]/name == 'Poland'
#And print 'response: ', response

#-----------------@@@@@@@ SANDBOX INVOKATION @@@@@@@@@ ------------#
#### 10. Invoking SOAP API using  external Gateway
@parellel=false @SOAP
Scenario: Unauthenticated SOAP API
Given url externalGateway
And path  '/notification/countryNoAuthSOAP/v1/*'
And request read('SOAPRequest.xml')
When soap action 'getCountriesRequest'
Then status 200
And match /Envelope/Body/getCountriesResponse/countries[1]/name == 'Poland'
#And print 'response: ', response


#-----------------@@@@@@@ SINGLE COUNTRY BODY @@@@@@@@@ ------------#
#### 11. Invoking SOAP API using  external Gateway
@parellel=false @SOAP
Scenario: Unauthenticated SOAP API
Given url externalGateway
And path '/notification/countryNoAuthSOAP/v1/*'
And request read('SOAPRequestCountry.xml')
When soap action 'getCountryRequest'
Then status 200
#And match /Envelope/Body/getCountryRequest/country/name == 'Spain'
#And print 'response: ', response

#-----------------@@@@@@@ EMPTY BODY @@@@@@@@@ ------------#
#### 12. Invoking SOAP API using Jetstar external Gateway
@parellel=false @SOAP
Scenario: Unauthenticated SOAP API
Given url externalGateway
And path  '/notification/countryNoAuthSOAP/v1/*'
And request read('SOAPRequestCountryEmpty.xml')
When soap action 'getCountryRequest'
Then status 404


#-----------------@@@@@@@ WSSECURITY USERNAME @@@@@@@@@ ------------#
#### 13. Invoking SOAP API using Jetstar external Gateway
@parellel=false @SOAP
Scenario: Unauthenticated SOAP API
Given url externalGateway
And path  'notification/countryNoAuthSOAP/v1/*'
And request read('SOAPRequestWSSecurityUsername.xml')
When soap action 'getCountriesRequest'
Then status 500
And match /Envelope/Body/Fault/faultstring contains 'The security token could not be authenticated or authorized'

#-----------------@@@@@@@ WSSECURITY PASSWORD @@@@@@@@@ ------------#
#### 14. Invoking SOAP API using Jetstar external Gateway
@parellel=false @SOAP
Scenario: Unauthenticated SOAP API
Given url externalGateway
And path  '/notification/countryNoAuthSOAP/v1/*'
And request read('SOAPRequestWSSecurityPassword.xml')
When soap action 'getCountriesRequest'
Then status 500
And match /Envelope/Body/Fault/faultstring contains 'The security token could not be authenticated or authorized'

#-----------------@@@@@@@  NO WSSECURITY  @@@@@@@@@ ------------#
#### 15. Invoking SOAP API using Jetstar external Gateway
@parellel=false @SOAP
Scenario: Unauthenticated SOAP API
Given url externalGateway
And path  '/notification/countryNoAuthSOAP/v1/*'
And request read('SOAPRequestEmptyWSSecurity.xml')
When soap action 'getCountriesRequest'
Then status 500
And match /Envelope/Body/Fault/faultstring contains 'The security token could not be authenticated or authorized'

#-----------------@@@@@@@  EMPTY HEADER  @@@@@@@@@ ------------#
#### 16. Invoking SOAP API using Jetstar external Gateway
@parellel=false @SOAP
Scenario: Unauthenticated SOAP API
Given url externalGateway
And path  '/notification/countryNoAuthSOAP/v1/*'
And request read('SOAPRequestNoWSSecurity.xml')
When soap action 'getCountriesRequest'
Then status 500
And match /Envelope/Body/Fault/faultstring == 'No WS-Security header found'
