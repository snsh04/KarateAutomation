Feature: Invoke Internal

Background: 
* def now = function(){ return java.lang.System.currentTimeMillis() }
* configure retry = { count: 7, interval: 5000 }

@parallel=false
Scenario: Invoke external 
#Invoke internal gateway
Given url jetstarInternalGateway
And path domain + '/' + basepath + '/' +  path
And header Authorization = accessTokenforProd
* request 'test'
* retry until responseStatus == internalGatewayResponse
When method requestMethod
* print ' response code from JetStar Internal Gateway: ' , responseStatus