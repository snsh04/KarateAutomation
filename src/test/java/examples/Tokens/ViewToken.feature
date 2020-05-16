Feature: Generate View Token



#---------------------------------------------------------------------------------
#****************------ Auth Server - View Token ---------*****************

@Token
Scenario: View Token 
Given   url authURL 
And   header Authorization = Authorization 
And   form field grant_type = 'client_credentials' 
And   form field scope = 'apim:api_view' 
When   method post 
Then   status 200 
* def viewAccessToken = 'Bearer ' + response.access_token 
* print 'viewAccessToken is ' , viewAccessToken 

#---------------------------------------------------------------------------------