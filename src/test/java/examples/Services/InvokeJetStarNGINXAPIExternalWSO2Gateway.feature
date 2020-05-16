Feature: Invoke Jetstar External

Background:
# Not required

@parallel=false
Scenario: Invoke Jetstar External
# Invoke External NGINX gateway
* configure retry = { count: 7, interval: 5000 }
Given url jetstarGatewayNGINXAPI
And path domain + '/' + basepath + '/' +  path
And header Host = 'apis-test.jetstar.com'
And header rubbishheader = 'nothingbutrubbishheader'
And param rubbishparam = 'nothingbutrubbishparam'
And form field username = 'nobody'
And form field password = 'idonotexist'
And form field test = '(~`!@$%^%26*()_+-={}[]|\:";,./<>?12a3567890345)'
* request 'test'
* retry until responseStatus == externalGatewayResponse
When method requestMethod
* print ' response code from jetStar NGINX External Gateway: ' , responseStatus
