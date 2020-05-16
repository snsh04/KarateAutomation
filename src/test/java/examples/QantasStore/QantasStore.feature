Feature: This feature validates the store actions like subscription , invokations and approvals using random API
 
Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }

#* configure afterFeature = function(){ karate.call('Store-Cleanup.feature'); }
 
@Store @parallel=false @All @randomStore
Scenario Outline: Subscribe to an API
# Register and API
Given url Admin
* json myReq = read('Swagger-Subscriber.json')
* def name = '1-' + now()
* def title = <title> + name
* def basepath = <basepath> + name 
* set myReq.swagger.info.title = title
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = basepath
* set myReq.swagger.info.version = <version>
And request myReq
When method post
Then status 200 
* match response.success == true
* def domain = <domain>
* def requestMethod = <method>
* def path = <path>
* print 'title i am looking for is ' , title
 
# Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

# Create subscribe token
Given url authURL
And header Authorization = Authorization
And form field grant_type = 'password'
And form field username = <Username>
And form field password = <Password>
And form field scope = 'apim:subscribe'
When method post
Then status 200
* def subscribeToken = 'Bearer ' + response.access_token
* print 'SubscriberToken is ', subscribeToken

# Create an Application
Given url applicationURL
And path 'applications'
And header Authorization = subscribeToken
* def name = 'Test-' + now()
And request {"throttlingTier": "Unlimited","description": "sample app description","name": '#(name)' ,"callbackUrl": "https:/apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com/callback"}
When method post
Then status 201
* def applicationID = response.applicationId
* print 'applicationId is ', applicationID

# Subscribe to an API
Given url applicationURL
And path 'subscriptions'
And header Authorization = subscribeToken
And request {'tier': <tier> ,'apiIdentifier': '#(APIIDStr)','applicationId': '#(applicationID)'}
When method post
Then status 201
* def subscriptionId = response.subscriptionId
* print 'subscriptionID is ', subscriptionId 
* def status = response.status
* match response.status == <status>
* print 'subscribed with status ', status , ' and subscriptionID ' , subscriptionId  
* eval if (response.status == 'ON_HOLD') karate.call('BPSWorkflow.feature')

# Get details of subscription
Given url applicationURL 
And path '/subscriptions/' + subscriptionId
And header Authorization = subscribeToken
When method get
Then status 200
* print 'responseStatus of subscription', response.status , ' for tier' , response.tier

# Generate keys for the application
Given url applicationURL + '/applications/generate-keys?'
And param applicationId = applicationID
And header Authorization = subscribeToken
And request {"validityTime": "3600","keyType": "PRODUCTION","accessAllowDomains": ["ALL"]}
When method post
Then status 200
* def accessTokenforInvokation = 'Bearer '+ response.token.accessToken
* print 'accessTokenforInvokation is ', accessTokenforInvokation 

#Invoke API through External Gateway
* def responseFromAuthenticatedExternalWSO2Gateway = call read('classpath:examples/Services/InvokeAuthenticatedProdrandomExternalWSO2Gateway.feature') {'domain': '#(domain)' , 'basepath': '#(basepath)' , 'path': '#(path)' , 'externalGatewayResponse': '200' , 'method': '#(requestMethod)' , 'accessTokenforProd': '#(accessTokenforInvokation)' }
* match responseFromAuthenticatedExternalWSO2Gateway.responseStatus == 200

# Delete Application and API
* call read('classpath:examples/Polling/Polling.feature') 

# Delete Application
* call read('classpath:examples/Polling/Polling.feature') 
Given url applicationURL + '/applications/'
And path applicationID
* header Authorization = subscribeToken
* retry until responseStatus == 200 
When method delete
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDStr)'  }
Examples:	
|version|title                  |domain         |basepath    |Username                     |Password|tier                |status     |method|path|
|'v35'  |'REGTEST_Subs1'        |'test'         |'countrySS1'|'regtest_tech@random.com' |'admin' |'Gold_Auto-Approved'|'UNBLOCKED'|'get'|'quote'|
|'v36'  |'REGTEST_Subs2'        |'event'        |'countrySS2'|'regtest_buss@random.com' |'admin' |'Gold'              |'UNBLOCKED'|'get'|'quote'|
|'v37'  |'REGTEST_Subs3'        |'partner'      |'countrySS3'|'regtest_tech@random.com' |'admin' |'Gold'              |'UNBLOCKED'|'get'|'quote'|
|'v38'  |'REGTEST_Subs74'        |'car'          |'countrySS44'|'regtest_buss@random.com' |'admin' |'Gold_Auto-Approved'|'UNBLOCKED'|'get'|'quote'|

#------------------------- *** END *** ---------------------------------#