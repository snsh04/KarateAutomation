Feature: Test Akamai Caching 

 Background:
 # not required

#-----------------------------------------------------------------------------------
@Akamai
Scenario: Test Akamai Caching
#********------ STORE -----------************
#Invoke API through Internal Gateway
Given url 'https://api.random.com/flight/refData/v1/airport'
And header pragma = 'akamai-x-get-client-ip, akamai-x-cache-on, akamai-x-cache-remote-on, akamai-x-check-cacheable, akamai-x-get-cache-key, akamai-x-get-extracted-values, akamai-x-get-nonces, akamai-x-get-ssl-client-session-id, akamai-x-get-true-cache-key, akamai-x-serial-no, akamai-x-feo-trace, akamai-x-get-request-id' 
When method get
Then status 200
* print 'response headers ', responseHeaders.X-Cache
* match responseHeaders.X-Cache contains 'TCP_MISS'

Given url 'https://api.random.com/flight/refData/v1/airport'
And header pragma = 'akamai-x-get-client-ip, akamai-x-cache-on, akamai-x-cache-remote-on, akamai-x-check-cacheable, akamai-x-get-cache-key, akamai-x-get-extracted-values, akamai-x-get-nonces, akamai-x-get-ssl-client-session-id, akamai-x-get-true-cache-key, akamai-x-serial-no, akamai-x-feo-trace, akamai-x-get-request-id' 
When method get
Then status 200
* print 'response headers ', responseHeaders.X-Cache
* match responseHeaders.X-Cache contains 'TCP_HIT'

@Akamai
Scenario: Test Akamai Caching with query parmaters shuffled
#********------ STORE -----------************
#Invoke API through Internal Gateway
Given url 'https://api.random.com/flight/refData/v1/airport?category=ALL&onlineIndicator=true&code=SYD&locale=ZH_CN'
And header pragma = 'akamai-x-get-client-ip, akamai-x-cache-on, akamai-x-cache-remote-on, akamai-x-check-cacheable, akamai-x-get-cache-key, akamai-x-get-extracted-values, akamai-x-get-nonces, akamai-x-get-ssl-client-session-id, akamai-x-get-true-cache-key, akamai-x-serial-no, akamai-x-feo-trace, akamai-x-get-request-id' 
When method get
Then status 200
* print 'response headers ', responseHeaders.X-Cache
* match responseHeaders.X-Cache contains 'TCP_HIT'

@Akamai
Scenario: Test Akamai Caching with capital and small query parameters
#********------ STORE -----------************
#Invoke API through Internal Gateway
Given url 'https://api.random.com/flight/refData/v1/airport?category=ALL&onlineIndicator=true&code=SYD&locale=ZH_CN'
And header pragma = 'akamai-x-get-client-ip, akamai-x-cache-on, akamai-x-cache-remote-on, akamai-x-check-cacheable, akamai-x-get-cache-key, akamai-x-get-extracted-values, akamai-x-get-nonces, akamai-x-get-ssl-client-session-id, akamai-x-get-true-cache-key, akamai-x-serial-no, akamai-x-feo-trace, akamai-x-get-request-id' 
When method get
Then status 200
* print 'response headers ', responseHeaders.X-Cache
* match responseHeaders.X-Cache contains 'TCP_HIT'

Given url 'https://api.random.com/flight/refData/v1/airport?category=ALL&onlineIndicator=true&code=syd&locale=ZH_CN'
And header pragma = 'akamai-x-get-client-ip, akamai-x-cache-on, akamai-x-cache-remote-on, akamai-x-check-cacheable, akamai-x-get-cache-key, akamai-x-get-extracted-values, akamai-x-get-nonces, akamai-x-get-ssl-client-session-id, akamai-x-get-true-cache-key, akamai-x-serial-no, akamai-x-feo-trace, akamai-x-get-request-id' 
When method get
Then status 200
* print 'response headers ', responseHeaders.X-Cache
* match responseHeaders.X-Cache contains 'TCP_MISS'


