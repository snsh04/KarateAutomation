Feature: Validate contentType

Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }
* configure retry = { count: 7, interval: 5000 }
* def accessTokenforProd = 'Bearer 52ad2216-4cb4-3118-acaa-149f5c932493'
* def authbasepath = 'AuthContentType'


@parellel=false @contentType @urlencoded
Scenario: Register unauthenticated API with swagger having different content types 
Given url Admin
* json myReq = read('Swagger-contentType.json')
* set myReq.apiConf.subscriptionTiers = ['Silver_Auto-Approved','Gold_Auto-Approved','Bronze_Auto-Approved']
* def name = '1-' + now()
* def title = 'REGTEST_ContentType' + name
* def basepath = 'testContentType'
* set myReq.swagger.info.title = title
* set myReq.swagger.info.version = 'v1111'
* set myReq.apiConf.domain = 'aircraft'
* set myReq.swagger.basePath = basepath
And request myReq
When method post
Then status 200

@parellel=false @contentType
Scenario Outline: ContentType - application/xml, application/json, text/xml, text/plain, application/ld_json and application/xml+soap  for unauthenticated
* def basepath = <basepath>
* def domain = <domain>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def version = 'v1111'
* def contentType = <contentType>


* call read('classpath:examples/Polling/Polling.feature') 

#Invoke External gateway
Given url externalGateway
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And header Content-Type = 'application/xml'
* request read(<request>)
* retry until responseStatus == externalGatewayResponse
When method post
* print ' response code from random External Gateway: ' , responseStatus
* match response.body == '#notnull'
* call read('classpath:examples/Polling/Polling.feature') 

#Invoke Internal gateway
Given url internalGateway
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And header Content-Type = contentType
* request read(<request>)
* retry until responseStatus == internalGatewayResponse
When method post
* print ' response code from random External Gateway: ' , responseStatus
* match response.body == '#notnull'
* call read('classpath:examples/Polling/Polling.feature') 

#Invoke NGINX External gateway
Given url gatewayNGINX
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And header Host = 'api-test.random.com'
And header Content-Type = 'application/xml'
* request read(<request>)
* retry until responseStatus == externalGatewayResponse
When method post
* print ' response code from random NGINX External Gateway: ' , responseStatus
* match response.body == '#notnull'
* call read('classpath:examples/Polling/Polling.feature') 

#Invoke NGINX Internal gateway
Given url gatewayNGINX
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And header Content-Type = contentType
* request read(<request>)
* retry until responseStatus == internalGatewayResponse
When method post
* print ' response code from random NGINX External Gateway: ' , responseStatus
* match response.body == '#notnull'
* call read('classpath:examples/Polling/Polling.feature') 

Examples:
|domain    |basepath         |contentType        |internalGatewayResponse  |externalGatewayResponse     |path     |request           |
|'aircraft'|'testContentType'|'application/xml'  |200         			   |200                         |'test-2' |'XMLrequest.xml'  |
|'aircraft'|'testContentType'|'application/json' |200         			   |200                         |'test-1' |'JSONrequest.json'|
|'aircraft'|'testContentType'|'text/xml'         |200         			   |200                         |'test-3' |'XMLrequest.xml'  |
|'aircraft'|'testContentType'|'test/plain'       |200         			   |200                         |'test-5' |'TEXTrequest.txt'  |
|'aircraft'|'testContentType'|'application/ld+json'  |200           	   |200                         |'test-13' |'JSONForLinkingDatarequest.json'  |
|'aircraft'|'testContentType'|'application/xml+soap'  |200           	   |200                         |'test-13' |'SOAPrequest.xml'  |

@parellel=false @contentType
Scenario Outline: Content Type as application/x-www-form-urlencoded for unathenticated API
* def basepath = <basepath>
* def domain = <domain>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def version = 'v1111'
* def contentType = <contentType>

* call read('classpath:examples/Polling/Polling.feature') 

#Invoke External gateway
Given url externalGateway
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And header Content-Type = contentType
And form field username = 'nobody'
And form field password = 'idonotexist'
And form field test = '(~`!@$%20%20^%26*()_+-={}[]|\:";,./<>?12a3567890345)'
* retry until responseStatus == externalGatewayResponse
When method post
* print ' response code from random External Gateway: ' , responseStatus
* match response.body == '#notnull'
* call read('classpath:examples/Polling/Polling.feature') 

#Invoke Internal gateway
Given url internalGateway
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And header Content-Type = contentType
And form field username = 'nobody'
And form field password = 'idonotexist'
And form field test = '(~`!@$%20%20^%26*()_+-={}[]|\:";,./<>?12a3567890345)'
* retry until responseStatus == internalGatewayResponse
When method post
* print ' response code from random External Gateway: ' , responseStatus
* match response.body == '#notnull'
* call read('classpath:examples/Polling/Polling.feature') 

#Invoke NGINX External gateway
Given url gatewayNGINX
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And header Content-Type = contentType
And form field username = 'nobody'
And form field password = 'idonotexist'
And header Host = 'api-test.random.com'
And form field test = '(~`!@$%20%20^%26*()_+-={}[]|\:";,./<>?12a3567890345)'
* retry until responseStatus == externalGatewayResponse
When method post
* print ' response code from random External Gateway: ' , responseStatus
* match response.body == '#notnull'
* call read('classpath:examples/Polling/Polling.feature') 

#Invoke NGINX Internal gateway
Given url gatewayNGINX
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And header Content-Type = contentType
And form field username = 'nobody'
And form field password = 'idonotexist'
And form field test = '(~`!@$%20%20^%26*()_+-={}[]|\:";,./<>?12a3567890345)'
* retry until responseStatus == internalGatewayResponse
When method post
* print ' response code from random External Gateway: ' , responseStatus
* match response.body == '#notnull'
* call read('classpath:examples/Polling/Polling.feature') 

Examples:
|domain    |basepath         |contentType        |internalGatewayResponse    |externalGatewayResponse    |path    |
|'aircraft'|'testContentType'|'application/x-www-form-urlencoded'  |200         			   |200                         |'test-4' |

@parellel=false @contentType
Scenario Outline: Content-Type application/octet-stream for unathenticated API
* def basepath = <basepath>
* def domain = <domain>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def version = 'v1111'
* def contentType = <contentType>

# External Gateway
Given url externalGateway
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And multipart field myFile = read('Akamai.pdf')
And multipart field message = 'Akamai Doc'
And header Content-Type = contentType
* retry until responseStatus == internalGatewayResponse
When method post
Then status 200
* print ' response code from random External Gateway: ' , responseStatus
* match response.body == '#notnull'
* call read('classpath:examples/Polling/Polling.feature') 
   
# Internal Gateway
Given url externalGateway
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And multipart field myFile = read('Akamai.pdf')
And multipart field message = 'Akamai Doc'
And header Content-Type = contentType
* retry until responseStatus == internalGatewayResponse
When method post
Then status 200
* print ' response code from random External Gateway: ' , responseStatus
* match response.body == '#notnull'
* call read('classpath:examples/Polling/Polling.feature') 

# NGINX External Gateway
Given url gatewayNGINX
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And multipart field myFile = read('Akamai.pdf')
And header Host = 'api-test.random.com'
And multipart field message = 'Akamai Doc'
And header Content-Type = contentType
* retry until responseStatus == internalGatewayResponse
When method post
Then status 200
* print ' response code from random External Gateway: ' , responseStatus
* match response.body == '#notnull'
* call read('classpath:examples/Polling/Polling.feature') 
   
# NGINX Internal Gateway
Given url gatewayNGINX
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And multipart field myFile = read('Akamai.pdf')
And multipart field message = 'Akamai Doc'
And header Content-Type = contentType
* retry until responseStatus == internalGatewayResponse
When method post
Then status 200
* print ' response code from random External Gateway: ' , responseStatus
* match response.body == '#notnull'
* call read('classpath:examples/Polling/Polling.feature') 

Examples:
|domain    |basepath         |contentType                 |internalGatewayResponse    |externalGatewayResponse    |path    |
|'aircraft'|'testContentType'|'application/octet-stream'  |200         			   |200                           |'test-8' |

@parellel=false @contentType
Scenario Outline: Content-Type application/pdf for unathenticated API
* def basepath = <basepath>
* def domain = <domain>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def version = 'v1111'
* def contentType = <contentType>

# External 
Given url externalGateway
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And multipart file myFile = { read: 'Akamai.pdf', filename: 'Akamai.pdf', contentType: 'application/pdf' }
And multipart field message = 'hello world'
* retry until responseStatus == internalGatewayResponse
When method post
Then status 200

# NGINX External
Given url gatewayNGINX
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And header Host = 'api-test.random.com'
And multipart file myFile = { read: 'Akamai.pdf', filename: 'Akamai.pdf', contentType: 'application/pdf' }
And multipart field message = 'hello world'
* retry until responseStatus == internalGatewayResponse
When method post
Then status 200


Examples:
|domain    |basepath         |contentType                 |internalGatewayResponse    |externalGatewayResponse    |path    |
|'aircraft'|'testContentType'|'application/pdf'           |200          			  |200                        |'test-8' |



@parellel=false @contentType
Scenario Outline: Content-Type application/zip for unathenticated API
* def basepath = <basepath>
* def domain = <domain>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def version = 'v1111'
* def contentType = <contentType>

# External Gateway
Given url gatewayNGINX
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And header Host = 'api-test.random.com'
And multipart file myFile = { read: 'plans.zip', filename: 'plans.zip', contentType: contentType }
And multipart field message = 'hello world'
* retry until responseStatus == internalGatewayResponse
When method post
Then status 200

# NGINX External Gateway
Given url externalGateway
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And multipart file myFile = { read: 'plans.zip', filename: 'plans.zip', contentType: contentType }
And multipart field message = 'hello world'
* retry until responseStatus == internalGatewayResponse
When method post
Then status 200

Examples:
|domain    |basepath         |contentType                 |internalGatewayResponse    |externalGatewayResponse    |path    |
|'aircraft'|'testContentType'|'application/zip'  |200         			   |200                           |'test-14' |

#####---------------------------- AUTHENTICATED ---------------------------------####### 
@parellel=false @register
Scenario: Register Authenticated API
* def accessToken = callonce read('classpath:examples/ContentType/register.feature')
# Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': 'REGTEST_AuthContentType'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* print 'APPIDFromStore for random Gateway API: ' , APPIDFromStore.APIIDStr

# Create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
* def applicationID = applicationDetails.response.applicationId

* def accessToken = callonce read('classpath:examples/ContentType/getToken.feature') {'applicationID' : '#(applicationID)' }

* def subscribe = callonce read('classpath:examples/ContentType/subscribetoAPI.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }

* def accessTokenforProd = accessToken.accessTokenforProd
* def authbasepath = accessToken.basepath

@parellel=false @contentType @contentTypewithAuth 
Scenario Outline: ContentType - application/xml, application/json, text/xml, text/plain, application/ld_json and application/xml+soap  for authenticated API
* def basepath = authbasepath
* def domain = <domain>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def version = 'v1112'
* def contentType = <contentType>


* call read('classpath:examples/Polling/Polling.feature') 

#Invoke External gateway
Given url externalGateway
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And header Content-Type = 'application/xml'
And header Authorization = accessTokenforProd
* request read(<request>)
* retry until responseStatus == externalGatewayResponse
When method post
* print ' response code from random External Gateway: ' , responseStatus
* match response.body == '#notnull'
* call read('classpath:examples/Polling/Polling.feature') 

#Invoke Internal gateway
Given url internalGateway
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And header Content-Type = contentType
And header Authorization = accessTokenforProd
* request read(<request>)
* retry until responseStatus == internalGatewayResponse
When method post
* print ' response code from random External Gateway: ' , responseStatus
* match response.body == '#notnull'
* call read('classpath:examples/Polling/Polling.feature') 

Examples:
|domain    |contentType        |internalGatewayResponse  |externalGatewayResponse     |path     |request           |
|'aircraft'|'application/xml'  |200         			   |200                         |'test-2' |'XMLrequest.xml'  |
|'aircraft'|'application/json' |200         			   |200                         |'test-1' |'JSONrequest.json'|
|'aircraft'|'text/xml'         |200         			   |200                         |'test-3' |'XMLrequest.xml'  |
|'aircraft'|'test/plain'       |200         			   |200                         |'test-5' |'TEXTrequest.txt'  |
|'aircraft'|'application/ld+json'  |200           	   |200                         |'test-12' |'JSONForLinkingDatarequest.json'  |
|'aircraft'|'application/xml+soap'  |200           	   |200                         |'test-13' |'SOAPrequest.xml'  |

@parellel=false @contentTypewithAuth
Scenario Outline: Content Type as application/x-www-form-urlencoded for athenticated API
* def basepath = authbasepath
* def domain = <domain>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def version = 'v1112'
* def contentType = <contentType>

* call read('classpath:examples/Polling/Polling.feature') 

#Invoke External gateway
Given url externalGateway
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And header Content-Type = contentType
And header Authorization = accessTokenforProd
And form field username = 'nobody'
And form field password = 'idonotexist'
And form field test = '(~`!@$%20%20^%26*()_+-={}[]|\:";,./<>?12a3567890345)'
* retry until responseStatus == externalGatewayResponse
When method post
* print ' response code from random External Gateway: ' , responseStatus
* match response.body == '#notnull'
* call read('classpath:examples/Polling/Polling.feature') 

#Invoke Internal gateway
Given url internalGateway
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And header Content-Type = contentType
And header Authorization = accessTokenforProd
And form field username = 'nobody'
And form field password = 'idonotexist'
And form field test = '(~`!@$%20%20^%26*()_+-={}[]|\:";,./<>?12a3567890345)'
* retry until responseStatus == internalGatewayResponse
When method post
* print ' response code from random External Gateway: ' , responseStatus
* match response.body == '#notnull'
* call read('classpath:examples/Polling/Polling.feature') 

Examples:
|domain    |basepath         |contentType        |internalGatewayResponse    |externalGatewayResponse    |path    |
|'aircraft'|'testContentType'|'application/x-www-form-urlencoded'  |200         			   |200                         |'test-4' |

@parellel=false @contentTypewithAuth
Scenario Outline: Content-Type application/octet-stream for athenticated API
* def basepath = authbasepath
* def domain = <domain>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def version = 'v1112'
* def contentType = <contentType>

Given url externalGateway
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And multipart field myFile = read('Akamai.pdf')
And multipart field message = 'Akamai Doc'
And header Content-Type = contentType
And header Authorization = accessTokenforProd
* retry until responseStatus == internalGatewayResponse
When method post
Then status 200
* print ' response code from random External Gateway: ' , responseStatus
* match response.body == '#notnull'
* call read('classpath:examples/Polling/Polling.feature') 
   

Given url externalGateway
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And multipart field myFile = read('Akamai.pdf')
And multipart field message = 'Akamai Doc'
And header Content-Type = contentType
And header Authorization = accessTokenforProd
* retry until responseStatus == internalGatewayResponse
When method post
Then status 200
* print ' response code from random External Gateway: ' , responseStatus
* match response.body == '#notnull'
* call read('classpath:examples/Polling/Polling.feature') 

Examples:
|domain    |basepath         |contentType                 |internalGatewayResponse    |externalGatewayResponse    |path    |
|'aircraft'|'testContentType'|'application/octet-stream'  |200         			   |200                           |'test-8' |

@parellel=false @contentTypewithAuth
Scenario Outline: Content-Type application/pdf for athenticated API
* def basepath = authbasepath
* def domain = <domain>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def version = 'v1112'
* def contentType = <contentType>

Given url externalGateway
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And header Authorization = accessTokenforProd
And multipart file myFile = { read: 'Akamai.pdf', filename: 'Akamai.pdf', contentType: 'application/pdf' }
And multipart field message = 'hello world'
* retry until responseStatus == internalGatewayResponse
When method post
Then status 200


Examples:
|domain    |basepath         |contentType                 |internalGatewayResponse    |externalGatewayResponse    |path    |
|'aircraft'|'testContentType'|'application/pdf'  |200         			   |200                           |'test-8' |


@parellel=false @contentTypewithAuth
Scenario Outline: Content-Type application/zip for athenticated API
* def basepath = authbasepath
* def domain = <domain>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def version = 'v1112'
* def contentType = <contentType>

Given url externalGateway
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And header Authorization = accessTokenforProd
And multipart file myFile = { read: 'plans.zip', filename: 'plans.zip', contentType: contentType }
And multipart field message = 'hello world'
* retry until responseStatus == internalGatewayResponse
When method post
Then status 200

Examples:
|domain    |basepath         |contentType                 |internalGatewayResponse    |externalGatewayResponse    |path    |
|'aircraft'|'testContentType'|'application/zip'  |200         			   |200                           |'test-14' |

@parellel=false @contentTypewithAuth
Scenario Outline: large payload

* def basepath = authbasepath
* def domain = <domain>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def version = 'v1112'
* def contentType = <contentType>

Given url externalGateway
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And header Authorization = accessTokenforProd
And multipart file myFile = { read: 'plans.zip', filename: 'plans.zip', contentType: contentType }
And multipart field message = 'hello world'
* retry until responseStatus == internalGatewayResponse
When method post
Then status 200

Examples:
|domain    |basepath         |contentType                 |internalGatewayResponse    |externalGatewayResponse    |path    |
|'aircraft'|'testContentType'|'application/zip'  |200         			   |200                           |'test-14' |




@parellel=false @urlencoded
Scenario Outline: Content Type as application/x-www-form-urlencoded invalid body
* def basepath = <basepath>
* def domain = <domain>
* def internalGatewayResponse = <internalGatewayResponse>
* def externalGatewayResponse = <externalGatewayResponse>
* def path = <path>
* def version = 'v1111'
* def contentType = <contentType>

* call read('classpath:examples/Polling/Polling.feature')

# External Gateway
Given url gatewayNGINX
* configure retry = { count: 7, interval: 5000 }
And path domain + '/' + basepath + '/' +  version + '/' + path
And header Content-Type = contentType
And header Host = 'api-test.random.com'
* request read('screenshot.png')
* retry until responseStatus == externalGatewayResponse
When method post
Then status 400

Examples:
|domain    |basepath         |contentType                          |internalGatewayResponse    |externalGatewayResponse    |path    |
|'aircraft'|'testContentType'|'application/x-www-form-urlencoded'  |400         			   |400                        |'test-4' |

