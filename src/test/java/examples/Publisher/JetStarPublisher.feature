Feature: This feature tests the publisher actions using jetStar Gateway 
	
# Have an API in publisher , delete created one 
@Publisher @parallel=false @All
Scenario: Create API from Publisher
#Get Create Access Token
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
And request read('Swagger-JetStarNewAPICreation.json')
When method post
Then status 201
	
#----------------------------------------------------------------------------------------
@Publisher @parallel=false @All
Scenario: Search and Retrieve details of an API 
 # Create Access Token
Given url authURL 
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
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'REGTEST_JETSTAR'  }
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
And request read('Swagger-JetStarNewAPICreation.json')
And header Authorization = publishAccessToken 
When method post
Then status 200
	
# Change status to Deprecate
Given url PublisherURL + '/change-lifecycle' 
And param apiId = APIIDPub
And param action = 'Deprecate'
And request read('Swagger-JetStarNewAPICreation.json')
And header Authorization = publishAccessToken 
When method post
Then status 200
	
# Change status to Retire
Given url PublisherURL + '/change-lifecycle'
And param apiId = APIIDPub
And param action = 'Retire'
And request read('Swagger-JetStarNewAPICreation.json')
And header Authorization = publishAccessToken 
When method post
Then status 200
	
# Create new version of the API
Given url PublisherURL + '/copy-api'
And param apiId = APIIDPub
And param newVersion = '2.0.0'
And header Authorization = createAccessToken 
And request read('Swagger-JetStarNewAPICreation.json')
When method post
Then status 201

# Delete API with valid token
Given url PublisherURL + '/' + APIIDPub
And header Authorization = createAccessToken 
When method delete
Then status 200	
	
# Retrieve APIID fr version 2.0.0
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'REGTEST_JETSTAR'  }
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
And   param query = 'name:REGTEST_JETSTAR' 
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
And request read('Swagger-JetStarNewAPICreation.json')
When method post
Then status 401
#-----------------------------------------------------------------------------
	
	
	
	
	
	
