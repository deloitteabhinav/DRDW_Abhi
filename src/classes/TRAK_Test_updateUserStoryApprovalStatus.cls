@isTest(seeAllData=false)
global class TRAK_Test_updateUserStoryApprovalStatus{
/*
static TRAK_User_Story_Approval_History__c usHistObj=new TRAK_User_Story_Approval_History__c();
static TRAK_User_Story_Approval_History__c usHistObj2=new TRAK_User_Story_Approval_History__c();
static TRAK_User_Story__c userStoryLink=new TRAK_User_Story__c();
static TRAK_App__c app=new TRAK_App__c();
public static void createTestData(){
TRAK_Project__c proj=new TRAK_Project__c();
    User userObj=TRAK_Test_User_Story_Link_Trigger.createUser();
    app.Name='Test';
    insert app;
    
    proj.Name='Test';
    insert proj;
    
    userStoryLink.App__c=app.id;
    userStoryLink.Project__c=proj.id;
    userStoryLink.As_A_text__c='test';
    userStoryLink.So_that__c='test';
    userStoryLink.I_Want_To__c='test';
    userStoryLink.Acceptance_Criteria__c='test';
    
    userStoryLink.GXP__c='No';
    userStoryLink.Critical__c='No';
    
    usHistObj.System_Custodian__c=userObj.id;
    //usHistObj.Submitter__c=userObj.id;
    usHistObj.Computer_Systems_Quality__c=userObj.id;
    usHistObj.Business_Quality__c=userObj.id;
    usHistObj.System_Owner__c=userObj.id;
    
    userStoryLink.Approval_Status__c='Pending Approval';
    insert userStoryLink;
    usHistObj.User_Story__c=userStoryLink.id;
    usHistObj.Approval_Status__c='Pending Approval';
    insert usHistObj;
    usHistObj2.User_Story__c=userStoryLink.id;
    usHistObj2.Approval_Status__c='Open';
    insert usHistObj2;
    
    usHistObj2.Approval_Status__c='Pending Approval';
    usHistObj2.System_Custodian_Approved__c=true;
    usHistObj2.System_Owner_Approved__c=true;
    usHistObj2.Business_Quality_Approved__c=true;
    usHistObj2.Computer_Systems_Quality_Approved__c=true;
    update usHistObj2;
    
    

    }


static testMethod void Test_createTestData() {
        
    // Insertion of Test Data
        User runAsUserDataLoad = TRAK_Test_User_Story_Link_Trigger.createUser();
        System.runas(runAsUserDataLoad){ 
            createTestData();
            List<ProcessInstance> processInstances = [select Id, Status from ProcessInstance where TargetObjectId = :usHistObj.id];
            System.assertEquals(processInstances.size(),1);
        //  System.assertEquals(userStoryLink.Approval_Status__c,'Pending Approval');
            TRAK_User_Story_Approval_History__c usHistObj5=new TRAK_User_Story_Approval_History__c();
            usHistObj5.Approval_Status__c='Pending Approval';
            usHistObj5.System_Custodian_Approved__c=true;
            usHistObj5.System_Owner_Approved__c=true;
            usHistObj5.Business_Quality_Approved__c=true;
            usHistObj5.Computer_Systems_Quality_Approved__c=true;
            List<TRAK_User_Story_Approval_History__c> TRAKlst=new List<TRAK_User_Story_Approval_History__c>();
            TRAKlst.add(usHistObj5);
            TRAK_updateUserStoryApprovalStatus.updateUserStoryApprovalStatusMethod(TRAKlst);
     } 
        
}   */
}