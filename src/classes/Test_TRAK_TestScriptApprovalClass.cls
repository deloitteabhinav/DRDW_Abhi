/*************************************************************************\
    @ Author        : Neelam Dalwani
    @ Date          : 03-Sept-2014
    @ Description   : Test Class for GLBL_LoginAutherizationClass class
****************************************************************************/
@
isTest
private class Test_TRAK_TestScriptApprovalClass {

public static TRAK_Test_Templates__c testExecObj;
public static User sysCust;
public static User sysOwner;

static testMethod void setupTestData() {

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
        
        
    List<TRAK_User_Story__c> lUsrStory = TRAK_Test_Utility.createUserStory(1);
    insert lUsrStory;
    testExecObj = new TRAK_Test_Templates__c(Submitter__c=UserInfo.getUserid(),Approval_Status__c='Open',approver__c=sysOwner.id,Title__c='test',Introduction__c='test',User_Story__c= lUsrStory[0].id );
                
    insert testExecObj;
    ApexPages.StandardController controller = new ApexPages.StandardController(testExecObj);
    
    TRAK_TestScriptApprovalClass testApprovalClass = new TRAK_TestScriptApprovalClass(controller);
    Boolean checkRecall=testApprovalClass.getcheckRecallButton();
    
    testExecObj.Approval_Status__c = 'Pending Approval';
    update testExecObj;
    
    checkRecall=testApprovalClass.getcheckRecallButton();
    
    testApprovalClass.recallApprovalRequest();    
    
}


static testMethod void testApprovalProcess() {

        setupTestData();

        //Negative Scenarios if the status is not equal to Pending approval the button should not be active
        ApexPages.StandardController controller = new ApexPages.StandardController(testExecObj);

        TRAK_TestScriptApprovalClass testApprovalClass = new TRAK_TestScriptApprovalClass(controller);
        Boolean approveCheck = testApprovalClass.getcheckApproveRejectButton();
    
        System.assertEquals(approveCheck, false);

        Test.StartTest();
       
        // Postive Case Scenario (Button should be enabled only for System Admin and Custodian)
        
            testExecObj.Approval_Status__c = 'Pending Approval';
           update testExecObj;
        
        
            Boolean approveChecksysOwner = testApprovalClass.getcheckApproveRejectButton();
            //System.assertEquals(approveChecksysOwner, true);
        

        // Negative Case Scenario (Button should not be enabled only for Business Quality and System Quality User)
        
            Boolean approveCheckSysQual = testApprovalClass.getcheckApproveRejectButton();
            System.assertEquals(approveCheck, false);
        

        //Setting the Test Page
        testApprovalClass.redirectToApprovalPage();
        PageReference pageRef = Page.TRAK_TestScriptApproval;
        Test.setCurrentPageReference(pageRef);

        
            testApprovalClass.approveUserStory();
            
        

        
        // User story should be approved
         System.assertEquals(true, testExecObj.Approval_Status__c == 'Approved');

        //cover catch blocks
        testExecObj.Approver__c=null;
        testExecObj.Approval_Status__c='Pending Approval';
        testApprovalClass.getcheckApproveRejectButton();
        testApprovalClass.recallApprovalRequest();
        testApprovalClass.approveUserStory();
        testApprovalClass.rejectUserStory();
        Test.StopTest();
    }

    static testMethod void testRejectionProcess() {
        setupTestData();

        ApexPages.StandardController controller = new ApexPages.StandardController(testExecObj);

        TRAK_TestScriptApprovalClass testRejectionClass = new TRAK_TestScriptApprovalClass(controller);

        Test.StartTest();
        
        
            testRejectionClass.rejectUserStory();
            
        
        
        System.assertEquals(true, testExecObj.Approval_Status__c == 'Rejected');
        Test.StopTest();
    }

}