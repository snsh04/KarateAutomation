This is a KARATE TEST AUTOMATION FRAMEWORK for API Gateway Team 

Each folder under "src/test/java" is a component of API Gateway and can be executed independently or in collaboration with all other features.

Steps to run the test manually:
1. Go to examples --> ExampleTest.java and specify the tag to run.
2. If you want to run all the tests together, just uncomment the ignore tag.


Steps to run from CI:
1. Go to plan.
2. run customised with following variables:

Environment : Dev/uat/Prod
Testcases: All/Admin/Gateway/GatewayNGINX/Backend/Publisher/Store
Authorization: Put in the basic Auth credentials.
