Feature: Create Token for view, create , delete , subscribe

Background: 
# not required
@delete
Scenario Outline: Create Token
#--------------------------------------------------------------------
##------------**Delete Application**----------------------------##
* call read('AppdeleteApplication.feature')
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
|'REGTEST_newAPINoSandboxfalse'|'v1'|
|'REGTEST_newAPISandboxfalse'|'v1'|
|'REGTEST_newAPINoSandboxtrue'|'v1'|
|'REGTEST_newAPISandboxtrue'|'v1'|
|'REGTEST_newAPINoSandboxfalse'|'v2'|
|'REGTEST_newAPISandboxfalse'|'v2'|
|'REGTEST_newAPINoSandboxtrue'|'v2'|
|'REGTEST_newAPISandboxtrue'|'v2'|