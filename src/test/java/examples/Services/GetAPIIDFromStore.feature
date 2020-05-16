Feature: Get the API ID from Store

Background:
* configure retry = { count: 5 , interval: 5000 }

@parallel=false
Scenario: Get APIID from Store 
##----------**Get API ID**--------------------------------------##

Given url storeURL
And param query = 'name:' + title
* def auth = callonce read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken'  } 
* print 'auth token for large swagger' , auth.viewAccessToken
And  header Authorization = auth.viewAccessToken 
* print 'viewToken is: ', auth.viewAccessToken
* retry until responseStatus == 200 && response.list[0].id != ''
When method get 
* def APIIDStr = response.list[0].id 
* def responseCode = responseStatus
* print 'APIID from Store is: ' , APIIDStr
