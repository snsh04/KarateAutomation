Feature: BPS workflow

Background: 
Given url BPS

Scenario: Call BPS
 #List all the Tasks
And header Authorization = BPS_PASSWORD 
And request read('BPSRequest.xml')
And soap action ''
Then status 200
* match /Envelope/Body/simpleQueryResponse/taskSimpleQueryResultSet/row[1]/presentationSubject contains 'Smoke_Test'
* match /Envelope/Body/simpleQueryResponse/taskSimpleQueryResultSet/row[1]/presentationSubject contains 'Unlimited'
* def id = /Envelope/Body/simpleQueryResponse/taskSimpleQueryResultSet/row[1]/id
* print 'response: ', id

#Start Task
And request
"""
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://docs.oasis-open.org/ns/bpel4people/ws-humantask/api/200803" xmlns:ns1="http://docs.oasis-open.org/ns/bpel4people/ws-humantask/types/200803">
   <soapenv:Header />
   <soapenv:Body>
      <ns:start>
         <ns:identifier>#(id)</ns:identifier>
      </ns:start>
   </soapenv:Body>
</soapenv:Envelope>
"""
When soap action ''
Then status 200

#Get Inputs 
And request
"""
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://docs.oasis-open.org/ns/bpel4people/ws-humantask/api/200803" xmlns:ns1="http://docs.oasis-open.org/ns/bpel4people/ws-humantask/types/200803">
   <soapenv:Header />
   <soapenv:Body>
      <ns:getInput>
         <ns:identifier>#(id)</ns:identifier>
      </ns:getInput>
   </soapenv:Body>
</soapenv:Envelope>
"""
When soap action ''
Then status 200

* string response = response
* def start = response.indexOf('workflowExternalRef&gt;')
* def ref = response.substring(start + 23)
* def end = ref.indexOf('&lt;')
* def ref = ref.substring(0, end)
* print 'workflow id ', ref

* def xml = <sch:SubscriptionApprovalResponse xmlns:sch="http://workflow.subscription.apimgt.carbon.wso2.org"><sch:status>APPROVED</sch:status><sch:workflowExternalRef>#(ref)</sch:workflowExternalRef><sch:description></sch:description></sch:SubscriptionApprovalResponse>
* def xmlRequest = <?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://docs.oasis-open.org/ns/bpel4people/ws-humantask/api/200803"><soapenv:Header /><soapenv:Body><ns:complete><ns:identifier>#(id)</ns:identifier><ns:taskData><![CDATA[#(xml)]]></ns:taskData></ns:complete></soapenv:Body></soapenv:Envelope>

#Complete Task
And request xmlRequest
When soap action ''
Then status 200

* call read('Sleep.feature')


 

