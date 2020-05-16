Feature: Get the definition from Publisher
# pre requisites
# needs applicationID
# needs APIID from the store

Background:
# Not required

@parallel=false
Scenario: Get Defintion


Given url applicationURL
And path 'subscriptions'
* def auth = call read('classpath:examples/Tokens/SubscribeToken.feature') {'subscribeToken': 'subscribeToken'  }
* print ' auth create for deleting Admins API' , auth.subscribeToken
* header Authorization = auth.subscribeToken
And request {'tier': 'Bronze_Auto-Approved','apiIdentifier': '#(APIIDStr)','applicationId': '#(applicationID)'}
When method post
Then status 201
* def subscriptionId = response.subscriptionId
* print 'subscriptionID is ', subscriptionId 
* def status = response.status
* print 'subscribed with status ', status , ' and subscriptionID ' , subscriptionId
