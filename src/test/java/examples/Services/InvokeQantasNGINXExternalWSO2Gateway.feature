Feature: Invoke external

Background: 
* def now = function(){ return java.lang.System.currentTimeMillis() }

@parallel=false
Scenario: Generate invokation external
#Invoke External NGINX gateway
* configure retry = { count: 7, interval: 5000 }
Given url gatewayNGINX
And path domain + '/' + basepath + '/' +  path
And header Host = 'api-test.random.com'
And header rubbishheader = 'nothingbutrubbishheader'
And param rubbishparam = 'nothingbutrubbishparam'
And form field username = 'nobody'
And form field password = 'idonotexist'
And form field test = '(~`!@$%^%26*()_+-={}[]|\:";,./<>?12a3567890345)'
* request 'test'
* retry until responseStatus == externalGatewayResponse
When method requestMethod
* print ' response code from random NGINX  External Gateway: ' , responseStatus
