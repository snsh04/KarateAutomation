Feature: NGINX External throwing SSL handshake error 

Background:
# Not required
@parallel=false
Scenario: NGINX External throwing SSL handshake error 
Given url gatewayNGINX
And path domain + '/' + basepath + '/' +  'v1/countries'
And header Host = 'api-test.random.com'
And header rubbishheader = 'nothingbutrubbishheader'
And param rubbishparam = 'nothingbutrubbishparam'
And form field username = 'nobody'
And form field password = 'idonotexist'
And form field test = '(~`!@$%^%26*()_+-={}[]|\:";,./<>?12a3567890345)'
* request 'test'
When method get
