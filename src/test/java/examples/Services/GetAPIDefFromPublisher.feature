Feature: Get the definition from Publisher

Background:
# Not required
@parallel=false
Scenario: Get Defintion

* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

* configure retry = { count: 5, interval: 5000 }

Given  url PublisherURL
And  path APIIDPub  
* def auth = callonce read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken' }
* print ' auth token ' , auth.viewAccessToken
* header Authorization = auth.viewAccessToken
* retry until responseStatus == 200
When method get 
* print ' Definition from Publisher' , response
* def responseCode = responseStatus

