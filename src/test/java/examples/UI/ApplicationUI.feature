Feature: This feature is to test the Group Access Control for Applications. 
	The Scenarios it's going to cover are :
    1. Shared Groups visbility by members and owner.
    2. Shared groups access for owner (All) and members(View and no delete and edit Access)
    3. Key generation Access for memebers ( Only after the owner generates it for the first time)
    4. Duplicate Application creation without groups (allowed).
    5. Duplicate Application creation with groups(not allowed).
    6. Invalid group Addition.
    7. Regeneration of Keys by members.	
	
	#-------------------------------------------------------------------------------
	#****************------ Auth Server - Create Token ----------*****************
@parallel=false  @GroupAcc
	Scenario: Application Access between group members. 
	 1. Add Application and share it with different user.
	 2. Verify the access permissions for the members (should be only view access)
	 3. Verify the key generation access is only given after owner generates the key.
	 4. Key regeneration by the members. 
	* def DemoClass = Java.type('examples.UI.GroupAccessUI') 
	* def myVar = DemoClass.main() 
	

	#---------------------------------------------------------------------------------
	@parallel=false
	Scenario: Add rubbish/invalid groups 
	# All rubbish and duplicate groups are allowed 
	# Steps followed:
	#1. login with SSO
	#2. Create an Application and add an invalid group( rubbish, alphanumeric, group with space and just a space).
	#3. Any group should be allowed in the UI but no mapping will be present in the store.
	* def invalidGroup = Java.type('examples.UI.InvalidGroup') 
	* def myVar = invalidGroup.main("Invalid") 
	* print myVar 
#	
	#---------------------------------------------------------------------------------
	@parallel=false
	Scenario: Create default applications with same name by two diffrent user and
	verify both are independent of each other when no groups are added
	# Steps followed:
	#1. Create Application "A1" with user1.
	#2. Create Application "A1" with user2.
	#3. Delete any application and check the other application is intact.
	* def Duplicate = Java.type('examples.UI.DuplicateApplicationNameWithoutGroup') 
	* def myVar = Duplicate.main() 
	* print myVar 
#	
	#---------------------------------------------------------------------------------
    @parallel=false
	Scenario: Create default applications with same name by two diffrent user and
	verify both are not independent of each other when groups are added
	# Steps followed:
	#1. Create Application "A1" with user1.
	#2. Create Application "A1" with user2 and that should be allowed.
	#3. Delete A1 with usser1 credentials. A1 application should be deleted from user 2 store as well.
	* def Duplicate = Java.type('examples.UI.DuplicateApplicationNameWithGroup') 
	* def myVar = Duplicate.main() 
	* print myVar 
#	
	#----------------------------**END**-------------------------------------------------#
	