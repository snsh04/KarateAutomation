Feature: Invoke Gateway Internal

Background:
* configure retry = { count: 7, interval: 5000 }

@parallel=false
Scenario: Invoke Gateway Internal
#Invoke internal gateway
Given url internalGateway
And path domain + '/' + basepath + '/' +  path
* request 'test'
* retry until responseStatus == internalGatewayResponse
When method requestMethod
* print ' response code from random Internal Gateway: ' , responseStatus
