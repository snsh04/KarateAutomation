Feature: Get the API ID from Publisher

Background:
# Not required
@parallel=false
Scenario: Get APPIID
##----------**Get API ID**--------------------------------------##
* configure retry = { count: 5, interval: 5000 }
Given  url PublisherURL + '?' 
And  param query = 'name:' + title
* def auth = callonce read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken' }
* print ' view token ' , auth.viewAccessToken
* header Authorization = auth.viewAccessToken
* retry until responseStatus == 200 && response.list[0].id != ''
When method get 
* def APIIDPub = response.list[0].id 
* def responseCode = responseStatus
* print 'APIID from Publisher is: ' , APIIDPub 