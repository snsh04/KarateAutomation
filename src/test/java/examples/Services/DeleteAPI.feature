Feature: Delete API

Background:
# Not required
@parallel=false
Scenario: Delete API
* configure retry = { count: 5, interval: 5000 }
Given url PublisherURL
And path APIIDPub
* def auth = callonce read('classpath:examples/Tokens/CreateToken.feature') {'createAccessToken': 'createAccessToken'  }
* print ' auth create for deleting Admins API' , auth.createAccessToken
* header Authorization = auth.createAccessToken
* retry until responseStatus == 200 
When method delete
