Feature: ReDoc testing

Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }


@parellel=false @ReDoc @network @All
Scenario Outline: Registration of an API with reDoc default to true and false
## Register an API
Given url Admin
* json myReq = read('Swagger-ReDoc.json')
* def name = 'ReDoc-' + now()
* def title = <title> + name
* def basepath = <basepath> + name 
* set myReq.swagger.info.title = title
* set myReq.swagger.info.version = 'v1'
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = basepath
* set myReq.apiConf.redocUpload = <redocUpload>
And request myReq
When method post
* retry until responseStatus == 200 

## Fetch Id and documents from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

## Get document
Given  url PublisherURL
And  path APIIDPub + '/documents' 
* def auth = callonce read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken' }
* print ' auth token ' , auth.viewAccessToken
* header Authorization = auth.viewAccessToken
* retry until responseStatus == 200
When method get 
* print ' document from Publisher' , response
* match response.list[0] == <expected>
* def responseCode = <responseCode>
* def htmlURL = response.list[0].sourceUrl

# check whether the js script is present
#Given url htmlURL
#When method get
#* match response contains 'https://cdn.jsdelivr.net/npm/redoc@next/bundles/redoc.standalone.js'

## check the javascript is up and responding with 200
#Given url 'https://cdn.jsdelivr.net/npm/redoc@next/bundles/redoc.standalone.js'
#When method get 
#* response = '200'

* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
* call read('classpath:examples/Polling/Polling.feature') 

Examples:
|flag |responseCode|expected  |title               |basepath           |domain   |redocUpload|
|true |200         |'#notnull'|'REGTEST_ReDocTrue' |'countryReDocTrue' |'car'    |true       |   
#|false|200         |'#notpresent'   |'REGTEST_ReDocFalse'|'countryReDocFalse'|'partner'|false      |

#----------------------------------------------------------------------------------------------------#
@parellel=false @ReDoc @All
Scenario: Update API with version change and validate the updated doc in publisher
## Register API 
Given url Admin
* json myReq = read('Swagger-ReDoc.json')
* def name = 'ReDoc' + now()
* def title = 'REGTEST_DocUpdate' + name
* def basepath = 'countryReDocUpdate' + name 
* set myReq.swagger.info.title = title
* set myReq.swagger.info.version = 'v1'
* set myReq.apiConf.domain = 'employee'
* set myReq.swagger.basePath = basepath
And request myReq
When method post
* retry until responseStatus == 200 

## Fetch Id and documents from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisherUsingVersion.feature') {'title': '#(title)' , 'version': 'v1'   }
* def APIIDPub = APPIDFromPublisher.APIIDPub

## Get document
Given  url PublisherURL
And  path APIIDPub + '/documents' 
* def auth = callonce read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken' }
* print ' auth token ' , auth.viewAccessToken
* header Authorization = auth.viewAccessToken
* retry until responseStatus == 200
When method get 
* print ' document from Publisher' , response
* def responseCode = 200
* match response.list[0].sourceUrl contains 'v1'

## Update API with version change
Given url Admin
* json myReq = read('Swagger-ReDoc.json')
* set myReq.swagger.info.title = title
* set myReq.swagger.info.version = 'v2'
* set myReq.apiConf.domain = 'employee'
* set myReq.swagger.basePath = basepath
And request myReq
When method post
* retry until responseStatus == 200 
* call read('classpath:examples/Polling/Polling.feature') 

## Fetch Id and documents from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisherUsingVersion.feature') {'title': '#(title)' , 'version': 'v2'  }
* def APIIDPubv2 = APPIDFromPublisher.APIIDPub

# Get Document
## we should see doc for v2 
Given  url PublisherURL
And  path APIIDPubv2 + '/documents' 
* def auth = callonce read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken' }
* print ' auth token ' , auth.viewAccessToken
* header Authorization = auth.viewAccessToken
* retry until responseStatus == 200
When method get 
* print ' document from Publisher' , response
* def responseCode = 200
* match response.list[0].sourceUrl contains 'v2'

## Update API with version change
Given url Admin
* json myReq = read('Swagger-ReDoc.json')
* set myReq.swagger.info.title = title
* set myReq.swagger.info.version = 'v3'
* set myReq.apiConf.domain = 'employee'
* set myReq.swagger.basePath = basepath
And request myReq
When method post
* retry until responseStatus == 200 
* call read('classpath:examples/Polling/Polling.feature') 

## Fetch Id and documents from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisherUsingVersion.feature') {'title': '#(title)' ,'version': 'v3' }
* def APIIDPubv3 = APPIDFromPublisher.APIIDPub

# Get Document
## we should see doc for v3 
Given  url PublisherURL
And  path APIIDPubv3 + '/documents' 
* def auth = callonce read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken' }
* print ' auth token ' , auth.viewAccessToken
* header Authorization = auth.viewAccessToken
* retry until responseStatus == 200
When method get 
* print ' document from Publisher' , response
* def responseCode = 200
* match response.list[0].sourceUrl contains 'v3'
# delete doc 


* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
* call read('classpath:examples/Polling/Polling.feature') 


* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPubv2)'  }
* call read('classpath:examples/Polling/Polling.feature') 


* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPubv3)'  }
* call read('classpath:examples/Polling/Polling.feature') 

#----------------------------------------------------------------------------------------------------#
@parellel=false 
Scenario: ReDoc soap
#UI Test
* def DemoClass = Java.type('examples.ReDoc.ReDoc')
* def myVar = DemoClass.main() 

## Fetch Id and documents from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'SOAPReDoc'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

# Get Document
## we should see doc for soap 
Given  url PublisherURL
And  path APIIDPub + '/documents' 
* def auth = callonce read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken' }
* print ' auth token ' , auth.viewAccessToken
* header Authorization = auth.viewAccessToken
* retry until responseStatus == 200
When method get 
* print ' document from Publisher' , response
* match response.list[0].sourceUrl contains 'v1'
* def responseCode = 200

#-------------------------------------------------------------------------------------------------#
@parellel=false @ReDoc
Scenario Outline: ReDoc lambda docs
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = apiGatewayKey
And header apigateway-basepath = 'lambda-migration'
* json myReq = read('swagger-lambda.json')
* def name = 'ReDoclambda' + now()
* def title = <title> + name
* set myReq.swagger.info.title = title
* set myReq.apiConf.domain = <domain>
* set myReq.apiConf.redocUpload = <redocUpload>
* set myReq.swagger.basePath = 'lambda-migration'
* set myReq.swagger.info.version = 'v1'
And request myReq
When method post
Then status 200

## Fetch Id and documents from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

## Get document
Given  url PublisherURL
And  path APIIDPub + '/documents' 
* def auth = callonce read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken' }
* print ' auth token ' , auth.viewAccessToken
* header Authorization = auth.viewAccessToken
* retry until responseStatus == 200
When method get 
* print ' document from Publisher' , response
* match response.list[0] == <expected>
* def responseCode = 200

* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
* call read('classpath:examples/Polling/Polling.feature') 

Examples:
|flag |responseCode|expected     |title                     |domain    |redocUpload|
|true |200         |'#notnull'   |'REGTEST_ReDocLambdaTrue' |'employee'|true       |   
|false|200         |'#notpresent'|'REGTEST_ReDocLambdaFalse'|'customer'|false      |

#------------------------------------------------------------------------------------------#
@parellel=false @ReDoc
Scenario Outline: include version and default version  variations 
## Register an API
Given url Admin
* json myReq = read('Swagger-ReDoc.json')
* def name = 'ReDocVersion' + now()
* def title = <title> + name
* def basepath = <basepath> + name 
* set myReq.swagger.info.title = title
* set myReq.swagger.info.version = 'v1'
* set myReq.apiConf.redocUpload = true
* set myReq.apiConf.domain = <domain>
* set myReq.apiConf.includeVersion = <IncludeVersion>
* set myReq.apiConf.defaultVersion = <defaultVersion>
* set myReq.swagger.basePath = basepath
And request myReq
When method post
* retry until responseStatus == 200 

## Fetch Id and documents from publisher 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

## Get document
Given  url PublisherURL
And  path APIIDPub + '/documents' 
* def auth = callonce read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken' }
* print ' auth token ' , auth.viewAccessToken
* header Authorization = auth.viewAccessToken
* retry until responseStatus == 200
When method get 
* print ' document from Publisher' , response
* match response.list[0].sourceUrl contains 'v1'
* def responseCode = 200

* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
* call read('classpath:examples/Polling/Polling.feature') 

Examples:
|IncludeVersion|defaultVersion|title                               |basepath           |domain|
|true          |false         |'REGTEST_DocVersionTruedefaultfalse'  |'countrytruefalse' |'flight'|
|true		   |true          |'REGTEST_DocVersionTruedefaulttrue'  |'countrytruetrue'  |'notification'|
|false         |true          |'REGTEST_DocVersionfalsedefaulttrue'  |'countryfalsetrue' |'business'|
|false         |false         |'REGTEST_DocVersionfalsedefaultfalse' |'countryfalsefalse'|'event'|

#---------------------------------------------------------------------------------------------------------#
@parellel=false @ReDocInternet @ReDoc @All
Scenario Outline: ReDoc for Internet APIs
Given url Admin
* json myReq = read('Swagger-InternetAPI.json')
* def name = 'ReDocInternet' + now()
* def title = <title> + name
* def basepath = <basepath> + name
* set myReq.swagger.info.title = title
* set myReq.apiConf.domain = <domain>
* set myReq.apiConf.redocUpload = <redocUpload>
* set myReq.swagger.basePath = basepath
* request myReq
When method post
Then status 200

# Get the APIID from Publisher
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

## Get document
Given  url PublisherURL
And  path APIIDPub + '/documents' 
* def auth = callonce read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken' }
* print ' auth token ' , auth.viewAccessToken
* header Authorization = auth.viewAccessToken
* retry until responseStatus == 200
When method get 
* print ' document from Publisher' , response
* match response.list[0] == <expected>
* def responseCode = 200

* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
* call read('classpath:examples/Polling/Polling.feature') 

Examples:
|flag |responseCode|expected     |title                       |domain    |redocUpload|basepath                   |
|true |200         |'#notnull'   |'REGTEST_ReDocInternetTrue' |'employee'|true       |'countryReDocInternettrue' |   
|false|200         |'#notpresent'|'REGTEST_ReDocInternetFalse'|'customer'|false      |'countryReDocInternetfalse'|


#-------------------------------------------------------------------------------------------------------------------#
@parellel=false @ReDocInternet @ReDoc @markdown @All
Scenario Outline: markdown header test 
Given url Admin
* json myReq = read('<markdownpattern>.json')
* def name = 'Regtest' + now()
* def title = <title> + name
* def basepath = <basepath> + name
* set myReq.swagger.info.title = title
* set myReq.apiConf.domain = <domain>
* set myReq.apiConf.redocUpload = <redocUpload>
* set myReq.swagger.basePath = basepath
* request myReq
When method post
Then status 200

# Get the APIID from Publisher
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

## Get document
Given  url PublisherURL
And  path APIIDPub + '/documents' 
* def auth = callonce read('classpath:examples/Tokens/ViewToken.feature') {'viewAccessToken': 'viewAccessToken' }
* print ' auth token ' , auth.viewAccessToken
* header Authorization = auth.viewAccessToken
* retry until responseStatus == 200
When method get 
* print ' document from Publisher' , response
* match response.list[0] == <expected>
* def responseCode = 200

* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
* call read('classpath:examples/Polling/Polling.feature') 

Examples:
|flag |responseCode|expected     |title            |domain        |redocUpload |basepath        |markdownpattern |
|true |200         |'#notnull'   |'ReDocMarkdown1' |'employee'    |true        |'countryMark1'  |markdownpattern1|   
|true |200         |'#notnull'   |'ReDocMarkdown2' |'customer'    |true        |'countryMark2'  |markdownpattern2|
|true |200         |'#notnull'   |'ReDocMarkdown3' |'notification'|true        |'countryMark3'  |markdownpattern3|
|true |200         |'#notnull'   |'ReDocMarkdown4' |'car'         |true        |'countryMark4'  |markdownpattern4|
|true |200         |'#notnull'   |'ReDocMarkdown5' |'business'    |true        |'countryMark5'  |markdownpattern5|

##-------------------------------------------------- END ------------------------------------------------------------##
	