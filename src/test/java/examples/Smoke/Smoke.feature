Feature: Smoke Tests

Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }
* configure retry = { count: 7, interval: 5000 }

#-------------------------------------------------------------------------------
@SmokeUAT @CountrySmoke
Scenario: Register API and check for mandatory fields 
#****************------ ADMIN ----------*****************
Given url Admin
And header Authorization = AdminPassword
* def name = '1-' + now()
* json myReq = read('Swagger-Smoke.json')
* def title = 'Smoke_test' + name
* def basepath = 'countrysmoke' + name
* set myReq.swagger.info.title = title
* set myReq.swagger.basePath = basepath
And request myReq
When method post
Then status 200

# Validations of fields 
* match myReq.swagger.info.description == '#present'
* match myReq.swagger.info.description == '#notnull'
* match myReq.swagger.info.version == '#present'
* match myReq.swagger.info.version == '#notnull'
* match myReq.apiConf.includeVersion == '#present'
* match myReq.apiConf.includeVersion == '#notnull'
* def validDomains = { domain: ['customer', 'employee', 'product', 'booking', 'flight', 'aircraft', 'notification', 'freight', 'checkin', 'loyalty', 'event', 'partner', 'entertainment'] } 
* match myReq.apiConf.domain == '#notnull'
* match myReq.swagger.info.x-businessOwner == '#present'
* match myReq.swagger.info.x-businessOwner.name == '#present'
* match myReq.swagger.info.x-businessOwner.email == '#present'
* match myReq.swagger.info.x-technicalOwner == '#present'
* match myReq.swagger.info.x-technicalOwner.name == '#present'
* match myReq.swagger.info.x-technicalOwner.email == '#present'
* match myReq.swagger.info.x-businessOwner.email contains '@random.com'
* match myReq.swagger.info.x-businessOwner == '#notnull'
* match myReq.swagger.info.x-businessOwner.name == '#notnull'
* match myReq.swagger.info.x-businessOwner.email == '#notnull'
* match myReq.swagger.info.x-technicalOwner == '#notnull'
* match myReq.swagger.info.x-technicalOwner.name == '#notnull'
* match myReq.swagger.info.x-technicalOwner.email == '#notnull'

#****************------ KEYMAN ---------*****************
# Generate Token to view the API
Given   url authURL 
And   header Authorization = Authorization 
And   form field grant_type = 'client_credentials' 
And   form field scope = 'apim:api_view' 
When   method post 
Then   status 200 
* def viewAccessToken = 'Bearer ' + response.access_token 
* print 'viewAccessToken is ' , viewAccessToken 

#****************------ PUBLISHER ---------*****************
# Validate Successful registration
* configure retry = { count: 5, interval: 5000 }
Given  url PublisherURL + '?' 
And  param query = 'name:' + title
* header Authorization = viewAccessToken
* retry until responseStatus == 200 && response.list[0].id != ''
When method get 
* def APIIDPub = response.list[0].id 
* def responseCode = responseStatus
* print 'APIID from Publisher is: ' , APIIDPub 

#****************------ STORE ---------*****************
Given url storeURL
And param query = 'name:' + title
And  header Authorization = viewAccessToken 
* retry until responseStatus == 200 && response.list[0].id != ''
When method get 
* def APIIDStr = response.list[0].id 
* def responseCode = responseStatus
* print 'APIID from Store is: ' , APIIDStr


# Create subscribe token
Given url authURL
And header Authorization = Authorization
And form field grant_type = 'client_credentials'
And form field scope = 'apim:subscribe'
When method post
Then status 200
* def subscribeToken = 'Bearer ' + response.access_token
* print 'SubscriberToken is ', subscribeToken

# Create an Application
Given url applicationURL
And path 'applications'
And header Authorization = subscribeToken
* def name = 'Smoke_Test-' + now()
And request {"throttlingTier": "Unlimited","description": "sample app description","name": '#(name)' ,"callbackUrl": "https:/apistore-uat-dev-a878-14-ams10-nonp.cloud.random.com/callback"}
When method post
Then status 201
* def applicationID = response.applicationId
* print 'applicationId is ', applicationID

# Subscribe to an API
Given url applicationURL
And path 'subscriptions'
And header Authorization = subscribeToken
And request {'tier': 'Unlimited' ,'apiIdentifier': '#(APIIDStr)','applicationId': '#(applicationID)'}
When method post
Then status 201
* def subscriptionId = response.subscriptionId
* print 'subscriptionID is ', subscriptionId 
* def status = response.status
* match response.status == 'ON_HOLD'
* print 'subscribed with status ', status , ' and subscriptionID ' , subscriptionId  
* def BPS = BPS
* def BPS_PASSWORD = BPS_PASSWORD
* print ' BPS url is ', BPS
* call read('classpath:examples/Smoke/BPSWorkflow.feature') {'BPS': '#(BPS)' , 'BPS_PASSWORD': '#(BPS_PASSWORD)' }

# get details of subscription - It should be unblocked
Given url applicationURL 
And path '/subscriptions/' + subscriptionId
And header Authorization = subscribeToken
When method get
Then status 200
* print 'responseStatus of subscription should now be ', response.status , ' for tier' , response.tier
* match response.status == 'UNBLOCKED'

# Generate Production keys for the application
Given url applicationURL + '/applications/generate-keys?'
And param applicationId = applicationID
And header Authorization = subscribeToken
And request {"validityTime": "3600","keyType": "PRODUCTION","accessAllowDomains": ["ALL"]}
When method post
Then status 200
* def accessTokenforInvokation = 'Bearer '+ response.token.accessToken
* print 'accessTokenforInvokation is ', accessTokenforInvokation 

#Generate Sandbox keys for the application
Given url applicationURL + '/applications/generate-keys?'
And param applicationId = applicationID
And header Authorization = subscribeToken
And request {"validityTime": "3600","keyType": "SANDBOX","accessAllowDomains": ["ALL"]}
When method post
Then status 200
* def accessTokenforInvokationProd = 'Bearer '+ response.token.accessToken
* print 'accessTokenforInvokationProd is ', accessTokenforInvokationProd 

#****************------ WORKMAN ---------*****************
#Invoke authenticated resource API through random Internal Gateway
Given url internalGateway
And path '/customer/' + basepath + '/country/countries'
And header Authorization = accessTokenforInvokationProd
* retry until responseStatus == 200
When method get
* print ' response code from random Internal Gateway: ' , responseStatus

#Invoke authenticated resource API through random External Gateway
#Given url externalGateway
#And path '/customer/' + basepath + '/country/countries'
#And header Authorization = accessTokenforInvokationProd
#* retry until responseStatus == 200
#When method get
#* print ' response code from random Internal Gateway: ' , responseStatus

#****************------ WORKMANJG ---------*****************
#Invoke authenticated resource API through Jetstar Internal Gateway
Given url internalGateway
And path '/customer/' + basepath + '/country/countries'
And header Authorization = accessTokenforInvokationProd
* retry until responseStatus == 200
When method get
* print ' response code from random Internal Gateway: ' , responseStatus

#Invoke authenticated resource API through Jetstar External Gateway
Given url internalGateway
And path '/customer/' + basepath + '/country/countries'
And header Authorization = accessTokenforInvokationProd
* retry until responseStatus == 200
When method get
* print ' response code from Jetstar External Gateway: ' , responseStatus

#****************------ random NGINX ---------*****************
# Invoke authenticated resource API through random Internal NGINX
Given url gatewayNGINX
And path '/customer/' + basepath + '/country/countries'
And header Authorization = accessTokenforInvokationProd
* retry until responseStatus == 200
When method get
* print ' response code from random NGINX Internal Gateway: ' , responseStatus

# Invoke authenticated resource API through random External NGINX
Given url gatewayNGINX
And path '/customer/' + basepath +  '/country/countries'
And header Authorization = accessTokenforInvokationProd
And header Host = 'api-stage.random.com'
* retry until responseStatus == 200
When method get
* print ' response code from random NGINX External Gateway: ' , responseStatus


#****************------ JETSTAR NGINX ---------*****************
# Invoke authenticated resource API through random Internal NGINX
Given url jetstarGatewayNGINX
And path '/customer/' + basepath + '/country/countries'
And header Authorization = accessTokenforInvokationProd
* retry until responseStatus == 200
When method get
* print ' response code from random NGINX Internal Gateway: ' , responseStatus

# Invoke authenticated resource API through random External NGINX
Given url jetstarGatewayNGINX
And path '/customer/' + basepath + '/country/countries'
And header Authorization = accessTokenforInvokationProd
And header Host = 'apis-stage.jetstar.com'
* retry until responseStatus == 200
When method get
* print ' response code from random NGINX External Gateway: ' , responseStatus

# Delete Application
Given url applicationURL + '/applications/'
And path applicationID
* header Authorization = subscribeToken
* retry until responseStatus == 200 
When method delete

# create token 
Given   url authURL 
And   header Authorization = Authorization 
And   form field grant_type = 'client_credentials' 
And   form field scope = 'apim:api_create' 
When   method post 
Then   status 200 
* def createAccessToken = 'Bearer ' + response.access_token 
* print 'createAccessToken is ' , createAccessToken 

# Delete API
Given url PublisherURL
And path APIIDPub
* header Authorization = createAccessToken
* retry until responseStatus == 200 
When method delete

@ProxySmoke @SmokeUAT
Scenario: Test Proxy service 
#****************------ ADMIN ----------*****************
Given url Admin
And header Authorization = AdminPassword
* def name = '1-' + now()
* json myReq = read('Swagger-ProxyServiceSmoke.json')
* def title = 'AWSProxySmoke_test' + name
* set myReq.swagger.info.title = title
And request myReq
When method post
Then status 200

Given   url authURL 
And   header Authorization = Authorization 
And   form field grant_type = 'client_credentials' 
And   form field scope = 'apim:api_view' 
When   method post 
Then   status 200 
* def viewAccessToken = 'Bearer ' + response.access_token 
* print 'viewAccessToken is ' , viewAccessToken 

# Validate Successful registration
* configure retry = { count: 5, interval: 5000 }
Given  url PublisherURL + '?' 
And  param query = 'name:' + title
* header Authorization = viewAccessToken
* retry until responseStatus == 200 && response.list[0].id != ''
When method get 
* def APIIDPub = response.list[0].id 
* def responseCode = responseStatus
* print 'APIID from Publisher is: ' , APIIDPub

#****************------ UPDATE THE PROXY SERVICE URL TO DEPLOYED DNS / RELEASED DNS  ----------*****************
# create token 
Given   url authURL 
And   header Authorization = Authorization 
And   form field grant_type = 'client_credentials' 
And   form field scope = 'apim:api_create' 
When   method post 
Then   status 200 
* def createAccessToken = 'Bearer ' + response.access_token 
* print 'createAccessToken is ' , createAccessToken 


# Validate Successful registration
Given  url PublisherURL
And  path APIIDPub  
* header Authorization = viewAccessToken
* retry until responseStatus == 200
When method get 
* def APIDef = response
* print ' Definition from Publisher' , APIDef
* string endpoints = APIDef.endpointConfig
* print ' endpoints' , endpoints
* def start = endpoints.indexOf('production_endpoints":{"url":"')
* def Prodref = endpoints.substring(start + 23)
* def end = Prodref.indexOf('/customer')
* def Prodref = Prodref.substring(0, end)
* print 'prod host  ', Prodref
* def newURL = ProxyService
* print 'Replacing the host with deployed/released URL ', newURL
* def endpointConfig = '{\"production_endpoints\":{\"url\":\"https://' + newURL + '/customer/lambdaTest/v1\",\"config\":null},\"sandbox_endpoints\":{\"url\":\"https://' + newURL + '/customer/lambdaTest/v1\",\"config\":null},\"endpoint_type\":\"http\"}'

# update Proxy in publisher
Given url PublisherURL
And path APIIDPub
And  header Authorization = createAccessToken
* json myReq = APIDef
* set myReq.endpointConfig = endpointConfig
* request myReq
When method put
Then status 200


#****************------ WORKMAN ---------*****************
#Invoke authenticated resource API through random Internal Gateway
Given url internalGateway
And path '/customer/lambdaTest/v1/quote.2'
* retry until responseStatus == 200
When method get
* print ' response code from random Internal Gateway: ' , responseStatus

#Invoke authenticated resource API through random External Gateway
#Given url externalGateway
#And path '/customer/lambdaTest/v1/quote.2'
#* retry until responseStatus == 200
#When method get
#* print ' response code from random Internal Gateway: ' , responseStatus

#****************------ WORKMANJG ---------*****************
#Invoke authenticated resource API through Jetstar Internal Gateway
Given url internalGateway
And path '/customer/lambdaTest/v1/quote.2'
* retry until responseStatus == 200
When method get
* print ' response code from random Internal Gateway: ' , responseStatus

#Invoke authenticated resource API through Jetstar External Gateway
Given url internalGateway
And path '/customer/lambdaTest/v1/quote.2'
* retry until responseStatus == 200
When method get
* print ' response code from Jetstar External Gateway: ' , responseStatus

#****************------ random NGINX ---------*****************
# Invoke authenticated resource API through random Internal NGINX
Given url gatewayNGINX
And path '/customer/lambdaTest/v1/quote.2'
* retry until responseStatus == 200
When method get
* print ' response code from random NGINX Internal Gateway: ' , responseStatus

# Invoke authenticated resource API through random External NGINX
Given url gatewayNGINX
And path '/customer/lambdaTest/v1/quote.2'
And header Host = 'api-stage.random.com'
* retry until responseStatus == 200
When method get
* print ' response code from random NGINX External Gateway: ' , responseStatus


#****************------ JETSTAR NGINX ---------*****************
# Invoke authenticated resource API through random Internal NGINX
Given url jetstarGatewayNGINX
And path '/customer/lambdaTest/v1/quote.2'
* retry until responseStatus == 200
When method get
* print ' response code from random NGINX Internal Gateway: ' , responseStatus

# Invoke authenticated resource API through random External NGINX
Given url jetstarGatewayNGINX
And path '/customer/lambdaTest/v1/quote.2'
And header Host = 'apis-stage.jetstar.com'
* retry until responseStatus == 200
When method get
* print ' response code from random NGINX External Gateway: ' , responseStatus

# create token 
Given   url authURL 
And   header Authorization = Authorization 
And   form field grant_type = 'client_credentials' 
And   form field scope = 'apim:api_create' 
When   method post 
Then   status 200 
* def createAccessToken = 'Bearer ' + response.access_token 
* print 'createAccessToken is ' , createAccessToken 

# Delete API
Given url PublisherURL
And path APIIDPub
* header Authorization = createAccessToken
* retry until responseStatus == 200 
When method delete

# ---------------------------------------------------------------- # 




