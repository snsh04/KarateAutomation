Feature: Invoke External

Background: 
* def now = function(){ return java.lang.System.currentTimeMillis() }
* configure retry = { count: 7, interval: 5000 }

@parallel=false
Scenario: Generate invokation
#Invoke internal gateway
Given url externalGateway
And path domain + '/' + basepath + '/' +  path
And header Authorization = accessTokenforSandbox
* request 'test'
* retry until responseStatus == externalGatewayResponse
When method requestMethod
* print ' response code from random External Gateway: ' , responseStatus