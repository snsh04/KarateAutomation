Feature: Register and subscribe to API

Background: 
* def now = function(){ return java.lang.System.currentTimeMillis() }


Scenario: Register and subscribe
# Generate keys
* def applicationKeyDetailsProd = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforProd = 'Bearer '+ applicationKeyDetailsProd.response.token.accessToken

# Subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }