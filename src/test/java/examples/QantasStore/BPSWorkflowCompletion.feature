Feature: BPS workflow

Background: 
Given url 'https://admin:bananaM1lkshake@bps-soam-1327-dev-a878-27-ams10-nonp.cloud.random.com/services/HumanTaskClientAPIAdmin/'

Scenario: Call BPS
 #List all the Tasks

And header Authorization = 'Test' 
And request read('BPSRequest.xml')
And soap action ''
Then status 200
* match /Envelope/Body/simpleQueryResponse/taskSimpleQueryResultSet/pages == 0