Feature: Register and subscribe to API

Background: 
* def now = function(){ return java.lang.System.currentTimeMillis() }


Scenario: Register and subscribe
# Subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }