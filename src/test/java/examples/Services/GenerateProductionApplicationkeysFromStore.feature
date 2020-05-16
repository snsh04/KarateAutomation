Feature: Generates Production  keys for the application
# needs ApplicationID
# needs 

Background:
# Not required
@parallel=false
Scenario: Generate Production Keys 
Given url applicationURL + '/applications/generate-keys?'
And param applicationId = applicationID
* def auth = call read('classpath:examples/Tokens/SubscribeToken.feature') {'subscribeToken': 'subscribeToken'  }
* print ' auth create for deleting Admins API' , auth.subscribeToken
* header Authorization = auth.subscribeToken
And request {"validityTime": "3600","keyType": "PRODUCTION","accessAllowDomains": ["ALL"],"scopes": [ "am_application_scope", "default" ],"supportedGrantTypes": [ "urn:ietf:params:oauth:grant-type:saml2-bearer", "iwa:ntlm", "refresh_token", "client_credentials", "password" ]}
When method post
Then status 200
* def accessTokenforProd = 'Bearer '+ response.token.accessToken
* print 'accessTokenforProd is ', accessTokenforProd
