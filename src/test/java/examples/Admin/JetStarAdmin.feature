Feature: This feature tests the Jetstar functionality

Background:
* def now = function(){ return java.lang.System.currentTimeMillis() }

#----------------------**** ADMIN ****----------------------------------#

@Admin @parallel=false @All @JetstarAdmin
Scenario: large swagger files
Given url Admin
* json myReq = read('JetStar-large-swagger-config.json')
* def name = '1-' + now()
* set myReq.swagger.info.title = 'Regtest_Large' + name
* def basepath = 'countrylargeAdminJetstar' + name
* set myReq.swagger.basePath = basepath
* request myReq
When method post
* retry until responseStatus == 200 
* call read('classpath:examples/Polling/Polling.feature') 
* def title = 'Regtest_Large'
* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': '#(title)'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
* call read('classpath:examples/Polling/Polling.feature')

#----------------------------------------------------------------------------------#
@Admin @parallel=false @All @JetstarAdmin
Scenario Outline: Register API and validate the flags

Given url Admin
* json myReq = read('Swagger-JetStarAdmin.json')
* set myReq.apiConf.externalGateway = <externalFlag>
* set myReq.apiConf.internalGateway = <internalFlag>
* set myReq.apiConf.jetstarExternalGateway = <jetstarExternalFlag>
* set myReq.apiConf.jetstarInternalGateway = <jetstarInternalFlag>
* def name = '1-' + now()
* def title = <title> + name
* def basepath = <basepath> + name
* set myReq.swagger.info.title = title
* set myReq.swagger.info.version = <version>
* set myReq.apiConf.domain = <domain>
* set myReq.swagger.basePath = basepath
* print 'my subscriptions : ', myReq.apiConf
And request myReq 
When method post
* retry until responseStatus == 200 
* call read('classpath:examples/Polling/Polling.feature')
* def DefFromPub = call read('classpath:examples/Services/GetAPIDefFromPublisher.feature') {'title': '#(title)'  }
* match DefFromPub.response.gatewayEnvironments contains <flagStatus> 
* def APIIDPub = DefFromPub.APIIDPub
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
* call read('classpath:examples/Polling/Polling.feature') 

Examples:
|version |title            |domain    |basepath            | externalFlag | internalFlag | jetstarExternalFlag| jetstarInternalFlag |responseCode| flagStatus |
|'v123'  |'Regtest_flag1'  |'test'    |'countryAdminJet123'| true         | true         | true               | true                | 200        | 'Jetstar Internal Gateway,Jetstar External Gateway,External Gateway,Internal Gateway'|
|'v124'  |'Regtest_flag2'  |'product' |'countryAdminJet124'| true         | true         | false              | false               | 200        | 'External Gateway,Internal Gateway'|
|'v125'  |'Regtest_flag3'  |'customer'|'countryAdminJet125'| true         | true         | false              | true                | 200        | 'Jetstar Internal Gateway,External Gateway,Internal Gateway'|
|'v126'  |'Regtest_flag4'  |'flight'  |'countryAdminJet126'| true         | true         | true               | false               | 200        | 'Jetstar External Gateway,External Gateway,Internal Gateway'|
|'v127'  |'Regtest_flag5'  |'aircraft'|'countryAdminJet127'| false        | false        | true               | true                | 200        | 'Jetstar Internal Gateway,Jetstar External Gateway'|
|'v128'  |'Regtest_flag6'  |'event'   |'countryAdminJet128'| false        | false        | true               | false               | 200        | 'Jetstar External Gateway'|
|'v129'  |'Regtest_flag7'  |'car'     |'countryAdminJet129'| false        | false        | false              | false               | 200        | ''|
|'v130'  |'Regtest_flag8'  |'employee'|'countryAdminJet130'| false        | false        | false              | true                | 200        | 'Jetstar Internal Gateway'|
|'v131'  |'Regtest_flag9'  |'test'    |'countryAdminJet131'| true         | false        | true               | true                | 200        | 'Jetstar Internal Gateway,Jetstar External Gateway,External Gateway'|
|'v132'  |'Regtest_flag10' |'product' |'countryAdminJet132'| false        | true         | true               | true                | 200        | 'Jetstar Internal Gateway,Jetstar External Gateway,Internal Gateway'|
|'v135'  |'Regtest_flag13' |'aircraft'|'countryAdminJet135'| false        | true         | false              | false               | 200        | 'Internal Gateway'|
|'v136'  |'Regtest_flag14' |'event'   |'countryAdminJet136'| true         | false        | false              | false               | 200        | 'External Gateway'|
|'v138'  |'Regtest_flag16' |'employee'|'countryAdminJet138'| true         | true         | false              | false               | 200        | 'External Gateway,Internal Gateway'|


#------------------------------------------------ **** END **** --------------------------------------------------#