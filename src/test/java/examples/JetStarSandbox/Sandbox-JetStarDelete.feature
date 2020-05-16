Feature: Create Token for view, create , delete , subscribe

Background: 
# not required
@delete
Scenario Outline: Create Token
#--------------------------------------------------------------------
##------------**Delete Application**----------------------------##
	#Change status to Deprecate

#* call read('JetStarAppdeleteApplication.feature')
##------------**Create Access Token**---------------------------##

#Given  url authURL 
#And  header Authorization = Authorization 
#And  form field grant_type = 'client_credentials' 
#And  form field scope = 'apim:api_view' 
#When  method post 
#Then  status 200 
#* def accessToken = 'Bearer ' + response.access_token 
#* print 'AccessToken is ' , accessToken 

##----------**Get API ID**--------------------------------------##

Given url PublisherURL + '?' 
* def title = <title>
* def version = <version>
And  path 'admin-AT-carbon.super' + '-' + title + '-' + version
* def auth = call read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken' }
* print ' auth token ' , auth.viewAccessToken
* header Authorization = auth.viewAccessToken
When  method get 
Then  status 200 
* def APIIDPub = response.id 
* print 'APIID from Publisher is: ' , APIIDPub 

# get definition
Given  url PublisherURL 
And  path APIIDPub 
* def auth = call read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken'  }
* print ' auth token to fetch an API' , auth.viewAccessToken
And  header Authorization = auth.viewAccessToken
When  method get 
Then  status 200 
* json myReq = response
* print 'my reuest ' , myReq

 Given url authURL 
	And header Authorization = Authorization 
	And form field grant_type = 'client_credentials' 
	And form field scope = 'apim:api_publish' 
	When method post 
	Then status 200 
	* def publishAccessToken = 'Bearer ' + response.access_token 
	* print 'publishAccessToken is ' , publishAccessToken 

	Given url PublisherURL + '/change-lifecycle' 
	And param apiId = APIIDPub
	And param action = 'Deprecate'
	And request myReq
	And header Authorization = publishAccessToken 
	When method post
	Then status 200
	
	#Change status to Retire
	Given url PublisherURL + '/change-lifecycle'
	And param apiId = APIIDPub
	And param action = 'Retire'
	And request myReq
	And header Authorization = publishAccessToken 
	When method post
	Then status 200
	

##--------------** Get delete token **------------------##

#Given url authURL 
#And  header Authorization = Authorization 
#And  form field grant_type = 'client_credentials' 
#And  form field scope = 'apim:api_create' 
#When  method post 
#Then  status 200 
#* def deleteToken = 'Bearer ' + response.access_token 
#* print 'deleteToken is ' , deleteToken 

##-----------------** Delete API **-----------------------##

Given url PublisherURL
And path APIIDPub
* def auth = call read('classpath:examples/Tokens/CreateToken.feature') {'createAccessToken': 'createAccessToken'  }
* print ' auth create for deleting Admins API' , auth.createAccessToken
* header Authorization = auth.createAccessToken
When method delete
Then status 200
Examples:
|title|version|
|'REGTEST_JnewAPINoSandboxfalse'|'v1'|
|'REGTEST_JnewAPISandboxfalse'|'v1'|
|'REGTEST_JnewAPINoSandboxtrue'|'v1'|
|'REGTEST_JnewAPISandboxtrue'|'v1'|
|'REGTEST_JnewAPINoSandboxfalse'|'v2'|
|'REGTEST_JnewAPISandboxfalse'|'v2'|
|'REGTEST_JnewAPINoSandboxtrue'|'v2'|
|'REGTEST_JnewAPISandboxtrue'|'v2'|