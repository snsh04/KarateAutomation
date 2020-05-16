Feature: This feature validate groups to be part of subscription approval request.

Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }

#----------------------**** MUTUAL SSL ****----------------------------------#
 @parallel=false  @GroupsInApproval 
Scenario Outline: Validate Groups in the subscription approval request
# Register and API
Given url Admin
* json myReq = read('Swagger-Subscription.json')
* def name = '1-' + now()
* def title = <title> + name
* set myReq.swagger.info.title = title
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = <basepath>
* set myReq.swagger.info.version = <version>
And request myReq
When method post
Then status 200 
* match response.success == true

# Declaration
* def tier = <tier>
* def groups = <groups>
* def domain = <domain>
* def basepath = <basepath>
* def status = <status>

# Get API ID from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

## Subscribe
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
* def ApplicationName = 'GroupsInApproval-' + now()
And request {"groupId": "#(groups)" ,"throttlingTier": "Unlimited","description": "sample app description","name": '#(ApplicationName)' ,"callbackUrl": "https:/apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com/callback"}
When method post
Then status 201
* def applicationID = response.applicationId
* print 'Groups Added :', response.groupId


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
* match response.status == status

* def wso2username = wso2_username
* def wso2password = wso2_password

* def utils = Java.type('examples.SubscriptionApprovalWithGroups.GroupsInSubscription')
* def result = utils.main(ApplicationName,groups,wso2username,wso2password) 
* print ' result ', result
Then assert result    

#* call read('BPSWorkflow.feature') {'title': '#(title)' , 'tier': '#(tier)' , 'groups': '#(groups)' }

# Delete Application
* call read('classpath:examples/Polling/Polling.feature') 
Given url applicationURL + '/applications/'
And path applicationID
* header Authorization = subscribeToken
* retry until responseStatus == 200 
When method delete
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:	
|groups                               |version|title                                |domain         |basepath    |Username                     |Password|tier                |status     |flag   |
|'test'                               |'v92'  |'Regtest_SusbcriptionWithGroup1'     |'notification' |'countrySG0'|'regtest'                    |'admin' |'Gold'              |'ON_HOLD'  |'true' |
#|'test,testing'                       |'v93'  |'Regtest_SusbcriptionWithGroup2'     |'loyalty'      |'countrySG1'|'regtest'                    |'admin' |'Gold'              |'ON_HOLD'  |'true' |
#|'AlphaTeam,BetaTeam,DevTeam'         |'v94'  |'Regtest_SusbcriptionWithGroup3'     |'aircraft'     |'countrySG2'|'regtest'                    |'admin' |'Gold'              |'ON_HOLD'  |'true' |
#|' '                                  |'v95'  |'Regtest_SusbcriptionWithNoGroup'    |'car'          |'countrySG3'|'regtest'                    |'admin' |'Gold'              |'ON_HOLD'  |'true' |
|'abfcds ebhbfcjwbfie h3298u4e09ie31-'|'v96'  |'Regtest_SusbcriptionWithWierdGroup' |'customer'     |'countrySG4'|'regtest'                    |'admin' |'Gold'              |'ON_HOLD'  |'true' |

#------------------------------------------------ **** END **** --------------------------------------------------#