Feature: Test websockets

Background:
# not required



@parellel=false 
Scenario: text messages - direct backend
    And def socket = karate.webSocket('wss://demo-websocket-dev-a878-02-ams10-nonp.cloud.random.com')
    When socket.send('Hi there, I am a WebSocket server')
    And def result = socket.listen(8099)
    Then match result == 'Hi there, I am a WebSocket server'
      
@parellel=false 
Scenario: Text message - via gateway
    * def options = { headers: { Authorization: 'Test' } }
	* def socket = karate.webSocket('wss://websocket-gw-uat-dev-a878-35-ams10-nonp.cloud.random.com:8099/test/demo-websocket/v1', null, options)
    And def result = socket.listen(8099)
    * print 'response from websocket ', result
    Then match result == 'Hi there, I am a WebSocket server'
    
   When socket.send('another test')
    And def result = socket.listen(5000)
    Then match result == 'Echo another test'
    * configure abortedStepsShouldPass = true
    * if (true) karate.abort()
    
@parellel=false @websockets
Scenario: Text message - via gateway throttle 
    * def options = { headers: { Authorization: 'Test' } }
	* def socket = karate.webSocket('wss://websocket-gw-uat-dev-a878-35-ams10-nonp.cloud.random.com:8099/test/demo-websocket/v1', null, options)
    And def result = socket.listen(8099)
    * print 'response from websocket ', result
    Then match result == 'Hi there, I am a WebSocket server'
    
    
     # call 1 
      When socket.send('Call 1')
    And def result = socket.listen(8099)
    * print 'response from websocket ', result
    Then match result == 'Echo Call 1'
     # call 2 
    When socket.send('Call 2')
    And def result = socket.listen(8099)
    * print 'response from websocket ', result
    Then match result == 'Echo Call 2'
         # call 3 
      When socket.send('Call 3')
    And def result = socket.listen(8099)
    * print 'response from websocket ', result
    Then match result == 'Echo Call 3'
         # call 4 
      When socket.send('Call 4')
    And def result = socket.listen(8099)
    * print 'response from websocket ', result
    Then match result == 'Echo Call 4'
         # call 5
      When socket.send('Call 5')
    And def result = socket.listen(8099)
    * print 'response from websocket ', result
    Then match result == 'Echo Call 5'
      # call 5 - should trottle
       When socket.send('Call 6')
    And def result = socket.listen(8099)
    * print 'response from websocket ', result
    Then match result == 'Websocket frame throttled out'

@parellel=false 
Scenario: Text message - via gateway
    * def options = { headers: { Authorization: 'Test'  } }
	* def socket = karate.webSocket('wss://websocket-gw-dev-dev-a878-35-ams10-nonp.cloud.random.com:8099/test/demo-websocket/v1', null, options)
    And bytes data = read('heyo.txt')
    When socket.sendBytes(data)
    And def result = socket.listen(8099)
    * print 'response from websocket ', result
    # the result data-type is byte-array, but this comparison works
    Then match result == read('heyo.txt')

@parellel=false 
Scenario: Text message - via gateway -  in valid custom header
    * def options = { headers: { Authorization: 'Test' , test: 'test' } }
	* def socket = karate.webSocket('wss://websocket-gw-dev-dev-a878-35-ams10-nonp.cloud.random.com:8099/test/websockets/V1', null, options)
     When socket.send('Call 4')
    And def result = socket.listen(8099)
    * print 'response from websocket ', result
    Then match result == 'Call 4'
    # the result data-type is byte-array, but this comparison works
   
@parellel=false 
Scenario: Text message - via gateway -  valid custom header
    * def options = { headers: { Authorization: 'Test' , websocket-custom-header-test: 'test' } }
	* def socket = karate.webSocket('wss://websocket-gw-dev-dev-a878-35-ams10-nonp.cloud.random.com:8099/test/demo-websocket/v1', null, options)
     When socket.send('Call 4')
    And def result = socket.listen(8099)
    * print 'response from websocket ', result
    Then match result == 'Call 4'

   



