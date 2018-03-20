/*
   Classname : Test_TRAK_TraceabilityMatrixCntrl
   Created By: Deloitte Consulting
   Created Date: 
   Description: This class is the test class for TRAK_TraceabilityMatrixCntrl Class.
*/


@istest
Public with sharing Class Test_TRAK_TraceabilityMatrixCntrl{

        public static User tstuser;
        public static User tstuser_Admin;
        public static User createUser(String pName){
        Profile pfl = [Select id from profile where name=:pName];
        //Declaring the user
        User runAsUser = new User(alias = 'test', email='test@testorg.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = pfl.Id,  country='United States', CommunityNickname = 'u1'+String.valueOf(System.now().getTime()),
            timezonesidkey='America/Los_Angeles', username='testuser'+String.valueOf(System.now().getTime())+'@gso_org.com' );
        
        insert runAsUser;  
        System.assertNotEquals(runAsUser.Id,null);
        return runAsUser;       
        }


      static testMethod void myUnitTest() {
      
        tstuser = createUser('Senior System Administrator');
        PermissionSet Timesheetadmin = [SELECT ID From PermissionSet WHERE Name = 'TRAK_Tracker_Admin'];
        PermissionSetAssignment PSAssignmenTs = new PermissionSetAssignment();
        PSAssignmenTs.AssigneeId = tstuser.id;
        PSAssignmenTs.PermissionSetId = Timesheetadmin.ID;
        insert PSAssignmenTs;
        System.assertNotEquals(PSAssignmenTs.Id,null);
        
        tstuser_Admin = createUser('Senior System Administrator');
        PermissionSet Timesheetadmin_1 = [SELECT ID From PermissionSet WHERE Name = 'TRAK_Tracker_Admin'];
        PermissionSetAssignment PSAssignmenTs_1 = new PermissionSetAssignment();
        PSAssignmenTs_1.AssigneeId = tstuser_Admin.id;
        PSAssignmenTs_1.PermissionSetId = Timesheetadmin_1.ID;
        insert PSAssignmenTs_1;
        System.assertNotEquals(PSAssignmenTs_1.Id,null);
        
       System.runAs(tstuser) {
       
        Test.startTest();
        TRAK_Sprint__c MS=new TRAK_Sprint__c(name='ts-12334');
        insert MS;
        System.assertNotEquals(MS.Id,null);
        TRAK_User_Story__c MU=new TRAK_User_Story__c(Development_stage__c ='Backlog' ,Allocated_Sprint__c=MS.id);
        MU.System_Custodian__c = tstuser.id;
        MU.System_Owner__c = tstuser_Admin.id;
        insert MU;
        System.assertNotEquals(MU.Id,null);
        List<TRAK_User_Story__c> userStories = [SELECT Name FROM TRAK_User_Story__c]; 
        System.assertEquals(userStories.size(), 1);
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(MS);
        TRAK_TraceabilityMatrixCntrl GST=new TRAK_TraceabilityMatrixCntrl(sc);
        system.assertEquals(GST.UserList.size(),1);
        GST.redirect();
        Test.stopTest();
        
        }
} 
}