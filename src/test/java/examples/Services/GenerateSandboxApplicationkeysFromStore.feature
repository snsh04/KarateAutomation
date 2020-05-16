Feature: Generates Sandbox keys for the application
# needs ApplicationID

Background:
# Not required
@parallel=false
Scenario: Generate Sandbox keys 
Given url applicationURL + '/applications/generate-keys?'
And param applicationId = applicationID
* def auth = call read('classpath:examples/Tokens/SubscribeToken.feature') {'subscribeToken': 'subscribeToken'  }
* print ' Subscribe token to generate sandbox keys ' , auth.subscribeToken
* header Authorization = auth.subscribeToken
And request {"validityTime": "3600","keyType": "SANDBOX","accessAllowDomains": ["ALL"]}
When method post
Then status 200
* def accessTokenforSandbox = 'Bearer '+ response.token.accessToken
* print 'accessTokenforSandbox is ', accessTokenforSandbox
