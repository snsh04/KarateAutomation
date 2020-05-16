Feature: Slackbot APIS tests

Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }
* configure retry = { count: 5, interval: 5000 }

@parellel=false @regInfo
Scenario Outline: RegInfo API egistration
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = apiGatewayKey
And header apigateway-basepath = 'lambda-info'
* json myReq = read('<swagger>.json')
* set myReq.apiConf.subscriptionTiers = <subscriptionTiers>
* set myReq.swagger.info.title = 'Regtest_RegistrationInfo'
* set myReq.swagger.basePath = 'lambda-info'
* set myReq.swagger.info.version = 'v1'
And request myReq
When method post
* def registrationId = response.registrationId
* def basepath = 'lambda-info'
* def externalGatewayResponse = <externalGatewayResponse>

 #Get the APIID from Publisher
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'Regtest_RegistrationInfo'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher for JetStar Gateway API: ' , APPIDFromPublisher.APIIDPub

#Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': 'Regtest_RegistrationInfo'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for JetStar Gateway API: ' , APPIDFromStore.APIIDStr
 
#Invoke API
Given url gatewayNGINX
And path domain + '/' + basepath + '/' +  'regInfo'
And header Host = 'api-test.random.com'
And header registrationId = registrationId
* retry until responseStatus == externalGatewayResponse
When method requestMethod
* print ' response code from random NGINX  External Gateway: ' , responseStatus

# Delete the Application and API
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
Examples: 
| externalGatewayResponse |swagger               |
| 200                     |swagger-RegInfo       |
| 200                     |swagger-RegInvalidInfo|
| 404                     |                      |

