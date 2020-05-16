Feature: Get the definition from SandboxPublisher

Background:
# Not required
@parallel=false
Scenario: Get Defintion
* configure retry = { count: 5, interval: 5000 }
Given  url PublisherURL + '?' 
#And  param query = 'name:' + title 
And  path 'admin-AT-carbon.super' + '-' + title + '-' + version
#And  path 'admin' + '-' + title + '-' + version
* def auth = callonce read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken' }
* print ' auth token ' , auth.viewAccessToken
* header Authorization = auth.viewAccessToken
* retry until responseStatus == 200
When  method get 
* print 'Response: ' , response 
* def APIIDPub = response.id 
* print 'APIID from Publisher is: ' , APIIDPub 

#Retrieve API Definition
Given  url PublisherURL 
And  path APIIDPub 
* def auth = callonce read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken' }
* print ' auth token ' , auth.viewAccessToken
* header Authorization = auth.viewAccessToken
When  method get 
* retry until responseStatus == 200


