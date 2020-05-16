Feature: Delete Application

Background:
# Not required
@parallel=false
Scenario: Delete Application
* configure retry = { count: 5, interval: 5000 }
Given url applicationURL + '/applications/'
And path applicationID
* def auth = callonce read('classpath:examples/Tokens/SubscribeToken.feature') {'subscribeToken': 'subscribeToken'  }
* print ' auth create for deleting Admins API' , auth.subscribeToken
* header Authorization = auth.subscribeToken
* retry until responseStatus == 200 
When method delete
Then status 200

