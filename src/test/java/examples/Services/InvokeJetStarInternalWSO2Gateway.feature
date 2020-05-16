Feature: Invoke JetStar Internal

Background:
# Not required

@parallel=false
Scenario: Invoke Jetstar Internal
* configure retry = { count: 7, interval: 5000 }
Given url jetstarInternalGateway
And path domain + '/' + basepath + '/' +  path
* request 'test'
* retry until responseStatus == internalGatewayResponse
When method requestMethod
* print ' response code from jetStar Internal Gateway: ' , responseStatus
