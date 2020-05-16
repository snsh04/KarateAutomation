Feature: Remove Subscription

Background:
# Not required

@parallel=false
Scenario: Remove Subscription

* call read('pollingAPIIDAdmin.feature') {title: '#(title)' }
Given  url PublisherURL + '?' 
And  param query = 'name:' + title 
* def auth = call read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken'  }
* print ' auth token to fetch an API' , auth.viewAccessToken
And  header Authorization = auth.viewAccessToken
When  method get 
Then  status 200 
* def APIIDPub = response.list[0].id 
* print 'APIID from Publisher is: ' , APIIDPub 

#Retrieve API Definition
Given  url PublisherURL 
And  path APIIDPub 
* def auth = call read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken'  }
* print ' auth token to fetch an API' , auth.viewAccessToken
And  header Authorization = auth.viewAccessToken
When  method get 
Then  status 200 
#* def status = response.status 
#* print 'Status : ' , status
#* def tiers = response.tiers
#* print 'tier : ' , tiers
