Feature: BPS workflow

Background: 
Given url 'https://admin:bananaM1lkshake@bps-dev-dev-a878-27-ams10-nonp.cloud.random.com/services/HumanTaskClientAPIAdmin/'

Scenario: Call BPS
 #List all the Tasks

And header Authorization = 'Test' 
And request read('BPSRequest.xml')
And soap action ''
Then status 200
* match /Envelope/Body/simpleQueryResponse/taskSimpleQueryResultSet/row[1]/presentationSubject contains title
* match /Envelope/Body/simpleQueryResponse/taskSimpleQueryResultSet/row[1]/presentationSubject contains tier
* match /Envelope/Body/simpleQueryResponse/taskSimpleQueryResultSet/row[1]/presentationSubject contains groups
* def id = /Envelope/Body/simpleQueryResponse/taskSimpleQueryResultSet/row[1]/id
* print 'response: ', id


* call read('classpath:examples/Polling/Polling.feature') 






 

