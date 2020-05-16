Feature: Invoke External

Background:
# Not required

@parallel=false
Scenario: Invoke External
#Invoke External gateway
* configure retry = { count: 7, interval: 5000 }
Given url jetstarExternalGateway
And path domain + '/' + basepath + '/' +  path
* request 'test'
* retry until responseStatus == externalGatewayResponse
When method requestMethod
* print ' response code from jetStar External Gateway: ' , responseStatus
