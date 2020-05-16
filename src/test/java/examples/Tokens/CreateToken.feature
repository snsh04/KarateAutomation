Feature: Generate Create Token


#-------------------------------------------------------------------------------
#****************------ Auth Server - Create Token ----------*****************
@Token
Scenario: Create Token 
Given   url authURL 
And   header Authorization = Authorization 
And   form field grant_type = 'client_credentials' 
And   form field scope = 'apim:api_create' 
When   method post 
Then   status 200 
* def createAccessToken = 'Bearer ' + response.access_token 
* print 'createAccessToken is ' , createAccessToken 

#---------------------------------------------------------------------------------
