Feature: Generate Publish Token


#---------------------------------------------------------------------------------
#****************------ Auth Server - Publish Token ---------*****************

@Token
Scenario: Publish Token 
Given url authURL 
And header Authorization = Authorization 
And form field grant_type = 'client_credentials' 
And form field scope = 'apim:api_publish' 
When method post 
Then status 200 
* def publishAccessToken = 'Bearer ' + response.access_token 
* print 'publishAccessToken is ' , publishAccessToken

#---------------------------------------------------------------------------------
