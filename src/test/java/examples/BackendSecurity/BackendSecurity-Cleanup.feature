Feature: Create Token for view, create , delete , subscribe

Background: 
# not required
Scenario: Create Token
#--------------------------------------------------------------------
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

Given  url PublisherURL + '?' 
And  param query = 'name:Regtest_Secure'
* def auth = call read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken' }
* print ' auth token ' , auth.viewAccessToken
And  header Authorization = auth.viewAccessToken
When  method get 
Then  status 200 
* def APIIDPub = response.list[0].id 
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
* print ' auth create for deleting API for backend security' , auth.createAccessToken
And header Authorization = auth.createAccessToken
When method delete
Then status 200