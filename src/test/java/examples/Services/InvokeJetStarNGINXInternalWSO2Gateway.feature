Feature: Jetstar Internal

Background:
# Not required

@parallel=false
Scenario: JetStar Internl
* configure retry = { count: 7, interval: 5000 }
Given url jetstarGatewayNGINX
And path domain + '/' + basepath + '/' +  path
And header rubbishheader = 'nothingbutrubbishheader'
And param rubbishparam = 'nothingbutrubbishparam'
And form field username = 'nobody'
And form field password = 'idonotexist'
And form field test = '(~`!@$%^%26*()_+-={}[]|\:";,./<>?12a3567890345)'
* request 'test'
* retry until responseStatus == internalGatewayResponse
When method requestMethod
* print ' response code from jetStar NGINX Internal Gateway: ' , responseStatus
