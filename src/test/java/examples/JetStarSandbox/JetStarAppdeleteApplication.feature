Feature: Delete Applications


@deleteApp
Scenario: delete application
# token
#Create subscribe token
#Given url authURL
#And header Authorization = Authorization
#And form field grant_type = 'password'
#And form field username = 'admin'
#And form field password = 'bananaM1lkshake'
#And form field scope = 'apim:subscribe'
#When method post
#Then status 200
#* def subscribeToken = 'Bearer ' + response.access_token
#* print 'SubscriberToken is ', subscribeToken

#get id Application
Given url applicationURL + '/applications/'
* def auth = callonce read('classpath:examples/Tokens/SubscribeToken.feature') {'subscribeToken': 'subscribeToken'  }
* print ' auth create for deleting Admins API' , auth.subscribeToken
* header Authorization = auth.subscribeToken
When method get
Then status 200
* def list = $..[?(@.name contains 'Test-')]
* print ' list ', list
* def fun = function(array){ for (var i = 0; i < array.length; i++) karate.call('Appdelete.feature')   }
* call fun list


