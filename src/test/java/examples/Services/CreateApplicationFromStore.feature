@parallel=false
Feature: Create Application from the Store

Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }
# Not required

Scenario: Create Application
#Create an Application
Given url applicationURL
And path 'applications'
* def auth = callonce read('classpath:examples/Tokens/SubscribeToken.feature') {'subscribeToken': 'subscribeToken'  }
* print ' auth create for deleting Admins API' , auth.subscribeToken
* header Authorization = auth.subscribeToken
* def name = 'Test-' + now()
And request {"throttlingTier": "Unlimited","description": "sample app description","name": '#(name)' ,"callbackUrl": "https:/apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com/callback"}
When method post
Then status 201
* def applicationId = response.applicationId
* print 'applicationId is ', applicationId

