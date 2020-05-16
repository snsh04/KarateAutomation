Feature: Test Auth server

 Background:
* configure retry = { count: 7, interval: 5000 }

#-----------------------------------------------------------------------------------

Scenario: SSO user login for the second time should be able to delete the application
#********------ AUTH -----------************
* def SSO = Java.type('examples thServer thServer') 
* def ApplicationDeleted = SSO.main() 
* match ApplicationDeleted == 'true'

@Auth
Scenario: Regiter API with pipeline and invoke /jwks
Given url ApiAdminURL
And path AdminPath
And header apigateway-apikey = apiGatewayKey
And header apigateway-basepath = 'oauth2'
And request read('Swagger-IdentityServer.json')	
When method post
Then status 200

## Invoke random internal
Given url 'https://gateway-dev-dev-a878-15-ams10-nonp.cloud.random.com/pricing/oauth2/v1/jwks'
* retry until responseStatus == 200
When method get 
Then status 200


## Invoke random external
Given url 'https://gateway-int-dev-dev-a878-15-ams10-nonp.cloud.random.com/pricing/oauth2/v1/jwks'
* retry until responseStatus == 200
When method get 
Then status 200

## Invoke jetstar internal
Given url 'https://gateway-jg-int-dev-dev-a878-30-ams10-nonp.cloud.random.com/pricing/oauth2/v1/jwks'
* retry until responseStatus == 200
When method get 
Then status 200

## Invoke jetstar external
Given url 'https://gateway-jg-dev-dev-a878-30-ams10-nonp.cloud.random.com/pricing/oauth2/v1/jwks'
* retry until responseStatus == 200
When method get 
Then status 200

## Invoke random internal
Given url 'https://gateway-dev-dev-a878-15-ams10-nonp.cloud.random.com/pricing/oauth2/v1/oidcdiscovery'
* retry until responseStatus == 404
When method get 
Then status 404


## Invoke random external
Given url 'https://gateway-int-dev-dev-a878-15-ams10-nonp.cloud.random.com/pricing/oauth2/v1/oidcdiscovery'
* retry until responseStatus == 404
When method get 
Then status 404

## Invoke jetstar internal
Given url 'https://gateway-jg-int-dev-dev-a878-30-ams10-nonp.cloud.random.com/pricing/oauth2/v1/oidcdiscovery'
* retry until responseStatus == 404
When method get 
Then status 404

## Invoke jetstar external
Given url 'https://gateway-jg-dev-dev-a878-30-ams10-nonp.cloud.random.com/pricing/oauth2/v1/oidcdiscovery'
* retry until responseStatus == 404
When method get 
Then status 404

* def APPIDFromPublisher = call read('classpath:examples/Services/GetAPIIDFromPublisher.feature') {'title': 'Identity Server'  }
* def APIIDPub = APPIDFromPublisher.APIIDPub
* call read('classpath:examples/Services/DeleteAPI.feature')  {'APIIDPub': '#(APIIDPub)'  }
* call read('classpath:examples/Polling/Polling.feature') 

