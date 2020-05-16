Feature: This feature tests the publisher actions.

Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }

# Have an API in publisher , delete created one 
@Publisher @parallel=false @All
Scenario: Create API from Publisher
# Get Create Access Token
Given   url authURL 
And   header Authorization = Authorization 
And   form field grant_type = 'client_credentials' 
And   form field scope = 'apim:api_create' 
When   method post 
Then   status 200 
* def createAccessToken = 'Bearer ' + response.access_token 
* print 'createAccessToken is ' , createAccessToken 
	
# Create API in Publisher
Given url PublisherURL 
And header Authorization = createAccessToken 
And request read('Swagger-newAPICreation.json')
When method post
Then status 201
	
#----------------------------------------------------------------------------------------
@Publisher @parallel=false @All
Scenario: Search and Retrieve details of an API 
# Create Access Token
Given   url authURL 
And   header Authorization = Authorization 
And   form field grant_type = 'client_credentials' 
And   form field scope = 'apim:api_create' 
When   method post 
Then   status 200 
* def createAccessToken = 'Bearer ' + response.access_token 
* print 'createAccessToken is ' , createAccessToken
	
# Get access Token
Given   url authURL 
And   header Authorization = Authorization 
And   form field grant_type = 'client_credentials' 
And   form field scope = 'apim:api_view' 
When   method post 
Then   status 200 
* def viewAccessToken = 'Bearer ' + response.access_token 
* print 'viewAccessToken is ' , viewAccessToken 
	
	
# Retrieve APIID
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'REGTEST_Publisher'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher for random Gateway API: ' , APPIDFromPublisher.APIIDPub
	
# Retrieve swagger
Given url PublisherURL + '/' + APIIDPub + '/swagger'
And header Authorization = viewAccessToken
When method get 
Then status 200
* print 'Swagger Definition is ', response
	
# Change status of API
Given url authURL 
And header Authorization = Authorization 
And form field grant_type = 'client_credentials' 
And form field scope = 'apim:api_publish' 
When method post 
Then status 200 
* def publishAccessToken = 'Bearer ' + response.access_token 
* print 'publishAccessToken is ' , publishAccessToken 
	
# Change status to Publish
Given url PublisherURL + 'change-lifecycle?apiId=' + APIIDPub
And param action = 'Publish'
And header Authorization = viewAccessToken 
And request ''
When method post
Then status 404
	
# Change status to Publish
Given url PublisherURL + '/change-lifecycle'
And param apiId = APIIDPub
And param action = 'Publish'
And request read('Swagger-newAPICreation.json')
And header Authorization = publishAccessToken 
When method post
Then status 200
	
# Change status to Deprecate
Given url PublisherURL + '/change-lifecycle' 
And param apiId = APIIDPub
And param action = 'Deprecate'
And request read('Swagger-newAPICreation.json')
And header Authorization = publishAccessToken 
When method post
Then status 200
	
# Change status to Retire
Given url PublisherURL + '/change-lifecycle'
And param apiId = APIIDPub
And param action = 'Retire'
And request read('Swagger-newAPICreation.json')
And header Authorization = publishAccessToken 
When method post
Then status 200
	
# Create new version of the API
Given url PublisherURL + '/copy-api'
And param apiId = APIIDPub
And param newVersion = '2.0.0'
And header Authorization = createAccessToken 
And request read('Swagger-newAPICreation.json')
When method post
Then status 201

# Delete API with valid token
Given url PublisherURL + '/' + APIIDPub
And header Authorization = createAccessToken 
When method delete
Then status 200	

# Retrieve APIID fr version 2.0.0
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'REGTEST_Publisher'  }
* def APIIDPubVersion2 = APPIDFromPublisher.APIIDPub
* print 'APPIDFromPublisher for random Gateway API: ' , APPIDFromPublisher.APIIDPub
	
# Delete API with invalid token
Given url PublisherURL + '/' + APIIDPub
And header Authorization = viewAccessToken 
When method delete
Then status 401
	
# Delete the Application and API
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPubVersion2)'  }
#---------------------------------------------------------------------------
@Publisher @parallel=false @All
Scenario: Search and Retrieve details and then delete 
# Get access Token
Given   url authURL 
And   header Authorization = Authorization 
And   form field grant_type = 'client_credentials' 
And   form field scope = 'apim:api_create' 
When   method post 
Then   status 200 
* def createAccessToken = 'Bearer ' + response.access_token 
* print 'createAccessToken is ' , createAccessToken 
	
# Retrieve APIID
Given   url PublisherURL + '?'
And   param query = 'name:REGTEST_Publisher' 
And   header Authorization = createAccessToken 
When   method get 
Then   status 401 
		
Given   url authURL 
And   header Authorization = Authorization 
And   form field grant_type = 'client_credentials' 
And   form field scope = 'apim:api_view' 
When   method post 
Then   status 200 
* def viewAccessToken = 'Bearer ' + response.access_token 
* print 'viewAccessToken is ' , viewAccessToken 
	
# Create API in Publisher with wrong token
Given url PublisherURL 
And header Authorization = viewAccessToken 
And request read('Swagger-newAPICreation.json')
When method post
Then status 401
#-----------------------------------------------------------------------------
  @parallel=false @Mediation
Scenario: Testing mediation Policy
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = 'REGTEST_REGTEST'
And header apigateway-basepath = 'mediation'
* json myReq = read('Swagger-mediation.json')
* set myReq.apiConf.domain = 'car'
And request myReq
When method post
Then status 200
* call read('classpath:examples/Polling/Polling.feature') 
	
# Get APIID
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'REGTEST_Mediation'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
	
# Get Definitions
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': 'REGTEST_Mediation'  }
* match DefFromPub.response.sequences == '#[0]'

* def wso2username = wso2_username
* def wso2password = wso2_password

* def utils = Java.type('examples.Publisher.MediationPersistence')
* def result = utils.main(wso2username,wso2password)
    
# Updating the API
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = 'REGTEST_REGTEST'
And header apigateway-basepath = 'mediation'
* json myReq = read('Swagger-mediation.json')
* set myReq.swagger.info.description = 'Updated Mediation API'
* set myReq.apiConf.domain = 'car'
And request myReq
When method post
 Then status 200
* call read('classpath:examples/Polling/Polling.feature') 
    
# Get Definitions
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': 'REGTEST_Mediation'  }
* match DefFromPub.response.sequences[0].name == 'json_to_xml_in_message'
* match DefFromPub.response.sequences[1].name == 'enable_akamai_cache_15min'
* match DefFromPub.response.sequences[2].name == 'json_fault'
	

#---------------------------------------------------------------------------------------------------------#
 @parallel=false 
Scenario: Add combination of mediation policy
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = 'REGTEST_REGTEST'
And header apigateway-basepath = 'mediation'
* json myReq = read('Swagger-mediation.json')
* set myReq.swagger.info.title = 'Regtest_TwoMediation'
* set myReq.apiConf.domain = 'notification'
And request myReq
When method post
Then status 200
* call read('classpath:examples/Polling/Polling.feature') 
	
# Get APIID
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'REGTEST_TwoMediation'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
	
# Get Definitions
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': 'REGTEST_TwoMediation'  }
* match DefFromPub.response.sequences == '#[0]'

* def wso2username = wso2_username
* def wso2password = wso2_password


* def utils = Java.type('examples.Publisher.MediationPersistenceWith2Policy')
* def result = utils.main(wso2username,wso2password)
    
# Updating the API
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = 'REGTEST_REGTEST'
And header apigateway-basepath = 'mediation'
* json myReq = read('Swagger-mediation.json')
* set myReq.swagger.info.description = 'Updated Mediation API'
* set myReq.swagger.info.title = 'Regtest_TwoMediation'
* set myReq.apiConf.domain = 'notification'
And request myReq
When method post
Then status 200
* call read('classpath:examples/Polling/Polling.feature') 

# Get Definitions
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': 'REGTEST_TwoMediation'  }
* match DefFromPub.response.sequences[0].name == 'json_to_xml_in_message'
* match DefFromPub.response.sequences[1].name == 'enable_akamai_cache_15min'
	
# Delete the API
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
#--------------------------------------------------------------------------------------------#
  @parallel=false 
Scenario: With 1 Policy
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = 'REGTEST_REGTEST'
And header apigateway-basepath = 'mediation'
* json myReq = read('Swagger-mediation.json')
* set myReq.swagger.info.title = 'Regtest_1Mediation'
* set myReq.apiConf.domain = 'customer'
And request myReq
When method post
Then status 200
* call read('classpath:examples/Polling/Polling.feature') 
	
# Get APIID
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'REGTEST_1Mediation'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
	
# Get Definitions
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': 'REGTEST_1Mediation'  }
* match DefFromPub.response.sequences == '#[0]'

* def wso2username = wso2_username
* def wso2password = wso2_password

* def utils = Java.type('examples.Publisher.MediationPersistenceWith1Policy')
* def result = utils.main(wso2username,wso2password) 
    
# Updating the API
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = 'REGTEST_REGTEST'
And header apigateway-basepath = 'mediation'
* json myReq = read('Swagger-mediation.json')
* set myReq.swagger.info.description = 'Updated Mediation API'
* set myReq.swagger.info.title = 'Regtest_1Mediation'
* set myReq.apiConf.domain = 'customer'
And request myReq
When method post
Then status 200
* call read('classpath:examples/Polling/Polling.feature') 
    
# Get Definitions
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': 'REGTEST_1Mediation'  }
* match DefFromPub.response.sequences[0].name == 'json_to_xml_in_message'
	
# Delete the API
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

#---------------------------------#
 @parallel=false 
Scenario: No policy
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = 'REGTEST_REGTEST'
And header apigateway-basepath = 'mediation'
* json myReq = read('Swagger-mediation.json')
* set myReq.swagger.info.title = 'Regtest_NoMediation'
* set myReq.apiConf.domain = 'business'
And request myReq
When method post
Then status 200
* call read('classpath:examples/Polling/Polling.feature') 
	
# Get APIID	
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'REGTEST_NoMediation'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
	
# Get Definitions
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': 'REGTEST_NoMediation'  }
* match DefFromPub.response.sequences == '#[0]'

* def wso2username = wso2_username
* def wso2password = wso2_password

* def utils = Java.type('examples.Publisher.MediationPersistenceWithNoPolicy')
* def result = utils.main(wso2username, wso2password)   
    
# Updating the API
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = 'REGTEST_REGTEST'
And header apigateway-basepath = 'mediation'
* json myReq = read('Swagger-mediation.json')
* set myReq.swagger.info.description = 'Updated Mediation API'
* set myReq.apiConf.domain = 'business'
* set myReq.swagger.info.title = 'Regtest_NoMediation'
And request myReq
When method post
Then status 200
* call read('classpath:examples/Polling/Polling.feature') 

# Get Definitions
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': 'REGTEST_NoMediation'  }
* match DefFromPub.response.sequences == '#[0]'
	
# Delete the APi
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
  #-----------------------------------------------------#
 @parallel=false 
Scenario: Deletion persistence

	
#Get APIID
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'REGTEST_Mediation'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

# Get Definitions
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': 'REGTEST_Mediation'  }
* match DefFromPub.response.sequences[0].name == 'json_to_xml_in_message'
* match DefFromPub.response.sequences[1].name == 'enable_akamai_cache_15min'
* match DefFromPub.response.sequences[2].name == 'json_fault'
			
* def wso2username = wso2_username
* def wso2password = wso2_password

* def utils = Java.type('examples.Publisher.DeletePersistence')
* def result = utils.main(wso2username,wso2password)

# Updating the API
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = 'REGTEST_REGTEST'
And header apigateway-basepath = 'mediation'
* json myReq = read('Swagger-mediation.json')
* set myReq.apiConf.domain = 'car'
* set myReq.swagger.info.description = 'Updated Mediation API for Deletion'
* set myReq.swagger.info.title = 'Regtest_Mediation'
And request myReq
When method post
Then status 200
* call read('classpath:examples/Polling/Polling.feature') 
    
# Get Definitions
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': 'REGTEST_Mediation'  }
* match DefFromPub.response.sequences == '#[0]'
	
# Delete the API
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }


#------------------------END----------------------------------#
  @parallel=false @Custom
Scenario: Add custom Mediation and test persistence
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = 'REGTEST_REGTEST'
And header apigateway-basepath = 'mediation'
* json myReq = read('Swagger-mediation.json')
* set myReq.swagger.info.title = 'Regtest_CustomMediation'
* set myReq.apiConf.domain = 'event'
And request myReq
When method post
Then status 200
* call read('classpath:examples/Polling/Polling.feature') 
	
# Get APIID
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'REGTEST_CustomMediation'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
	
# Get Definitions
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': 'REGTEST_CustomMediation'  }
* match DefFromPub.response.sequences == '#[0]'
		
# Add custom Mediation	
Given url PublisherURL
And path APIIDPub + '/policies/mediation'
* def auth = callonce read('classpath:examples/Tokens/CreateToken.feature') {'createAccessToken': 'createAccessToken'  } 
* print 'auth token for add custom mediation' , auth.createAccessToken
And  header Authorization = auth.createAccessToken 
And request read('mediation.json')
When method post
Then status 201
	
# Get custom mediation before Update
Given url PublisherURL
And path APIIDPub + '/policies/mediation'
* def auth = callonce read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken'  } 
* print 'auth token for add custom mediation' , auth.viewAccessToken
And  header Authorization = auth.viewAccessToken 
When method get
Then status 200
* match response.list[0].name == 'custom_header_fault'
	
# Enable Custom Mediation
* def utils = Java.type('examples.Publisher.CustomMediationPersistence')
* def result = utils.main()
			
# Updating the API
 Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = 'REGTEST_REGTEST'
And header apigateway-basepath = 'mediation'
* json myReq = read('Swagger-mediation.json')
* set myReq.swagger.info.description = 'Updated Mediation API'
* set myReq.swagger.info.title = 'Regtest_CustomMediation'
* set myReq.apiConf.domain = 'event'
And request myReq
When method post
Then status 200
* call read('classpath:examples/Polling/Polling.feature') 
    
# Get Definitions
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': 'REGTEST_CustomMediation'  }
* match DefFromPub.response.sequences[0].name == 'custom_header_fault'
	
# Delete the API
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
	
#---------------------------------------------------------------------------------#
 @parallel=false @Throttle
Scenario: Add Advanced throttling policy via publisher and test throttling via store
 Given url Admin
 * def name = 'Throttle-' + now()
* def Title = 'Regtest' + name
* json myReq = read('Swagger-Throttling.json')
* set myReq.swagger.info.title = Title
* def basepath = 'country' + now()
* set myReq.swagger.basePath = basepath
And request myReq
When method post
Then status 200

# Get APIID
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(Title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

# Add throttling Policy via Publisher
* def utils = Java.type('examples.Publisher.AddAdvancedThrottlingPolicy')
* def result = utils.main(Title)

# Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

#Invoke API through External Gateway
#* configure retry = { count: 5, interval: 5000 }
Given url externalGateway
And path 'event' +'/' + basepath + '/v1/countries'
* request 'test'
When method get
#* retry until responseStatus == 200
* print ' response code from random External Gateway: ' , responseStatus
* match responseStatus == 200

#Invoke API through External Gateway
Given url externalGateway
And path 'event' +'/' + basepath + '/v1/countries'
* request 'test'
When method get
#* retry until responseStatus == 429
* print ' response code from random External Gateway: ' , responseStatus
* match responseStatus == 429

# Delete the API
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

 @parallel=false 
Scenario: Add Advanced throttling policy via publisher and test throttling via store for an authenticated API
 Given url Admin
 * def name = 'ThrottleAuth-' + now()
* def Title = 'Regtest' + name
* json myReq = read('Swagger-AuthThrottling.json')
* set myReq.swagger.info.title = Title
* def basepath = 'country' + now()
* set myReq.swagger.basePath = basepath
And request myReq
When method post
Then status 200

# Get APIID
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(Title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

# Add throttling Policy via Publisher
* def utils = Java.type('examples.Publisher.AddAdvancedThrottlingPolicy')
* def result = utils.main(Title)

# Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(Title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

# subscribe
# create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
* def applicationID = applicationDetails.response.applicationId

# generate keys
* def applicationKeyDetails = call read('classpath:examples/Services/GenerateSandboxApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessToken = 'Bearer '+ applicationKeyDetails.response.token.accessToken

# subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
* def subscriptionId = subscriptionDetails.response.subscriptionId

#Invoke API through External Gateway
#* configure retry = { count: 5, interval: 5000 }
Given url externalGateway
And path 'flight' +'/' + basepath + '/v1/countries'
And header Authorization = accessToken
When method get
#* retry until responseStatus == 200
* print ' response code from random External Gateway: ' , responseStatus
* match responseStatus == 200

#Invoke API through External Gateway
Given url externalGateway
And path 'flight' +'/' + basepath + '/v1/countries'
And header Authorization = accessToken
When method get
#* retry until responseStatus == 429
* print ' response code from random External Gateway: ' , responseStatus
* match responseStatus == 429

# Delete the API
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }


@ThrottleGroup @parallel=false
Scenario Outline: Advanced Throttling policy persistence on api level for unauthenticated API
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = 'REGTEST_REGTEST'
And header apigateway-basepath = 'countrypipe'
 * def name = '1-' + now()
* def Title = 'Regtest' + name
* json myReq = read('Swagger-AuthThrottling.json')
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.info.title = Title
And request myReq
When method post
Then status 200

* def domain = <domain>
# Get APIID
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(Title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

# Add throttling Policy via Publisher
* def utils = Java.type('examples.Publisher.AddAdvancedThrottlingPolicy')
* def result = utils.main(Title)

# Get API Definition from publisher
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': '#(Title)'  }
* match DefFromPub.response.apiLevelPolicy == 'Tiered_Query_Param_Throttling'
* print ' API Definition with API Policy', DefFromPub.response.apiLevelPolicy

# Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(Title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr


# Update API after adding policy
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = 'REGTEST_REGTEST'
And header apigateway-basepath = 'countrypipe'
* json myReq = read('Swagger-AuthThrottling.json')
* set myReq.swagger.info.title = Title
* set myReq.swagger.info.version = <version>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.info.description = <description>
* set myReq.apiConf.defaultVersion = <defaultVersion>
* set myReq.apiConf.includeVersion = <includeVersion>
And request myReq
When method post
Then status 200

# Get APIID
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(Title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

# Get API Definition from publisher
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': '#(Title)'  }
* match DefFromPub.response.apiLevelPolicy == 'Tiered_Query_Param_Throttling'
* print ' API Definition with API Policy', DefFromPub.response.apiLevelPolicy

# Delete the API
* call read('classpath:examples/Polling/Polling.feature') 
#* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:
|description             |version|defaultVersion|includeVersion|domain        |
|'Initial Update '       |'v1'   |true          |true          |'test'        |
|'Initial Update '       |'v1'   |false         |true          |'event'       |
|'Initial Update '       |'v1'   |true          |false         |'flight'      |
|'Initial Update '       |'v1'   |false         |false         |'customer'    |
|'Initial Update for v2 '|'v2'   |true          |true          |'partner'     |
|'Initial Update for v2 '|'v2'   |true          |false         |'notification'|
|'Initial Update for v2 '|'v2'   |false         |true          |'car'         |
|'Initial Update for v2 '|'v2'   |false         |false         |'business'    |


 @Resource @parallel=false
Scenario Outline: Advanced Throttling policy persistence on resource  level for unauthenticated API
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = 'REGTEST_REGTEST'
And header apigateway-basepath = 'countrypipe'
 * def name = '1-' + now()
* def Title = 'Regtest' + name
* json myReq = read('Swagger-AuthThrottling.json')
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.info.title = Title
And request myReq
When method post
Then status 200

* def domain = <domain>
# Get APIID
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(Title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

# Add throttling Policy via Publisher
* def utils = Java.type('examples.Publisher.AddAdvancedThrottlingPolicyAtResourceLevel')
* def result = utils.main(Title)

## Get API Definition from publisher
#* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': '#(Title)'  }
#* match DefFromPub.response.apiLevelPolicy == 'Tiered_Query_Param_Throttling'
#* print ' API Definition with API Policy', DefFromPub.response.apiLevelPolicy
#
## Get the APIID from Store
#* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(Title)'  }
#* def APIIDStr = APPIDFromStore.APIIDStr
#* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr
#
#
#
## Update API after adding policy
#Given url ApiAdminURL
#And path AdminPath
#And header apigateway-apikey = 'REGTEST_REGTEST'
#And header apigateway-basepath = 'countrypipe'
#* json myReq = read('Swagger-AuthThrottling.json')
#* set myReq.swagger.info.title = Title
#* set myReq.swagger.info.version = <version>
#* set myReq.swagger.info.description = <description>
#* set myReq.apiConf.defaultVersion = <defaultVersion>
#* set myReq.apiConf.includeVersion = <includeVersion>
#And request myReq
#When method post
#Then status 200
#
## Get APIID
#* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(Title)'  }
#* def APIIDPub = APPIDFromPublisher.APIIDPub
#
## Get API Definition from publisher
#* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': '#(Title)'  }
#* match DefFromPub.response.apiLevelPolicy == 'Tiered_Query_Param_Throttling'
#* print ' API Definition with API Policy', DefFromPub.response.apiLevelPolicy

# Delete the API
* call read('classpath:examples/Polling/Polling.feature') 
#* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:
|description             |version|defaultVersion|includeVersion|domain        |
|'Initial Update '       |'v1'   |true          |true          |'test'        |
#|'Initial Update '       |'v1'   |false         |true          |'event'       |
#|'Initial Update '       |'v1'   |true          |false         |'flight'      |
#|'Initial Update '       |'v1'   |false         |false         |'customer'    |
#|'Initial Update for v2 '|'v2'   |true          |true          |'partner'     |
#|'Initial Update for v2 '|'v2'   |true          |false         |'notification'|
#|'Initial Update for v2 '|'v2'   |false         |true          |'car'         |
#|'Initial Update for v2 '|'v2'   |false         |false         |'business'    |