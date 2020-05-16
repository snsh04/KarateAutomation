Feature: Delete Applications

Background:


Scenario: delete pplication
# delete
Given url applicationURL + '/applications/'
* def auth = call read('classpath:examples/Tokens/SubscribeToken.feature') {'subscribeToken': 'subscribeToken'  }
* print ' auth create for deleting Admins API' , auth.subscribeToken
* header Authorization = auth.subscribeToken
When method get
Then status 200
* def list = $..[?(@.name contains 'Test-')]
* def applicationId = list[0].applicationId 
Given url applicationURL + '/applications/'
And path applicationId
* def auth = call read('classpath:examples/Tokens/SubscribeToken.feature') {'subscribeToken': 'subscribeToken'  }
* print ' auth create for deleting Admins API' , auth.subscribeToken
* header Authorization = auth.subscribeToken
When method delete
Then status 200

