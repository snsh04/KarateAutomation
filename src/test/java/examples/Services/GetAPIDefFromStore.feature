Feature: Get the definition from Store

Background:
# Not required
@parallel=false
Scenario: Get Defintion
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr

* configure retry = { count: 5, interval: 5000 }

Given url storeURL
And  path APIIDStr  
* def auth = callonce read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken' }
* print ' auth token ' , auth.viewAccessToken
* header Authorization = auth.viewAccessToken
* retry until responseStatus == 200
When method get 
* print ' Definition from Store' , response
* def responseCode = responseStatus
