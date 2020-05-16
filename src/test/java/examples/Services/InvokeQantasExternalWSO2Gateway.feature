Feature: Invoke random External

Background: 
* configure retry = { count: 7, interval: 5000 }

@parallel=false
Scenario: Generate invokation random External
#Invoke External gateway
Given url externalGateway
And path domain + '/' + basepath + '/' +  path
* request 'test'
* retry until responseStatus == externalGatewayResponse
When method requestMethod
* print ' response code from random External Gateway: ' , responseStatus