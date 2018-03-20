/*************************************************************************\
@ Author        : Deloitte Consulting
@ Date          : 25-July-2014
@ Description   : Test Class for GLBL_LoginAutherizationClass class
****************************************************************************/
@isTest(SeeAllData=false)
private class Test_TRAK_UserStoryApprovalClass {

    
   
    
    public static User sysCust;
    public static User sysOwner;
    public static User BysQual;
    public static User SysQual;
    public static TRAK_User_Story__c testUserStory;
    public static TRAK_User_Story__c testUserStory_GxpNo;
    
     /* 
    * @Method Name                    :  setupTestData
    * @Description                    :  Test Method for TRAK_UserStoryApprovalClass 
    * @Return Type                    :  void
    * @Param                          :  
    
    */
   
    static void setupTestData() {
        
        //Creating the test user for System Custodian
        sysCust = new User();
        sysCust.username = 'sysCust@Test.com.env';
        sysCust.Email = 'sysCust@Test.com';
        sysCust.profileid = UserInfo.getProfileId();
        sysCust.lastname = 'Custodian';
        sysCust.firstname = 'System';
        sysCust.Alias = 'syc';
        sysCust.TimeZoneSidKey = 'America/Los_Angeles';
        sysCust.LocaleSidKey = 'en_US';
        sysCust.EmailEncodingKey = 'UTF-8';
        sysCust.LanguageLocaleKey = 'en_US';
        insert sysCust;
        
        //Creating the test user for System Owner
        sysOwner = new User();
        sysOwner.username = 'sysOwner@Test.com.env';
        sysOwner.Email = 'sysOwner@Test.com';
        sysOwner.profileid = UserInfo.getProfileId();
        sysOwner.lastname = 'Owner';
        sysOwner.firstname = 'System';
        sysOwner.Alias = 'syo';
        sysOwner.TimeZoneSidKey = 'America/Los_Angeles';
        sysOwner.LocaleSidKey = 'en_US';
        sysOwner.EmailEncodingKey = 'UTF-8';
        sysOwner.LanguageLocaleKey = 'en_US';
        insert sysOwner;
        
        //Creating the test user for Business Quality
        BysQual = new User();
        BysQual.username = 'BysQual@Test.com.env';
        BysQual.Email = 'BysQual@Test.com';
        BysQual.profileid = UserInfo.getProfileId();
        BysQual.lastname = 'Quality';
        BysQual.firstname = 'Business';
        BysQual.Alias = 'byq';
        BysQual.TimeZoneSidKey = 'America/Los_Angeles';
        BysQual.LocaleSidKey = 'en_US';
        BysQual.EmailEncodingKey = 'UTF-8';
        BysQual.LanguageLocaleKey = 'en_US';
        insert BysQual;
        
        //Creating the test user for Computer Systems Quality
        SysQual = new User();
        SysQual.username = 'SysQual@Test.com.env';
        SysQual.Email = 'SysQual@Test.com';
        SysQual.profileid = UserInfo.getProfileId();
        SysQual.lastname = 'Quality';
        SysQual.firstname = 'System';
        SysQual.Alias = 'syq';
        SysQual.TimeZoneSidKey = 'America/Los_Angeles';
        SysQual.LocaleSidKey = 'en_US';
        SysQual.EmailEncodingKey = 'UTF-8';
        SysQual.LanguageLocaleKey = 'en_US';
        insert SysQual;
       
        System.runAs(sysOwner) {
            
            testUserStory = new TRAK_User_Story__c();
            testUserStory.Acceptance_Criteria__c = 'OldAcceptanceCriteria';
            testUserStory.Compliance_Criteria__c = 'OldCC';
            testUserStory.Compliance_Owner__c = BysQual.Id;
            testUserStory.Computer_Systems_Quality__c = SysQual.Id;
            testUserStory.System_Custodian__c = sysCust.Id;
            testUserStory.System_Owner__c = sysOwner.Id;
            testUserStory.GXP__c = 'No';
            testUserStory.Critical__c = 'Yes';
            testUserStory.TRAK_Business_Quality_Approved__c = false;
            testUserStory.TRAK_Computer_Systems_Quality_Approved__c = false;
            testUserStory.TRAK_System_Custodian_Approved__c = true;
            testUserStory.TRAK_System_Owner_Approved__c = false;
            testUserStory.Approval_Status__c = 'Open';
            
            insert testUserStory;
            
            testUserStory_GxpNo = new TRAK_User_Story__c();
            testUserStory_GxpNo.Acceptance_Criteria__c = 'OldAcceptanceCriteria';
            testUserStory_GxpNo.Compliance_Criteria__c = 'OldCC';
            testUserStory_GxpNo.Compliance_Owner__c = BysQual.Id;
            testUserStory_GxpNo.Computer_Systems_Quality__c = SysQual.Id;
            testUserStory_GxpNo.System_Custodian__c = sysCust.Id;
            testUserStory_GxpNo.System_Owner__c = sysOwner.Id;
            testUserStory_GxpNo.GXP__c = 'No';
            testUserStory_GxpNo.Critical__c = 'No';
            testUserStory_GxpNo.TRAK_Business_Quality_Approved__c = false;
            testUserStory_GxpNo.TRAK_Computer_Systems_Quality_Approved__c = false;
            testUserStory_GxpNo.TRAK_System_Custodian_Approved__c = true;
            testUserStory_GxpNo.TRAK_System_Owner_Approved__c = false;
            testUserStory_GxpNo.Approval_Status__c = 'Open';
            
            insert testUserStory_GxpNo;
        }
        
        System.runAs(SysQual) {
            testUserStory.Approval_Status__c = 'Pending Approval';
            update testUserStory;
            testUserStory_GxpNo.Approval_Status__c = 'Pending Approval';
            update testUserStory_GxpNo;
        }
    }
    
    static testmethod void Trak_User_Story_Approval() {
     setupTestData();
        List<TRAK_User_Story__c> lUserStory = TRAK_Test_Utility.createUSerStory(1);
        insert lUserStory;
        TRAK_User_Story_Approval_History__c oApprovalHistory = new TRAK_User_Story_Approval_History__c();
        oApprovalHistory.System_Custodian__c = sysCust.Id;
        oApprovalHistory.System_Owner__c = sysOwner.Id;
        oApprovalHistory.User_Story__c = lUserStory[0].Id;
        insert oApprovalHistory;
    }

    
    /* 
    * @Method Name                    :  testApprovalProcess_GXPNo
    * @Description                    :  Test Method for TRAK_UserStoryApprovalClass 
    * @Return Type                    :  void
    * @Param                          :  
    
    */
    
    static testMethod void testApprovalProcess_GXPNo() {
        
        setupTestData();
        
        //Negative Scenarios if the status is not equal to Pending approval the button should not be active
        ApexPages.StandardController controller = new ApexPages.StandardController(testUserStory_GxpNo);
        PageReference pageRef = Page.TRAK_UserStoryApproval;
        Test.setCurrentPageReference(pageRef);
        
        //   
        
        Test.StartTest();
        System.runAs(sysOwner) {
            TRAK_UserStoryApprovalClass testApprovalClass = new TRAK_UserStoryApprovalClass(controller);
            
            Boolean approveCheck = testApprovalClass.getcheckApproveRejectButton();
            System.assertEquals(approveCheck, false);
            
            
            testApprovalClass.approveUserStory();
            System.assertEquals(true, testUserStory_GXPNo.TRAK_System_Owner_Approved__c);
            
        } 
        Test.StopTest();
    }
    
    /* 
    * @Method Name                    :  testApprovalProcess
    * @Description                    :  Test Method for TRAK_UserStoryApprovalClass 
    * @Return Type                    :  void
    * @Param                          :  
    
    */
    
    static testMethod void testApprovalProcess() {
        
        setupTestData();
        
        //Negative Scenarios if the status is not equal to Pending approval the button should not be active
        ApexPages.StandardController controller = new ApexPages.StandardController(testUserStory);
        
        TRAK_UserStoryApprovalClass testApprovalClass = new TRAK_UserStoryApprovalClass(controller);
        Boolean approveCheck = testApprovalClass.getcheckApproveRejectButton();
        
        System.assertEquals(approveCheck, false);
        
        
        Test.StartTest();
        
        // Postive Case Scenario (Button should be enabled only for System Admin and Custodian)
        System.runAs(sysOwner) {
            Boolean approveChecksysOwner = testApprovalClass.getcheckApproveRejectButton();
            System.assertEquals(approveChecksysOwner, false);
        }
        
        // Postive Case Scenario (Button should be enabled only for System Admin and Custodian)
        System.runAs(sysOwner) {
            Boolean approveChecksysOwner = testApprovalClass.getcheckApproveRejectButton();
            System.assertEquals(approveChecksysOwner, false);
        }
        
        // Negative Case Scenario (Button should not be enabled only for Business Quality and System Quality User)
        System.runAs(SysQual) {
            Boolean approveCheckSysQual = testApprovalClass.getcheckApproveRejectButton();
            System.assertEquals(approveCheck, false);
        }
        
        //Setting the Test Page
        testApprovalClass.redirectToApprovalPage();
        PageReference pageRef = Page.TRAK_UserStoryApproval;
        Test.setCurrentPageReference(pageRef);
        
        System.runAs(sysOwner) {
            testApprovalClass.approveUserStory();
            System.assertEquals(true, testUserStory.TRAK_System_Owner_Approved__c);
        }
        
        System.runAs(sysCust) {
            testApprovalClass.approveUserStory();
            System.assertEquals(true, testUserStory.TRAK_System_Custodian_Approved__c);
        }
        
        //Button should be enabled for Business Quality and System Quality User when Sys Custodian and System Owner have approved the story
        //Positive Scenarios
        System.runAs(SysQual) {
            Boolean approveCheckSysQual = testApprovalClass.getcheckApproveRejectButton();
            System.assertEquals(approveCheckSysQual, false);
        }
        
        System.runAs(SysQual) {
            testApprovalClass.approveUserStory();
            System.assertEquals(true, testUserStory.TRAK_Computer_Systems_Quality_Approved__c);
        }
        
        System.runAs(BysQual) {
            testApprovalClass.approveUserStory();
            System.assertEquals(true, testUserStory.TRAK_Business_Quality_Approved__c);
        }
        
        System.runAs(sysOwner) {
            
            //Changing the status of the enhancement to Pending Approval
            //   testUserStory.GXP__c = 'No';
            //  testUserStory.Critical__c = 'No';
            //   testUserStory.Approval_Status__c = 'Pending Approval';
            //  update testUserStory;
            
            Boolean approveChecksysOwner2 = testApprovalClass.getcheckApproveRejectButton();
            System.assertEquals(approveChecksysOwner2, false);
            
            testApprovalClass.approveUserStory();
            System.assertEquals(true, testUserStory.TRAK_System_Owner_Approved__c);
        }
        
        
        System.runAs(sysCust) {
            testApprovalClass.approveUserStory();
            System.assertEquals(true, testUserStory.TRAK_System_Custodian_Approved__c);
        }
        
        // User story should be approved
        System.assertEquals(true, testUserStory.Approval_Status__c == 'Approved');
        
        Test.StopTest();
    }
    
    /* 
    * @Method Name                    :  testRejectionProcess
    * @Description                    :  Test Method for TRAK_UserStoryApprovalClass 
    * @Return Type                    :  void
    * @Param                          :  
    
    */
    
    static testMethod void testRejectionProcess() {
        setupTestData();
        
        ApexPages.StandardController controller = new ApexPages.StandardController(testUserStory);
        
        TRAK_UserStoryApprovalClass testRejectionClass = new TRAK_UserStoryApprovalClass(controller);
        String approvalPageURL = testRejectionClass.approvalPageURL;
        String redirectUrl = testRejectionClass.redirectUrl;
        
        Test.StartTest();
        
        System.runAs(sysOwner) {
            testRejectionClass.rejectUserStory();
            System.assertEquals(false, testUserStory.TRAK_System_Owner_Approved__c);
        }
        
        System.assertEquals(true, testUserStory.Approval_Status__c == 'Rejected');
        
        System.runAs(sysCust) {
            testRejectionClass.rejectUserStory();
            System.assertEquals(false, testUserStory.TRAK_System_Custodian_Approved__c);
        }
        
        System.assertEquals(true, testUserStory.Approval_Status__c == 'Rejected');
        
        System.runAs(SysQual) {
            testRejectionClass.rejectUserStory();
            System.assertEquals(false, testUserStory.TRAK_Computer_Systems_Quality_Approved__c);
        }
        
        System.assertEquals(true, testUserStory.Approval_Status__c == 'Rejected');
        
        System.runAs(BysQual) {
            testRejectionClass.rejectUserStory();
            System.assertEquals(false, testUserStory.TRAK_Business_Quality_Approved__c);
        }
        
        System.assertEquals(true, testUserStory.Approval_Status__c == 'Rejected');
        
        Test.StopTest();
    }
    
    
}