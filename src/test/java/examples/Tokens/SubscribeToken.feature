Feature: Generate Subscribe Token


#---------------------------------------------------------------------------------
#****************------ Auth Server - Subscribe Token ---------*****************

@Token
Scenario: Subscribe Token 
Given url authURL
And header Authorization = Authorization
And form field grant_type = 'client_credentials'
And form field scope = 'apim:subscribe'
When method post
Then status 200
* def subscribeToken = 'Bearer ' + response.access_token
* print 'SubscriberToken is ', subscribeToken

#---------------------------------------------------------------------------------