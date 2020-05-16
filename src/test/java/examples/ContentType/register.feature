Feature: Register and subscribe to API

Background: 
* def now = function(){ return java.lang.System.currentTimeMillis() }


Scenario: Register and subscribe
Given url Admin
* json myReq = read('Swagger-AuthcontentType.json')
* set myReq.apiConf.subscriptionTiers = ['Silver_Auto-Approved','Gold_Auto-Approved','Bronze_Auto-Approved']
* def name = '1-' + now()
* def title = 'REGTEST_AuthContentType'
* def basepath = 'AuthtestContentType' + name
* set myReq.swagger.info.title = title
* set myReq.swagger.info.version = 'v1112'
* set myReq.apiConf.domain = 'aircraft'
* set myReq.swagger.basePath = 'AuthContentType'
And request myReq
When method post
Then status 200

