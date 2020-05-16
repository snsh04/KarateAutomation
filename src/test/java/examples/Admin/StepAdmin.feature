Feature: This feature tests the Admin and it's functionality

Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }
* configure retry = { count: 5, interval: 5000 }

#----------------------**** ADMIN ****----------------------------------#
@StepAdmin @All @parallel=false @randomAdmin @invalid
Scenario Outline: APIAdmin-Invalid swagger and config settings    

Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = apiGatewayKey
And header apigateway-basepath = 'lambdaTest'
And request read('<inputRequest>.json')	
When method post
Then status <responseCode>
 
Examples:
|inputRequest            |responseCode|
|Swagger-missing-config  |400         |
|Swagger-missing-swagger |400         |
|Swagger-invalid-config	 |400         |
|Swagger-invalid-swagger |400         |

#-------------------------------------------------------------------------#

 @All @parallel=false @randomAdmin @StepAdmin @ss
Scenario: validation of large swagger files
Given url Admin
* json myReq = read('large-swagger-config.json')
* def name = '1-' + now()
* set myReq.swagger.info.title = 'Regtest_Large' + name
* def basepath = 'countrylargeAdmin' + name
* set myReq.swagger.basePath = basepath
And request myReq
When method post
* retry until responseStatus == 200
* call read('classpath:examples/Polling/PollingStepFunction.feature')
* def title = 'Regtest_Large'
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
* call read('classpath:examples/Polling/Polling.feature')
#-------------------------------------------------------------------------#

@StepAdmin @All @parallel=false @Properties @addition
Scenario Outline: Add additional properties - valid
Given url Admin
* json myReq = read('Swagger-AdditionalProps.json')
* def name = '1-' + now()
* def title = 'Regtest_AdditionalProps' + name
* set myReq.swagger.info.title = title
* def basepath = 'countryAdditionalProps' + name
* set myReq.swagger.basePath = basepath
* json additionalProperties = <additionalProperties>
* set myReq.apiConf.additionalProperties = additionalProperties
And request myReq
When method post
* retry until responseStatus == 200 
* call read('classpath:examples/Polling/PollingStepFunction.feature')
* def Key = <Key>
* def Value = <Value>
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': '#(title)' }
* match DefFromPub.response.additionalProperties == additionalProperties

* def DefFromStore = call read('classpath:examples/Services/GetAPIIDFromStoreUsingProperties.feature') {'Key': '#(Key)' ,'Value': '#(Value)'  }
* def APIIDStore = DefFromStore.response.id

#* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDStore)'  }
#* call read('classpath:examples/Polling/Polling.feature') 

Examples:
|additionalProperties                           |Key                       |Value                   |
|{'Tester':'Test'}                              |'Tester'                  |'Test'                  |
|{'sneha_shukla':'sneha'}                       |'sneha_shukla'            |'sneha'                 |
|{'Test33':'Test33'}                            |'Test33'                  |'Test33'                | 
|{'1':'Test67'}                                 |'1'                       |'Test67'                |
|{'sneha-1':'sneha-2'}                          |'sneha-1'                 |'sneha-2'               |
|{'SNEHA-1':'sneha'}                            |'SNEHA-1'                 |'sneha'                 |
|{'Sneha@random.com':'shukla@random.com'} |'Sneha@random.com'     |'shukla@random.com'  |


 #-----------------------------------------------------------------------------#
 
@StepAdmin @All @parallel=false @Properties
Scenario Outline: Add additional properties - invalid
Given url Admin
* json myReq = read('Swagger-AdditionalProps.json')
* def name = '1-' + now()
* def title = 'Regtest_AdditionalPropsinvalid' + name
* set myReq.swagger.info.title = title
* def basepath = 'countryAdditionalProps' + name
* set myReq.swagger.basePath = basepath
* json additionalProperties = <additionalProperties>
* set myReq.apiConf.additionalProperties = additionalProperties
And request myReq
When method post
* retry until responseStatus == 400 

 

Examples:
|additionalProperties       |
|{'~!@#$%^&*()_+':'@@@@@'}  |
|{' ':' '}                  |
|{'':''}                    |
|{'_':'_'}                  |

 #-----------------------------------------------------------------------------#
 
 
@StepAdmin @All @parallel=false @customheader
Scenario Outline: Add custom header  - valid
Given url Admin
* json myReq = read('Swagger-customProps.json')
* def name = '1-' + now()
* def title = 'Regtest_CustomProps' + name
* set myReq.swagger.info.title = title
* def basepath = <basepath> + name
* set myReq.swagger.basePath = basepath
* text customAuthorizationHeader = 
"""
<customAuthorizationHeader>
"""
* set myReq.apiConf.customAuthorizationHeader = <customProps>
And request myReq
When method post
* retry until responseStatus == 200 
* call read('classpath:examples/Polling/PollingStepFunction.feature')
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': '#(title)' }
* match DefFromPub.response thorizationHeader == customAuthorizationHeader
* def APIIDPub = DefFromPub.response.id

* call read('classpath:examples/Polling/Polling.feature')  
# get API ID from store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr

# Create application
* def applicationDetails = call read('classpath:examples/Services/CreateApplicationFromStore.feature') 
* def applicationID = applicationDetails.response.applicationId

# Generate keys
* def applicationKeyDetailsProd = call read('classpath:examples/Services/GenerateProductionApplicationkeysFromStore.feature') {'applicationID' : '#(applicationID)' }
* def accessTokenforProd = 'Bearer '+ applicationKeyDetailsProd.response.token.accessToken

# Subscribe
* def subscriptionDetails = call read('classpath:examples/Services/SubscribeUsingApplicationFromStore.feature') {'APIIDStr': '#(APIIDStr)' , 'applicationID': '#(applicationID)' }
* def subscriptionId = subscriptionDetails.response.subscriptionId


#Invoke API through NGINX External Gateway using authorization header
* configure retry = { count: 7, interval: 5000 }
Given url gatewayNGINX
And path 'test' + '/' + basepath + '/' +  'v1/test-2'
And header <customAuthorizationHeader> = accessTokenforProd
* request '<test>test</test>'
* retry until responseStatus == <responseCode>
When method post
* print ' response code from random NGINX Internal Gateway: ' , responseStatus

* call read('classpath:examples/Services/DeleteApplication.feature')  {'applicationID': '#(applicationID)'  }
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }


Examples:
|customAuthorizationHeader                                         |basepath        |customProps|responseCode |
|Sneha                                                             |'customProp1'   |'Sneha'|200|
|_---                                                              |'customProp2'   |'_---'|200|
|___________________________                                       |'customProp3'   |'___________________________'|200| 
|-------------------------------------------                       |'customProp4'   |'-------------------------------------------'|200|
|WWW-Authenticate                                                  |'customProp6'   |'WWW-Authenticate'|200|
|password                                                          |'customProp7'   |'password'|200|
|aWAqMchjzCpAOcUcIGi-sermwqNlBI                                    |'customProp9'   |'aWAqMchjzCpAOcUcIGi-sermwqNlBI'|200|
|123456788                                                         |'customProp10'   |'123456788'|200|
|oauth20                                                           |'customProp11'   |'oauth20'|200|
|ssn--sneha                                                        |'customProp12'   |'ssn--sneha'|200|
|ccsdcskjvsvbsvbsvsvsvds1234567890ccsdcskjvsvbsvbsvsvsdddddd12344  |'customProp13'   |'ccsdcskjvsvbsvbsvsvsvds1234567890ccsdcskjvsvbsvbsvsvsdddddd12344'|200|
|ccsdcskjvsvbsvbsvsvsvds1234567890ccsdcskjvsvbsvbsvsvsdddddd12344r |'customProp14'   |'ccsdcskjvsvbsvbsvsvsvds1234567890ccsdcskjvsvbsvbsvsvsdddddd12344r'|200|
|_                                                                 |'customProp15'   |'_'|200|
|-                                                                 |'customProp16'   |'-'|200|




 #-----------------------------------------------------------------------------#
 
@StepAdmin @All @parallel=false @customheader
Scenario Outline: Add custom header  - invalid
Given url Admin
* json myReq = read('Swagger-customProps.json')
* def name = '1-' + now()
* def title = 'Regtest_CustomPropsinvalid' + name
* set myReq.swagger.info.title = title
* def basepath = <basepath> + name
* set myReq.swagger.basePath = basepath
* def customProperties = <customProperties>
* set myReq.apiConf.customAuthorizationHeader = customProperties
And request myReq
When method post
* retry until responseStatus == 400 

 

Examples:
|customProperties       |basepath |
|'gDychJewVvIPFYWzoTvCaHuDQqFJIKQ__oKdxHukMr_NOwNudByFLNNiJ-MlFDbfWpVGhggDychJewVvIPFYWzoTvCaHuDQqFJIKQ__oKdxHukMr_NOwNudByFLNNiJ-MlFDbfWpVGhggDychJewVvIPFYWzoTvCaHuDQqFJIKQ__oKdxHukMr_NOwNudByFLNNiJ-MlFDbfWpVGhggDychJewVvIPFYWzoTvCaHuDQqFJIKQ__oKdxHukMr_NOwNudByFLNNiJ-MlFDbfWpVGhg'  |'customProp17'|
|'aaaaaaaaaaaaaaaa,bbbbbbbbbbbbb'                  |'customProp18'|
|'sneha@random.com'                    |'customProp19'|
|'A~1~!@#$%^&**(()__+)P{L>>>L:"?M<>?L<>:L<KL>PIJ"'                  |'customProp20'|
|'sneha.antas.com'                                               |'customProp21'   |
|'*'                                                                 |'customProp22'   |
|''                                                                 |'customProp24'   |
|' '                                                                 |'customProp24'   |

# ------------------------------------------------------------------------------- # 

@StepAdmin @All @parallel=false @randomAdmin @Check
Scenario: Swagger validation of presence of tags

Given url Admin
* json myReq = read('Swagger-Admin.json')
* def name = '1-' + now()
* call read('classpath:examples/Polling/Polling.feature') 
* def title = 'Regtest_tagers' + name
* set myReq.swagger.info.title = title
* set myReq.apiConf.domain = 'car'
* match myReq.swagger.info.description == '#present'
* match myReq.swagger.info.description == '#notnull'
* match myReq.swagger.info.version == '#present'
* match myReq.swagger.info.version == '#notnull'
#* match myReq.apiConf.domain == 'banana'
* match myReq.apiConf.includeVersion == '#present'
* match myReq.apiConf.includeVersion == '#notnull'
* def validDomains = { domain: ['customer', 'employee', 'product', 'booking', 'flight', 'aircraft', 'notification', 'freight', 'checkin', 'loyalty', 'event', 'partner', 'entertainment'] }
#* match myReq.apiConf.domain contains validDomains.domain 
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
* print 'my request is ', myReq	
* request myReq 
When method post
Then status 200

* retry until responseStatus == 200 
* call read('classpath:examples/Polling/PollingStepFunction.feature')

* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
* call read('classpath:examples/Polling/Polling.feature') 
#-------------------------------------------------------------------------#

@StepAdmin @All @parallel=false @randomAdmin 
Scenario Outline: Positive Swagger validation of tags

Given url Admin
* json myReq = read('Swagger-Admin.json')
* def name = '2-' + now()
* def title = <title> + name
* def basepath = <basepath> + name 
* set myReq.swagger.info.title = title
* set myReq.swagger.info.description = <description>
* set myReq.apiConf.domain = <domain>
* set myReq.apiConf.lambda = <lambda>
* set myReq.swagger.basePath = basepath
* set myReq.swagger.info.contact.name = <contactName>
* set myReq.swagger.info.contact.email = <contactEmail>
* set myReq.swagger.info.x-businessOwner.name = <businessOwnerName>
* set myReq.swagger.info.x-businessOwner.email = <businessOwnerEmail>
* set myReq.swagger.info.x-technicalOwner.name = <technicalOwnerName>
* set myReq.swagger.info.x-technicalOwner.email = <technicalOwnerEmail>
* set myReq.swagger.info.version = <version>
* set myReq.apiConf.includeVersion = <IncludeVersion>
And request myReq
When method post
* retry until responseStatus == <responseCode> 

* call read('classpath:examples/Polling/Polling.feature') 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
* call read('classpath:examples/Polling/Polling.feature') 
Examples:
|success|responseCode|title                  |basepath         |description |domain             |contactName|contactEmail              |businessOwnerName    |businessOwnerEmail         |technicalOwnerName     |technicalOwnerEmail       |version|IncludeVersion|lambda|
|true   |200         |'Regtest_Validate2'    |'countryAdmin2'  |'my API'    |'customer'         |'contactme'|'contactme@random.com' |'regtest'            |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |'v51'   |true        |true  |
|true   |200         |'Regtest_Validate3'    |'countryAdmin3'  |'my API'    |'partner'          |'contactme'|'contactme@random.com' |'regtest'            |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |'v52'   |true        |true  |
|true   |200         |'Regtest_Validate5'    |'countryAdmin5'  |'my API'    |'employee'         |'contactme'|'contactme@random.com' |'regtest'            |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |'v54'   |true        |true  |
|true   |200         |'Regtest_Validate8'    |'countryAdmin8'  |'my API'    |'notification'     |''         |'contactme@random.com' |'regtest'            |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |'v57'   |true        |true  |
|true   |200         |'Regtest_Validate9'    |'countryAdmin9'  |'my API'    |'freight'          |'contactme'|''                        |'regtest'            |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |'v58'   |true        |true  |
|true   |200         |'Regtest_Validate12'   |'countryAdmin12' |'my API'    |'event'            |''         |''                        |'regtest'            |'regtest@randomloyalty.com'|'techOwner'            |'techOwner@random.com' |'v61'   |true        |true  |
|true   |200         |'Regtest_Validate13'   |'countryAdmin13' |'my API'    |'entertainment'    |''         |''                        |'regtest'            |'regtest@jetstar.com'      |'techOwner'            |'techOwner@random.com' |'v62'   |true        |true  |
|true   |200         |'Regtest_Validate20'   |'countryAdmin20' |'my API'    |'notification'     |'contactme'|'contactme@random.com' |'regtest'            |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |'V68'   |true       |true  |
|true   |200         |'Regtest_Validate21'   |'countryAdmin21' |'my API'    |'customer'         |'contactme'|'contactme@random.com' |'regtest'            |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |'v69'   |true       |true  |
|true   |200         |'Regtest_Validate23'   |'countryAdmin23' |'my API'    |'car'              |'contactme'|'contactme@random.com' |'regtest'            |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |'v51'   |true        |true  |
|true   |200         |'Regtest_Validate24'   |'countryAdmin24' |'my API'    |'Car'              |'contactme'|'contactme@random.com' |'regtest'            |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |'v51'   |true        |true  |
|true   |200         |'Regtest_Validate25'   |'countryAdmin25' |'my API'    |'business'         |'contactme'|'contactme@random.com' |'regtest'            |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |'v51'   |true        |true  |
|true   |200         |'Regtest_Validate26'   |'countryAdmin26' |'my API'    |'pricing'          |'contactme'|'contactme@random.com' |'regtest'            |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |'v51'   |true        |true  |

#-------------------------------------------------------------------------#
@StepAdmin @All @parallel=false @randomAdmin 
Scenario Outline: Negative Swagger validation of tags
Given url Admin
And request read('Swagger-Admin.json')
* json myReq = read('Swagger-Admin.json')
* def name = '3-' + now()
* def title = <title> + name
* def basepath = <basepath> + name 
* set myReq.swagger.info.title = title
* set myReq.swagger.info.description = <description>
* set myReq.apiConf.domain = <domain>
* set myReq.apiConf.lambda = <lambda>
* set myReq.swagger.basePath = basepath
* set myReq.swagger.info.contact.name = <contactName>
* set myReq.swagger.info.contact.email = <contactEmail>
* set myReq.swagger.info.x-businessOwner.name = <businessOwnerName>
* set myReq.swagger.info.x-businessOwner.email = <businessOwnerEmail>
* set myReq.swagger.info.x-technicalOwner.name = <technicalOwnerName>
* set myReq.swagger.info.x-technicalOwner.email = <technicalOwnerEmail>
* set myReq.swagger.info.version = <version>
* set myReq.apiConf.includeVersion = <IncludeVersion>
And request myReq
When method post
Then status <responseCode>
* call read('classpath:examples/Polling/Polling.feature') 



Examples:
|success|responseCode|title                  |basepath         |description |domain             |contactName|contactEmail              |businessOwnerName    |businessOwnerEmail         |technicalOwnerName     |technicalOwnerEmail       |version |IncludeVersion|lambda|
|false  |400         |'Regtest_Validate(1)'  |'countryAdmin1'  |'my API'    |'test'             |'contactme'|'contactme@random.com' |'regtest'            |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |'v50'   |true        |true  |
|false  |400         |'Regtest_Validate6'    |'countryAdmin6'  |''          |'product'          |'contactme'|'contactme@random.com' |'regtest'            |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |'v55'   |true        |true  |
|false  |400         |'Regtest_Validate7'    |'countryAdmin7'  |'my API'    |'rubbish'          |'contactme'|'contactme@random.com' |'regtest'            |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |'v56'   |true        |true  |
|false  |400         |'Regtest_Validate10'   |'countryAdmin10' |'my API'    |'checkin'          |''         |''                        |''                   |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |'v59'   |true        |true  |
|false  |400         |'Regtest_Validate11'   |'countryAdmin11' |'my API'    |'loyalty'          |''         |''                        |'regtest'            |''                         |'techOwner'            |'techOwner@random.com' |'v60'   |true        |true  |
|false  |400         |'Regtest_Validate14'   |'countryAdmin14' |'my API'    |'virtualassistant' |''         |''                        |'regtest'            |'regtest@xyz.com'          |'techOwner'            |'techOwner@random.com' |'v63'   |true        |true  |
|false  |400         |'Regtest_Validate15'   |'countryAdmin15' |'my API'    |'test'             |'contactme'|'contactme@random.com' |'regtest'            |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |''      |true        |true  |
|false  |400         |'Regtest_Validate18'   |'countryAdmin18' |'my API'    |'employee'         |'contactme'|'contactme@random.com' |'regtest'            |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |'VV66'  |true        |true  |
|false  |400         |'Regtest_Validate19'   |'countryAdmin19' |'my API'    |'product'          |'contactme'|'contactme@random.com' |'regtest'            |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |'vv67'  |true        |true  |
|false  |400         |'Regtest_Validate16'   |'countryAdmin16' |'my API'    |'partner'          |'contactme'|'contactme@random.com' |'regtest'            |'regtest@random.com'    |''                     |'techOwner@random.com' |'v64'   |true        |true  |
|false  |400         |'Regtest_Validate17'   |'countryAdmin17' |'my API'    |'aircraft'         |'contactme'|'contactme@random.com' |'regtest'            |'regtest@random.com'    |'techOwner'            |''                        |'v65'   |true        |true  |
|false  |400         |'Regtest_Validate22'   | 'countryAdmin22'|'my API'    |'Flight'           |'contactme'|'contactme@random.com' |'regtest'            |'regtest@random.com'    |'techOwner'            |'techOwner@random.com' |'v70'   |null        |false |


#-------------------------------------------------------------------------#

@All @StepAdmin @parallel=false @randomAdmin 
Scenario Outline: Register API and validate the subscriptionTiers

Given url Admin
* json myReq = read('Swagger-Admin.json')
* set myReq.apiConf.subscriptionTiers = <subscriptionTiers>
* def name = '4-' + now()
* def title = <title> + name
* def basepath = <basepath> + name 
* set myReq.swagger.info.title = title
* set myReq.swagger.info.version = <version>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = basepath
* print 'my subscriptions : ', myReq.apiConf
And request myReq 
When method post
* retry until responseStatus == <responseCode> 
* call read('classpath:examples/Polling/PollingStepFunction.feature')

* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': '#(title)'  }
* match DefFromPub.response.tiers == <subscriptionTiers> 
* def APIIDPub = DefFromPub.APIIDPub
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
* call read('classpath:examples/Polling/Polling.feature') 

Examples:
|version|title           |domain    |basepath        | subscriptionTiers 					    											|responseCode|
|'v80'  |'Regtest_Tier0' |'test'    |'countryAdmin2T'| [Bronze,Gold,Silver,Unlimited]	    												|200         |
|'v81'  |'Regtest_Tier2' |'product' |'countryAdmin24'| [Bronze,Gold,Unlimited]   			   												|200         |
|'v82'  |'Regtest_Tier3' |'customer'|'countryAdmin25'| [Gold]        						   												|200         |
|'v83'  |'Regtest_Tier4' |'flight'  |'countryAdmin26'| [Unlimited,Gold_Auto-Approved,Bronze_Auto-Approved]   								|200         |
|'v84'  |'Regtest_Tier5' |'aircraft'|'countryAdmin27'| [Silver_Auto-Approved,Gold_Auto-Approved,Bronze_Auto-Approved]   			        |200         |
|'v85'  |'Regtest_Tier6' |'event'   |'countryAdmin28'| [Bronze,Gold,Silver_Auto-Approved,Unlimited,Gold_Auto-Approved,Bronze_Auto-Approved] |200         |

#-------------------------------------------------------------------------#
@StepAdmin @All @parallel=false @randomAdmin 
Scenario Outline: Invalid Subcription Tiers
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = apiGatewayKey
And header apigateway-basepath = 'lambdaTest'
* json myReq = read('Swagger-Admin.json')
* set myReq.apiConf.subscriptionTiers = <subscriptionTiers>
* print 'my subscriptions : ', myReq.apiConf
And request myReq 
When method post
Then status <responseCode>

Examples:
| subscriptionTiers 					|responseCode|
| [gold,Bronze_Auto-Approved]    	    |400         |
| [Gold,Bronze-Auto-Approved]     	    |400         |
| [Gold,BronzeAuto-Approved]      		|400         |
| [Gold,Bronze_AutoApproved]    		|400         |
| [Gold,Bronze_Approved]        		|400         |

#-------------------------------------------------------------------------#

@StepAdmin @parallel=false @title @randomAdmin 
Scenario Outline: APIAdmin-Validation of WSO2 specific API title name rules
Given url Admin
* json myReq = read('Swagger-invalid-config.json')
* def name = '5-' + now()
#* def title = <title> + name
* def basepath = <basepath> + name 
* set myReq.swagger.info.title = <title>
* set myReq.swagger.info.version = <version>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = basepath
And request myReq 
When method post
* retry until responseStatus == <responseCode> 
* def titlinPublisher = <titlinPublisher>
* call read('classpath:examples/Polling/Polling.feature') 
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(titlinPublisher)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
Given  url authURL 
And  header Authorization = Authorization 
And  form field grant_type = 'client_credentials' 
And  form field scope = 'apim:api_view' 
When  method post 
Then  status 200 
* def accessToken = 'Bearer ' + response.access_token 
* print 'AccessToken is ' , accessToken 

* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:
|version|domain    |basepath        |title                   |responseCode| titlinPublisher   |
|'v90'  |'test'    |'countryAdminT1'|'DA Pineapple'          |200         |'DA_Pineapple'		   |
|'v91'  |'partner' |'countryAdminT2'|'DA API Pineapple'      |200         |'DA_API_Pineapple'    | 
|'v92'  |'event'   |'countryAdminT3'|'DA pineapple cat API'  |200         |'DA_pineapple_cat'|
|'v94'  |'customer'|'countryAdminT5'|'DAPI domain'           |200         |'DAPI_domain'    |
|'v95'  |'flight'  |'countryAdminT6'|' DDA API domain '      |200         |'DA_API_domain'   |
|'v97'  |'aircraft'|'countryAdminT7'|'AA api'                |200         |'AA'          |

#-------------------------------------------------------------------------#

@StepAdmin @All @parallel=false @randomAdmin 
Scenario Outline: APIAdmin-Default Version mapping
Given url Admin
* json myReq = read('Swagger-Admin.json')
* def name = '6-' + now()
* def title = <title> + name
* def basepath = <basepath> + name 
* set myReq.swagger.info.title = title
* set myReq.swagger.info.version = <version>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = basepath
* set myReq.apiConf.defaultVersion = <defaultVersion>
And request myReq 
When method post
* retry until responseStatus == <responseCode> 

* call read('classpath:examples/Polling/PollingStepFunction.feature')
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }


Examples:
|title             |basepath         |domain    |version    |defaultVersion       |responseCode|success|
|'REGTEST_DEFAULT3'|'countryAdminDD1'|'test'    |'v1'       |true                 |200         |true|
|'REGTEST_DEFAULT4'|'countryAdminDD2'|'event'   |'v2'       |false                |200         |true|
#-------------------------------------------------------------------------#
@StepAdmin @All @parallel=false @randomAdmin 
Scenario Outline: Positive APIAdmin-Validation of CORS Authorization    
Given url Admin
* json myReq = read('Swagger-Admin.json')
* def name = '7-' + now()
* def title = <title> + name
* def basepath = <basepath> + name 
* set myReq.apiConf.corsHeaders.Access-Control-Allow-Headers = <Access-Control-Allow-Headers>
* set myReq.apiConf.corsHeaders.Access-Control-Allow-Methods = <Access-Control-Allow-Methods>
* set myReq.apiConf.corsHeaders.Access-Control-Allow-Origin = <Access-Control-Allow-Origin>
* set myReq.apiConf.corsHeaders.Access-Control-Allow-Credentials = <Access-Control-Allow-Credentials>
* set myReq.swagger.info.title = title
* set myReq.swagger.info.version = <version>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = basepath
And request myReq 
When method post
* retry until responseStatus == <responseCode> 

* call read('classpath:examples/Polling/PollingStepFunction.feature')
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)' }


Examples:
|title          |basepath          |domain    |version|responseCode|success|Access-Control-Allow-Headers                                                |Access-Control-Allow-Methods|Access-Control-Allow-Origin     |Access-Control-Allow-Credentials|
|'REGTEST_CORS1'|'countryAdminB1'  |'test'    |'v101' |200         |true   |'origin, content-type, accept, x-appid, x-sessionid, x-corrid, hb'          |'GET'                       |'freight.random.com,batman.com' |true                       |
|'REGTEST_CORS2'|'countryAdminB2'  |'event'   |'v102' |200         |true   |'origin, content-type, accept, x-appid, x-sessionid, x-corrid, hb'          |'GET'                       |'freight.random.com,batman.com' |true                            |
|'REGTEST_CORS4'|'countryAdminB4'  |'customer'|'v104' |200         |true   |'origin, content-type, accept, x-appid, x-sessionid, x-corrid,authorization'|'GET'                       |'freight.random.com,batman.com' |true                          |
|'REGTEST_CORS5'|'countryAdminB5'  |'aircraft'|'v105' |200         |true   |'origin, content-type, accept, x-appid, x-sessionid, x-corrid,Authorization'|'GET'                       |'freight.random.com,batman.com' |true                          |
|'REGTEST_CORS6'|'countryAdminB6'  |'flight'  |'v106' |200         |true   |'origin, content-type, accept, x-appid, x-sessionid, x-corrid,AUTHORIZATION'|'GET'                       |'freight.random.com,batman.com' |true               			 |
|'REGTEST_CORS7'|'countryAdminB7'  |'test'    |'v107' |200         |true   |'origin, content-type, accept, x-appid, x-sessionid, x-corrid'              |''                          |'freight.random.com,batman.com' |true  						 |
|'REGTEST_CORS8'|'countryAdminB8'  |'customer'|'v108' |200         |true   |'origin, content-type, accept, x-appid, x-sessionid, x-corrid,hb'           |'GET'                       |'freight.random.com,batman.com' |true  						 |
|'REGTEST_CORS9'|'countryAdminB9'  |'partner' |'v109' |200         |true   |'origin, content-type, accept, x-appid, x-sessionid, x-corrid,hb'           |'GET'                       |'freight.random.com,apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com'         |true  |
|'REGTEST_COR00'|'countryAdminBB10'|'car'     |'v110' |200         |true   |'origin, content-type, accept, x-appid, x-sessionid, x-corrid,hb'           |'GET'                       |'freight.random.com,https://apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com' |true  |
|'REGTEST_COR11'|'countryAdminB11' |'event'   |'v111' |200         |true   |'origin, content-type, accept, x-appid, x-sessionid, x-corrid,hb'           |'GET'                       |'freight.random.com,http://apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com'  |true |


#-------------------------------------------------------------------------#
@StepAdmin @All @parallel=false @randomAdmin 
Scenario Outline: Negative APIAdmin-Validation of CORS Authorization    
Given url Admin
* json myReq = read('Swagger-Admin.json')
* set myReq.apiConf.corsHeaders.Access-Control-Allow-Headers = <Access-Control-Allow-Headers>
* set myReq.apiConf.corsHeaders.Access-Control-Allow-Methods = <Access-Control-Allow-Methods>
* set myReq.apiConf.corsHeaders.Access-Control-Allow-Origin = <Access-Control-Allow-Origin>
* set myReq.apiConf.corsHeaders.Access-Control-Allow-Credentials = <Access-Control-Allow-Credentials>
* def name = '8-' + now()
* def title = <title> + name
* def basepath = <basepath> + name 
* set myReq.swagger.info.title = title
* set myReq.swagger.info.version = <version>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = basepath
And request myReq 
When method post
* retry until responseStatus == <responseCode> 


Examples:
|title          |basepath         |domain    |version|responseCode|success|Access-Control-Allow-Headers                                                |Access-Control-Allow-Methods|Access-Control-Allow-Origin     |Access-Control-Allow-Credentials|
|'REGTEST_CORS3'|'countryAdminB13'|'partner' |'v103' |200         |false  |'origin, content-type, accept, x-appid, x-sessionid, x-corrid, hb'          |'GET'                       |''                              |null                            |

#-------------------------------------------------------------------------#

@StepAdmin @All @parallel=false @randomAdmin 
Scenario Outline:APIAdmin-API status mapping
Given url Admin
* json myReq = read('Swagger-Admin.json')
* set myReq.apiConf.publish = <publish>
* def name = '9-' + now()
* def title = <title> + name
* def basepath = <basepath> + name 
* set myReq.swagger.info.title = title
* set myReq.swagger.info.version = <version>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = basepath
And request myReq
When method post
* retry until responseStatus == <responseCode> 
* call read('classpath:examples/Polling/Polling.feature') 
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': '#(title)'  }
* print ' response status ', DefFromPub.response.status
* match DefFromPub.response.status == <statusfromPublisher> 
* def APIIDPub = DefFromPub.APIIDPub
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }


Examples:
|version|domain   |basepath         |title            |responseCode|publish|version|statusfromPublisher|success|
|'v200' |'car'    |'countryAdminSS1'|'REGTEST_STATS11'|200         |true   |'v1'   |'PUBLISHED'        |true|
#|'v201' |'test'   |'countryAdminSS2'|'REGTEST_STATS22'|200         |false  |'v2'   |'CREATED'          |true|
|'v202' |'partner'|'countryAdminSS3'|'REGTEST_STATS33'|200         |true   |'v2'   |'PUBLISHED'        |true|

#-------------------------------------------------------------------------#

@StepAdmin @All @parallel=false @randomAdmin 
Scenario Outline: endpoint security
Given url <url>
And request read('Swagger-Admin.json')
When method <method>
Then status <responseCode>

Examples:

|url                                                                                      |method   |responseCode|
|'https://apiadmin.dev.dev.a878-06.ams10.nonp.cloud.random.com'                       |get      |401         |
|'https://apiadmin.dev.dev.a878-06.ams10.nonp.cloud.random.com/admin'                 |get      |401         |  
|'https://apiadmin.dev.dev.a878-06.ams10.nonp.cloud.random.com/admin/apiKeys'         |get      |401         |
|'https://apiadmin.dev.dev.a878-06.ams10.nonp.cloud.random.com/admin/apikey'          |post     |401         |
|'https://apiadmin.dev.dev.a878-06.ams10.nonp.cloud.random.com/admin/apikey'          |delete   |401         |
#|'https://apiadmin.dev.dev.a878-06.ams10.nonp.cloud.random.com/admin/register'        |get      |401         | 
|'https://apiadmin.dev.dev.a878-06.ams10.nonp.cloud.random.com/admin/register'        |post     |401         |
#|'https://apiadmin.dev.dev.a878-06.ams10.nonp.cloud.random.com/admin/gateway/v1/api'  |post     |401         |
|'https://apiadmin.dev.dev.a878-06.ams10.nonp.cloud.random.com/admin/healthcheck'     |get      |200         |
|'https://apiadmin.dev.dev.a878-06.ams10.nonp.cloud.random.com/admin/wso2/logApiStats'|get      |200         |
|'https://apiadmin.dev.dev.a878-06.ams10.nonp.cloud.random.com/backup/apikeys'        |get      |401         |
|'https://apiadmin.dev.dev.a878-06.ams10.nonp.cloud.random.com/restore/apikeys'       |post     |401         |         

@StepAdmin @All @parallel=false @randomAdmin 
Scenario Outline: Access Control
Given url Admin
* json myReq = read('Swagger-Admin.json')
* set myReq.apiConf.publisherAccessControlRoles = <Roles>
* def name = '10-' + now()
* def title = <title> + name
* def basepath = <basepath> + name 
* set myReq.swagger.info.title = title
* set myReq.swagger.basePath = basepath
And request myReq
When method post
* retry until responseStatus == <responseCode> 
* call read('classpath:examples/Polling/Polling.feature') 
#Get view token
Given url authURL
And header Authorization = Authorization 
And form field grant_type = 'client_credentials' 
And form field scope = 'apim:api_view'
When method post
* def viewToken = 'Bearer ' + response.access_token
* print 'viewToken is ', viewToken

* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
#* call read('Sleep.feature')
* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:
|title             |Roles                      | responseCode           |Username      |Password   |basepath         |       
#|'REGTEST_ACCESS1'|[DevTeamAlpha]             |200                     |'reg_tests'   |'admin'    |'countryAccess1' |          
|'REGTEST_ACCESS2'|[DevTeamAlpha,DevTeamBeta]  |200                     |'reg_tests'   |'cCCVCVCVCVCV'    |'countryAccess2' |       
#|'REGTEST_ACCESS3'|[DevTeamAlpha,DevTeam]     |500                     |'regtest_customer'     |'admin'    |'countryAccess3' |    

 @parallel=false @ADGroup @StepAdmin @All @randomAdmin 
Scenario Outline: AD groups via Admin Service for pipeline
Given url <url>
And path <path>
And header Authorization = pipelineAD
And request 'test'
When method <method>
Then status <responseCode>

Examples:
|url                                                               |path             |method   |responseCode|
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'admin/apikeys'  |get      |401         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'admin/apikey'  |post      |401         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'admin/apikey'  |delete      |401         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'admin/register'  |get      |401         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'admin/register'  |post      |401         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'admin/backup/apikeys'  |get      |401         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'admin/backup/apikeys'  |get      |401         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'gateway/v1/groups'  |get      |401         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'gateway/v1/api'  |post      |400         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'admin/wso2/logApiStats'  |get      |200         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'admin/healthcheck'  |get      |200         |

 @parallel=false @ADGroup @StepAdmin @All @randomAdmin 
Scenario Outline: AD groups via Admin Service for Admin
Given url <url>
And path <path>
And header Authorization = adminAD
And request 'test'
When method <method>
Then status <responseCode>

Examples:
|url                                                               |path             |method   |responseCode|
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'admin/apikeys'  |get      |200         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'admin/apikey'  |post      |200         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'admin/apikey'  |delete      |200         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'admin/register'  |get      |200         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'admin/register'  |post      |200         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'admin/backup/apikeys'  |get      |401         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'gateway/v1/groups'  |get      |200         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'gateway/v1/api'  |post      |400         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'admin/wso2/logApiStats'  |get      |200         |
|'https://apiadmin-dev-dev-a878-06-ams10-nonp.cloud.random.com'|'admin/healthcheck'  |get      |200         |

@parallel=false @All @description
Scenario: large descriptions via pipeline
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = apiGatewayKey
And header apigateway-basepath = 'lambdaTest'
And request read('Swagger-largeDescription.json')	
When method post

* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'REGTEST_LARGEDESCRIPTION'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

@parallel=false  @All @description
Scenario: large description via Admin
Given url Admin
* json myReq = read('Swagger-largeDescription.json')
And request myReq
When method post

* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'REGTEST_LARGEDESCRIPTION'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub

* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }



@parallel=false @SpubA
Scenario Outline: Store Access Control
## User 1 - user@random.com is part of DevTeamAlpha
## User 2 - user2@random.com is part of DevTeamBeta
Given url Admin
* json myReq = read('Swagger-Admin.json')
* set myReq.apiConf.publisherAccessControlRoles = <pubRoles>
* set myReq.apiConf.apistoreAccessControlRoles = <storeRoles>
* def name = '10-' + now()
* def title = 'Regtest_Access1' + name
* def basepath = 'countryAccess1' + name
* set myReq.swagger.info.title = title
* set myReq.swagger.basePath = basepath
And request myReq
When method post
* retry until responseStatus == 200
* call read('classpath:examples/Polling/Polling.feature') 

# get view token with SSO user  
Given   url authURL 
And   header Authorization = <UserAuthorization> 
And   form field grant_type = 'client_credentials' 
And   form field scope = 'apim:api_view' 
When   method post 
Then   status 200 
* def viewAccessTokenUser = 'Bearer ' + response.access_token 
* print 'viewAccessToken is ' , viewAccessTokenUser


* call read('classpath:examples/Polling/Polling.feature') 
* call read('classpath:examples/Polling/Polling.feature') 

## View API using User in publisher
Given  url PublisherURL + '?' 
And  param query = 'name:' + title
* header Authorization = viewAccessTokenUser
When method get 
* def responseCode = 200
* match response.list[0].id ==  <pubResponse>

## View API using User in Store
Given url storeURL
And param query = 'name:' + title
And  header Authorization = viewAccessTokenUser
When method get 
* def APIIDStr = response.list[0].id 
* def responseCode = 200
* match response.list[0].id ==  <storeResponse>


* call read('classpath:examples/Polling/Polling.feature') 
#* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:
|pubRoles                   |storeRoles          |pubResponse        |storeResponse    |UserAuthorization |   
|[DevTeamAlpha]             |[DevTeamBeta]       |'#notnull'         |'#null'       |Authorization_APIGWUATSSO  |           
|[DevTeamAlpha]             |[DevTeamBeta]       |'#null'            |'#nonull'          |'Authorization_APIGWPRODSSO'|
|[DevTeamAlpha]             |[DevTeamBeta]       |'#notnull'          |'#notnull'      | |        
#|[DevTeamAlpha]             |[DevTeamBeta]       |'#notnull'         |'#null'          |  |           


@parallel=false 
Scenario Outline: Store Access Control blank data
Given url Admin
* json myReq = read('Swagger-Admin.json')
* set myReq.apiConf.publisherAccessControlRoles = <pubRoles>
* set myReq.apiConf.apistoreAccessControlRoles = <storeRoles>
#* def name = '10-' + now()
* def title = 'Regtest_Access2' 
* def basepath = 'countryAccess2'
* set myReq.swagger.info.title = title
* set myReq.swagger.basePath = basepath
And request myReq
When method post
Then status 200
And match response.success == false


Examples:
|pubRoles         |storeRoles      |expectedResponse|      
|[]               |[]              |"Please ensure that the publisherAccessControlRoles property does not contain any empty strings"              |
|[""]             |[""]            |"Please ensure that the publisherAccessControlRoles property does not contain any empty strings"              |
|["notValid"]     |["DevTeamBeta"] |"Error Invalid user roles found in accessControlRole list"              |
|["DevTeamAlpha"] |["notValid"]    |"Error Invalid user roles found in accessControlRole list"              |

@parallel=false
Scenario Outline: Store Access Control multiple roles
Given url Admin
* json myReq = read('Swagger-Admin.json')
* set myReq.apiConf.publisherAccessControlRoles = <pubRoles>
* set myReq.apiConf.apistoreAccessControlRoles = <storeRoles>
* def name = '10-' + now()
* def title = 'Regtest_Access3' + name
* def basepath = 'countryAccess3' + name 
* set myReq.swagger.info.title = title
* set myReq.swagger.basePath = basepath
And request myReq
When method post
* retry until responseStatus == <responseCode> 
* call read('classpath:examples/Polling/Polling.feature') 
#Get view token for publisher access
Given url authURL
And header Authorization = Authorization 
And form field grant_type = 'password' 
And form field scope = 'apim:api_view'
And form field username = <pubUsername>
And form field password = <pubPassword>
When method post
* def pubViewToken = 'Bearer ' + response.access_token
* print 'viewToken is ', pubViewToken

# Get the APIID from Publisher
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* def match APPIDFromPublisher.response.list[] == <pubResponse>

#Get view token for store access
Given url authURL
And header Authorization = Authorization 
And form field grant_type = 'password' 
And form field scope = 'apim:api_view'
And form field username = <storeUsername>
And form field password = <storePassword>
When method post
* def storeViewToken = 'Bearer ' + response.access_token
* print 'viewToken is ', storeViewToken
 
# Get the APIID from Store
* def APPIDFromStore = call read('classpath:examples/Services/GetAPIIDFromStore.feature') {'title': '#(title)'  }
* def APIIDStr = APPIDFromStore.APIIDStr
* def match APPIDFromStore.response.list[] == <storeResponse>

* call read('classpath:examples/Polling/Polling.feature') 
#* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }

Examples:
|pubRoles                   |storeRoles                 |pubResponse        |storeResponse    |pubUsername          |pubPassword   |storeUsername     |storePassword |       
|[DevTeamAlpha,DevTeamBeta] |[DevTeamBeta]              |'#notnull'         |'#notnull'       |'reg_tests'          |'cacti-CkEgpE'|'regtest_customer'|'admin'       |               
|[DevTeamAlpha]             |[DevTeamBeta,DevTeamAlpha] |'#notnull'         |'#notnull'       |'regtest_customer'   |'admin'       |'reg_tests'       |'cacti-CkEgpE'|                

#------------------------------------------------ **** END **** --------------------------------------------------#


