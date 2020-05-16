Feature: Test new Self Service API for Plan key generation

Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }
* configure retry = { count: 7, interval: 5000 }

#-----------------------------------------------------------------------------------
@SelfService
Scenario: Invoke API
 # Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': 'API_Key_Self-Service'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

# Create subscribe token
Given url authURL
And header Authorization = Authorization
And form field grant_type = 'password'
And form field username = 'regtest'
And form field password = 'admin'
And form field scope = 'apim:subscribe'
When method post
Then status 200
* def subscribeToken = 'Bearer ' + response.access_token
* print 'SubscriberToken is ', subscribeToken

# Create an Application
Given url applicationURL
And path 'applications'
And header Authorization = subscribeToken
* def name = 'SelfService-' + now()
And request {"throttlingTier": "Unlimited","description": "sample app description","name": '#(name)' ,"callbackUrl": "https:/apistore-soam-1327-dev-a878-14-ams10-nonp.cloud.random.com/callback"}
When method post
Then status 201
* def applicationID = response.applicationId
* print 'applicationId is ', applicationID


# Subscribe to an API
Given url applicationURL
And path 'subscriptions'
And header Authorization = subscribeToken
And request {'tier': 'Test_Auto-Approved' ,'apiIdentifier': '#(APIIDStr)','applicationId': '#(applicationID)'}
When method post
Then status 201
* def subscriptionId = response.subscriptionId
* print 'subscribed with status ', status , ' and subscriptionID ' , subscriptionId  

# Get details of subscription
Given url applicationURL 
And path '/subscriptions/' + subscriptionId
And header Authorization = subscribeToken
When method get
Then status 200
* print 'responseStatus of subscription', response.status , ' for tier' , response.tier

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
* def accessTokenforProd = 'Bearer '+ response.token.accessToken
* print 'accessTokenforInvokation is ', accessTokenforProd

## Test 1 - First plan key
Given url 'https://gateway-jg-int-soam-1327-dev-a878-30-ams10-nonp.cloud.random.com/test/apikeys/v1/'
And header Authorization = accessTokenforProd
* json myrequest = '{"basepath": "path","plankey": "AMS10-A878S03DEV","branch": "dev"}'
* request myrequest 
* retry until responseStatus == 201
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* match response.message == 'Successfully created API Key for basepath: path, plankey: AMS10-A878S03DEV, branch: dev'

## Test 2 - Duplicate 
Given url 'https://gateway-jg-int-soam-1327-dev-a878-30-ams10-nonp.cloud.random.com/test/apikeys/v1/'
And header Authorization = accessTokenforProd
* json myrequest = '{"basepath": "path","plankey": "AMS10-A878S03DEV","branch": "dev"}'
* request myrequest 
* retry until responseStatus == 200
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* string responseValue = response
* match responseValue contains 'API Key already exists for basepath: path, plankey: AMS10-A878S03DEV, branch: dev'

## Test 3 - number in basepath 
Given url 'https://gateway-jg-int-soam-1327-dev-a878-30-ams10-nonp.cloud.random.com/test/apikeys/v1/'
And header Authorization = accessTokenforProd
* json myrequest = '{"basepath": "path1","plankey": "AMS10-A878S03TEST","branch": "TEST"}'
* request myrequest 
* retry until responseStatus == 201
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* match response.message == 'Successfully created API Key for basepath: path1, plankey: AMS10-A878S03TEST, branch: TEST'

## Test 4 - Dashes in basepath
Given url 'https://gateway-jg-int-soam-1327-dev-a878-30-ams10-nonp.cloud.random.com/test/apikeys/v1/'
And header Authorization = accessTokenforProd
* json myrequest = '{"basepath": "path-test","plankey": "AMS10-A878S03PROD","branch": "PROD"}'
* request myrequest 
* retry until responseStatus == 201
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* match response.message == 'Successfully created API Key for basepath: path-test, plankey: AMS10-A878S03PROD, branch: PROD'

## Test 5 - hyphen in basepath
Given url 'https://gateway-jg-int-soam-1327-dev-a878-30-ams10-nonp.cloud.random.com/test/apikeys/v1/'
And header Authorization = accessTokenforProd
* json myrequest = '{"basepath": "path_test","plankey": "AMS10-A878S03UAT","branch": "UAT"}'
* request myrequest 
* retry until responseStatus == 201
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* match response.message == 'Successfully created API Key for basepath: path_test, plankey: AMS10-A878S03UAT, branch: UAT'

## Test 7 - reserved basepath
Given url 'https://gateway-jg-int-soam-1327-dev-a878-30-ams10-nonp.cloud.random.com/test/apikeys/v1/'
And header Authorization = accessTokenforProd
* json myrequest = '{"basepath": "path","plankey": "AMS10-A878S03DEVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV","branch": "DEV"}'
* request myrequest 
* retry until responseStatus == 400
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* string reservedresponse = response
* match reservedresponse contains 'RESERVED_BASEPATH'

## Test 8 - Capital Basepath
Given url 'https://gateway-jg-int-soam-1327-dev-a878-30-ams10-nonp.cloud.random.com/test/apikeys/v1/'
And header Authorization = accessTokenforProd
* json myrequest = '{"basepath": "patH","plankey": "AMS10-A878S03DEV","branch": "dev"}'
* request myrequest 
* retry until responseStatus == 400
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* string reservedresponse = response
* match reservedresponse contains 'Basepath must be all lowercase'

## Test 8 - characters
Given url 'https://gateway-jg-int-soam-1327-dev-a878-30-ams10-nonp.cloud.random.com/test/apikeys/v1/'
And header Authorization = accessTokenforProd
* json myrequest = '{"basepath": "patH%","plankey": "AMS10-A878S03DEV","branch": "dev"}'
* request myrequest 
* retry until responseStatus == 400
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* string reservedresponse = response
* match reservedresponse contains 'Basepath must be all lowercase'

## Test 8 - characters for plankey
Given url 'https://gateway-jg-int-soam-1327-dev-a878-30-ams10-nonp.cloud.random.com/test/apikeys/v1/'
And header Authorization = accessTokenforProd
* json myrequest = '{"basepath": "path","plankey": "AMS10-A878S03DEv","branch": "dev"}'
* request myrequest 
* retry until responseStatus == 400
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* string reservedresponse = response
* match reservedresponse contains 'INVALID_INPUT'

## Test 8 - characters plankeyy
Given url 'https://gateway-jg-int-soam-1327-dev-a878-30-ams10-nonp.cloud.random.com/test/apikeys/v1/'
And header Authorization = accessTokenforProd
* json myrequest = '{"basepath": "path","plankey": "AMS10A878S03DEV","branch": "dev"}'
* request myrequest 
* retry until responseStatus == 400
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* string reservedresponse = response
* match reservedresponse contains 'INVALID_INPUT'

## Test 8 - basepath blank
Given url 'https://gateway-jg-int-soam-1327-dev-a878-30-ams10-nonp.cloud.random.com/test/apikeys/v1/'
And header Authorization = accessTokenforProd
* json myrequest = '{"basepath": "","plankey": "AMS10-A878S03DEv","branch": "dev"}'
* request myrequest 
* retry until responseStatus == 400
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* string reservedresponse = response
* match reservedresponse contains 'should NOT be shorter than 1 characters'

## Test 8 - basepath space 
Given url 'https://gateway-jg-int-soam-1327-dev-a878-30-ams10-nonp.cloud.random.com/test/apikeys/v1/'
And header Authorization = accessTokenforProd
* json myrequest = '{"basepath": "","plankey": "AMS10-A878S03DEV","branch": "dev"}'
* request myrequest 
* retry until responseStatus == 400
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* string reservedresponse = response
* match reservedresponse contains 'should NOT be shorter than 1 characters'

## Test 8 - no plan key 
Given url 'https://gateway-jg-int-soam-1327-dev-a878-30-ams10-nonp.cloud.random.com/test/apikeys/v1/'
And header Authorization = accessTokenforProd
* json myrequest = '{"basepath": "path","plankey": "","branch": "dev"}'
* request myrequest 
* retry until responseStatus == 400
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* string reservedresponse = response
* match reservedresponse contains 'INVALID_INPUT'


## Test 8 - space blank key 
Given url 'https://gateway-jg-int-soam-1327-dev-a878-30-ams10-nonp.cloud.random.com/test/apikeys/v1/'
And header Authorization = accessTokenforProd
* json myrequest = '{"basepath": "path","plankey": " ","branch": "dev"}'
* request myrequest 
* retry until responseStatus == 400
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* string reservedresponse = response
* match reservedresponse contains 'INVALID_INPUT'

## Test 8 - space blank key 
Given url 'https://gateway-jg-int-soam-1327-dev-a878-30-ams10-nonp.cloud.random.com/test/apikeys/v1/'
And header Authorization = accessTokenforProd
* json myrequest = '{"basepath": "path","plankey": " ","branch": "dev"}'
* request myrequest 
* retry until responseStatus == 400
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* string reservedresponse = response
* match reservedresponse contains 'INVALID_INPUT'

## Test 8 - blank branch
Given url 'https://gateway-jg-int-soam-1327-dev-a878-30-ams10-nonp.cloud.random.com/test/apikeys/v1/'
And header Authorization = accessTokenforProd
* json myrequest = '{"basepath": "path","plankey": "AMS10-A878S03DEV","branch": ""}'
* request myrequest 
* retry until responseStatus == 400
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* string reservedresponse = response
* match reservedresponse contains 'should NOT be shorter than 1 characters'

## Test 8 - blank branch
Given url 'https://gateway-jg-int-soam-1327-dev-a878-30-ams10-nonp.cloud.random.com/test/apikeys/v1/'
And header Authorization = accessTokenforProd
* json myrequest = '{"basepath": "path","plankey": "AMS10-A878S03DEV","branch": " "}'
* request myrequest 
* retry until responseStatus == 201
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* match response.message == 'Successfully created API Key for basepath: path, plankey: AMS10-A878S03DEV, branch:  '


## Test 8 - All wrong
Given url 'https://gateway-jg-int-soam-1327-dev-a878-30-ams10-nonp.cloud.random.com/test/apikeys/v1/'
And header Authorization = accessTokenforProd
* json myrequest = '{"basepath": "patH","plankey": "AMS10-","branch": ""}'
* request myrequest 
* retry until responseStatus == 400
When method post
* print ' response code from random Internal Gateway: ' , responseStatus
* string responsevalue = response
* match responsevalue.message contains 'Basepath must be all lowercase'
* match responsevalue.message contains 'should NOT be shorter than 1 characters'
* match responsevalue.message contains 'should match pattern'


# Delete Application
* call read('classpath:examples/Polling/Polling.feature') 
Given url applicationURL + '/applications/'
And path applicationID
* header Authorization = subscribeToken
* retry until responseStatus == 200 
When method delete	



