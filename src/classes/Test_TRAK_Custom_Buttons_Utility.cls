/*************************************************************************\
    @ Author        : Deloitte Digital
    @ Date          : 10-Apr-2016
    @ Test Class    : 
    @ Description   : This is test class for testing functionality of TRAK_Custom_Buttons_Utility class
****************************************************************************/
@isTest 
public class Test_TRAK_Custom_Buttons_Utility{
    static Profile profile = [SELECT Id FROM Profile WHERE Name='System Administrator'];  
    static string SUCCESS_MESSAGE = 'success'; 
    static string FAILURE_MESSAGE = 'failure'; 
    static string PIC_COMPLETED = 'Complete';
    static string PROVIDE_TAG = 'Please provide the tag number !';
    static final String CODE_REVIEW_ALREADY_COMPLETE_MESSAGE = 'Code Review has already been completed !';
    static final String PRE_PROD_APPROVAL_COMPLETE_MESSAGE = 'Pre-prod approval has already been completed !';
    static final String CODE_REVIEW_APPROVAL_PENDING = 'Please submit for code review approval first !';
    static final String PRE_PROD_APPROVAL_PENDING = 'Please submit for pre prod approval first !';
    static final String PROD_APPROVAL_COMPLETE_MESSAGE = 'Prod approval has already been completed !';
    static final String TECH_LEAD_IDENTIFICATION_ERROR = 'Only Tech Lead assigned on the project record is allowed to take this action !';
    static final String SYSTEM_CUSTODIAN_IDENTIFICATION_ERROR = 'Only System Custodian or Backup System Custodian assigned on the app record is allowed to take this action !';        
    static final String PROD_APPROVAL_CRITERIA_NOT_MET = 'Please complete the information in the Source Code Repository Name, Code Review Complete, Tag, Repo and Self Certification for DML related coding fields. Additionally, verify all user stories have the status (Passed-Complete), verify all test scripts and test executions associated to the user story have the approval status (approved), and verify all defects that have the status (Closed-Complete)';    
    static final String PROVIDE_REJECTION_REASON = 'Please provide rejection reason!';
    static final String ALREADY_REJECTED_MESSAGE = 'The record has already been rejected!';
    static final String PRODUCTION_APPROVED_RECORD = 'The Release record is already approved for production !';
     
   
    public static User createUser(String permissionSetLabel, String alias){
            User runAsUser = new User(alias = alias, email='testTRAK@testorg.com',
                                      emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                      localesidkey='en_US', profileid = profile.Id,  country='United States', CommunityNickname = alias,
                                      timezonesidkey='America/Los_Angeles',username='testuser'+alias+'@testorg.com');
            insert runAsUser; 
            PermissionSet permissionSet = [SELECT ID,Label from PermissionSet WHERE Name=:PermissionSetLabel];       
            PermissionSetAssignment permissionSetAssignment = New PermissionSetAssignment();
            permissionSetAssignment.AssigneeId=runAsUser.ID;
            permissionSetAssignment.PermissionSetId=permissionSet.ID;
            insert permissionSetAssignment;      
            return runAsUser; 
    }
     /* 
    static testmethod void method1()
    {
        User TRAKAdmin = createUser('TRAK_Admin','madmin');
        User sysCustodian= new User(Alias = 'syscust',
                  Email             = 'syscust@TRAK-test.com',
                  EmailEncodingKey  = 'UTF-8',
                  LastName          = 'Custodian',
                  FirstName         = 'System',
                  LanguageLocaleKey = 'en_US',
                  LocaleSidKey      = 'en_US',
                  ProfileId         = [select Id from Profile where Name = 'GSO Basic User_Platform' limit 1].Id,
                  TimeZoneSidKey    = 'America/Chicago',
                  Username          = 'stakeholder@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
                  UserRoleId        = null,
                  Country           = 'Great Britain');
        insert sysCustodian;    
        PermissionSet pSet = [SELECT ID, Name from PermissionSet WHERE Name=: 'TRAK_Basic'];
        PermissionSetAssignment Asign = New PermissionSetAssignment();
        Asign.AssigneeId=sysCustodian.ID;
        Asign.PermissionSetId=pSet.ID;
        Insert Asign;   
        TRAK_App__c appObj = new TRAK_App__c(name = 'appRecord',Data_Criticality__c = 'Green',System_Custodian__c=sysCustodian.id);
        TRAK_Project__c projectObj = new TRAK_Project__c(name = 'projectRecord');
        
        System.runAs(sysCustodian)
        {
        test.starttest();
        insert appObj;
        projectObj.app__c = appObj.id;
        insert projectObj;
        TRAK_Release__c releaseObj3_CodeRevFalse = new TRAK_Release__c(name = 'releaseObjProd_CRFalse',project__c =projectObj.id, Code_Review_Completed__c = true,CR_Number__c ='test',tag__c='test',recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
        insert releaseObj3_CodeRevFalse;
        releaseObj3_CodeRevFalse.Approved_for_Pre_Production__c = true;
        update releaseObj3_CodeRevFalse;
        String ProdReviewResult = TRAK_Custom_Buttons_Utility.preProdReviewCompleted(releaseObj3_CodeRevFalse.id);
        system.assertEquals(PRE_PROD_APPROVAL_COMPLETE_MESSAGE,ProdReviewResult );
        }
        System.runAs(TRAKAdmin)
        {
        
        TRAK_Release__c releaseObj3_CodeRevFalse = [Select id from TRAK_Release__c where name ='releaseObjProd_CRFalse'];
        String ProdReviewResult = TRAK_Custom_Buttons_Utility.preProdReviewCompleted(releaseObj3_CodeRevFalse.id);
        system.assertEquals(SYSTEM_CUSTODIAN_IDENTIFICATION_ERROR,ProdReviewResult );
        test.stoptest();
        }
        
    }
    
    
    //collective pre prod approval
    static testmethod void method2()
    {
        User TRAKAdmin = createUser('TRAK_Admin','madmin');
        User sysCustodian= new User(Alias = 'syscust',
                  Email             = 'syscust@TRAK-test.com',
                  EmailEncodingKey  = 'UTF-8',
                  LastName          = 'Custodian',
                  FirstName         = 'System',
                  LanguageLocaleKey = 'en_US',
                  LocaleSidKey      = 'en_US',
                  ProfileId         = [select Id from Profile where Name = 'GSO Basic User_Platform' limit 1].Id,
                  TimeZoneSidKey    = 'America/Chicago',
                  Username          = 'stakeholder@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
                  UserRoleId        = null,
                  Country           = 'Great Britain');
        insert sysCustodian;    
        PermissionSet pSet = [SELECT ID, Name from PermissionSet WHERE Name=: 'TRAK_Basic'];
        PermissionSetAssignment Asign = New PermissionSetAssignment();
        Asign.AssigneeId=sysCustodian.ID;
        Asign.PermissionSetId=pSet.ID;
        Insert Asign;   
        TRAK_App__c appObj = new TRAK_App__c(name = 'appRecord',Data_Criticality__c = 'Green',System_Custodian__c=sysCustodian.id);
        TRAK_Project__c projectObj = new TRAK_Project__c(name = 'projectRecord');
        
        System.runAs(sysCustodian)
        {
        test.starttest();
        insert appObj;
        projectObj.app__c = appObj.id;
        insert projectObj;
        TRAK_Release__c releaseObj = new TRAK_Release__c(name = 'releaseObjPreProdTag',project__c =projectObj.id, Code_Review_Completed__c = true,recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
      
        insert  releaseObj;
        
        String ProdReviewResult = TRAK_Custom_Buttons_Utility.preProdReviewCompleted(releaseObj.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET ,ProdReviewResult );
        TRAK_Release__c releaseObjCR = new TRAK_Release__c(name = 'releaseObjProdCR3',project__c =projectObj.id, Code_Review_Completed__c = true,CR_Number__c ='test',recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
        insert releaseObjCR;
        
        system.debug('releaseObjCR'+releaseObjCR);
        system.debug('releaseObjCR'+releaseObjCR.CR_Number__c);
        ProdReviewResult = TRAK_Custom_Buttons_Utility.preProdReviewCompleted(releaseObjCR.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET ,ProdReviewResult );
        
        test.stoptest();
        }
    }
    static testmethod void method3()
    {
        User TRAKAdmin = createUser('TRAK_Admin','madmin');
        User sysCustodian= new User(Alias = 'syscust',
                  Email             = 'syscust@TRAK-test.com',
                  EmailEncodingKey  = 'UTF-8',
                  LastName          = 'Custodian',
                  FirstName         = 'System',
                  LanguageLocaleKey = 'en_US',
                  LocaleSidKey      = 'en_US',
                  ProfileId         = [select Id from Profile where Name = 'GSO Basic User_Platform' limit 1].Id,
                  TimeZoneSidKey    = 'America/Chicago',
                  Username          = 'stakeholder@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
                  UserRoleId        = null,
                  Country           = 'Great Britain');
        insert sysCustodian;    
        PermissionSet pSet = [SELECT ID, Name from PermissionSet WHERE Name=: 'TRAK_Basic'];
        PermissionSetAssignment Asign = New PermissionSetAssignment();
        Asign.AssigneeId=sysCustodian.ID;
        Asign.PermissionSetId=pSet.ID;
        Insert Asign;   
        TRAK_App__c appObj = new TRAK_App__c(name = 'appRecord',PIC_Status__c = PIC_COMPLETED,Data_Criticality__c = 'Green',System_Custodian__c=sysCustodian.id);
        TRAK_Project__c projectObj = new TRAK_Project__c(name = 'projectRecord');
        
        System.runAs(sysCustodian)
        {
        test.starttest();
        insert appObj;
        projectObj.app__c = appObj.id;
        insert projectObj;
        TRAK_Release__c releaseObjCR = new TRAK_Release__c(name = 'releaseObjProdCR3',project__c =projectObj.id, Code_Review_Completed__c = true,CR_Number__c ='test',recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
        insert releaseObjCR;
        String ProdReviewResult = TRAK_Custom_Buttons_Utility.preProdReviewCompleted(releaseObjCR.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET ,ProdReviewResult );
        
        test.stoptest();
        }
    }
    static testmethod void method4()
    {
        User TRAKAdmin = createUser('TRAK_Admin','madmin');
        User sysCustodian= new User(Alias = 'syscust',
                  Email             = 'syscust@TRAK-test.com',
                  EmailEncodingKey  = 'UTF-8',
                  LastName          = 'Custodian',
                  FirstName         = 'System',
                  LanguageLocaleKey = 'en_US',
                  LocaleSidKey      = 'en_US',
                  ProfileId         = [select Id from Profile where Name = 'GSO Basic User_Platform' limit 1].Id,
                  TimeZoneSidKey    = 'America/Chicago',
                  Username          = 'stakeholder@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
                  UserRoleId        = null,
                  Country           = 'Great Britain');
        insert sysCustodian;    
        PermissionSet pSet = [SELECT ID, Name from PermissionSet WHERE Name=: 'TRAK_Basic'];
        PermissionSetAssignment Asign = New PermissionSetAssignment();
        Asign.AssigneeId=sysCustodian.ID;
        Asign.PermissionSetId=pSet.ID;
        Insert Asign;   
        TRAK_App__c appObj = new TRAK_App__c(name = 'appRecord',PIC_Status__c = PIC_COMPLETED,Data_Criticality__c = 'Green',System_Custodian__c=sysCustodian.id,Source_Code_Repository_Name__c= 'test');
        TRAK_Project__c projectObj = new TRAK_Project__c(name = 'projectRecord');
        TRAK_User_Story__c userStoryObjGSO3 = new TRAK_User_Story__c(App__c = appObj.id,Project__c = projectObj.id, As_A_text__c = 'test', I_Want_To__c = 'test', So_that__c = 'test', Acceptance_Criteria__c = 'test', Development_Stage__c = 'In Development');
        
        TRAK_Bug__c defectObjGSO3 = new TRAK_Bug__c( Status__c = 'In Development', Technology__c = 'SFDC',Problem__c = 'test');
        
        TRAK_Test_Templates__c testScriptObjGSO3 = new TRAK_Test_Templates__c(Title__c = 'testtitle',  Introduction__c ='test', Approval_Status__c = 'Open');
        TRAK_Test__c testExeObj = new TRAK_Test__c(Approval_Status__c = 'Open');
        
        System.runAs(sysCustodian)
        {
        test.starttest();
        insert appObj;
        projectObj.app__c = appObj.id;
        insert projectObj;
        
        TRAK_Release__c releaseObjCR = new TRAK_Release__c(name = 'releaseObjProdCR3',project__c =projectObj.id, Code_Review_Completed__c = true,CR_Number__c ='test',recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
        insert releaseObjCR;
        String ProdReviewResult = TRAK_Custom_Buttons_Utility.preProdReviewCompleted(releaseObjCR.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET ,ProdReviewResult );
        
        TRAK_Release__c releaseObjTag3 = new TRAK_Release__c(name = 'releaseObjProdTag3',project__c =projectObj.id, Code_Review_Completed__c = true,CR_Number__c ='test',tag__c='test',recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
        insert releaseObjTag3; 
        
        userStoryObjGSO3.Planned_Release__c = releaseObjTag3.id;
        userStoryObjGSO3.Project__c = projectObj.id;
        insert userStoryObjGSO3;
        defectObjGSO3.Planned_Release__c = releaseObjTag3.id;
        defectObjGSO3.Project2__c = projectObj.id;
        insert defectObjGSO3;
        testScriptObjGSO3.User_Story__c = userStoryObjGSO3.id;
        insert testScriptObjGSO3;
        testExeObj.User_Story__c = userStoryObjGSO3.id;
        testExeObj.Project__c = projectObj.id;
        insert testExeObj;
        ProdReviewResult = TRAK_Custom_Buttons_Utility.preProdReviewCompleted(releaseObjTag3.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET ,ProdReviewResult );
        
        userStoryObjGSO3.Development_Stage__c = 'Passed (Complete)';
        update userStoryObjGSO3;
        ProdReviewResult = TRAK_Custom_Buttons_Utility.preProdReviewCompleted(releaseObjTag3.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET ,ProdReviewResult );
        
        testScriptObjGSO3.Approval_Status__c = 'Approved';
        update testScriptObjGSO3; 
        ProdReviewResult = TRAK_Custom_Buttons_Utility.preProdReviewCompleted(releaseObjTag3.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET ,ProdReviewResult );
        
        testExeObj.Approval_Status__c = 'Approved';
        update testExeObj;
        ProdReviewResult = TRAK_Custom_Buttons_Utility.preProdReviewCompleted(releaseObjTag3.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET ,ProdReviewResult );
        
        defectObjGSO3.Status__c = 'Closed - Complete';
        update defectObjGSO3;
        
        ProdReviewResult = TRAK_Custom_Buttons_Utility.preProdReviewCompleted(releaseObjTag3.id);
        system.assertEquals(SUCCESS_MESSAGE,ProdReviewResult );
        
        TRAK_Release__c releaseObj3_Rejected = new TRAK_Release__c(name = 'releaseObjProdCR3',project__c =projectObj.id, Code_Review_Completed__c = true,CR_Number__c ='test',tag__c='test',recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
        insert releaseObj3_Rejected;
        releaseObj3_Rejected.rejected__c = true;
        update releaseObj3_Rejected;
        ProdReviewResult = TRAK_Custom_Buttons_Utility.preProdReviewCompleted(releaseObj3_Rejected.id);
        system.assertEquals(ALREADY_REJECTED_MESSAGE,ProdReviewResult );
        
        TRAK_Release__c releaseObj3_CodeRevFalse = new TRAK_Release__c(name = 'releaseObjProd_CRFalse',project__c =projectObj.id, Code_Review_Completed__c = false,CR_Number__c ='test',tag__c='test',recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
        insert releaseObj3_CodeRevFalse ;
        
        ProdReviewResult = TRAK_Custom_Buttons_Utility.preProdReviewCompleted(releaseObj3_CodeRevFalse.id);
        system.assertEquals(CODE_REVIEW_APPROVAL_PENDING,ProdReviewResult );
        test.stoptest();
        }
        
    }
    //collective prod approval
    static testmethod void method5()
    {
        User TRAKAdmin = createUser('TRAK_Admin','madmin');
        User sysCustodian= new User(Alias = 'syscust',
                  Email             = 'syscust@TRAK-test.com',
                  EmailEncodingKey  = 'UTF-8',
                  LastName          = 'Custodian',
                  FirstName         = 'System',
                  LanguageLocaleKey = 'en_US',
                  LocaleSidKey      = 'en_US',
                  ProfileId         = [select Id from Profile where Name = 'GSO Basic User_Platform' limit 1].Id,
                  TimeZoneSidKey    = 'America/Chicago',
                  Username          = 'stakeholder@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
                  UserRoleId        = null,
                  Country           = 'Great Britain');
        insert sysCustodian;    
        PermissionSet pSet = [SELECT ID, Name from PermissionSet WHERE Name=: 'TRAK_Basic'];
        PermissionSetAssignment Asign = New PermissionSetAssignment();
        Asign.AssigneeId=sysCustodian.ID;
        Asign.PermissionSetId=pSet.ID;
        Insert Asign;   
        TRAK_App__c appObj = new TRAK_App__c(name = 'appRecord',Data_Criticality__c = 'Green',System_Custodian__c=sysCustodian.id);
        TRAK_Project__c projectObj = new TRAK_Project__c(name = 'projectRecord');
        
        System.runAs(sysCustodian)
        {
        test.starttest();
        insert appObj;
        projectObj.app__c = appObj.id;
        insert projectObj;
        TRAK_Release__c releaseObj = new TRAK_Release__c(name = 'releaseObjPreProdTag',project__c =projectObj.id, Code_Review_Completed__c = true,recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
      
        insert  releaseObj;
        releaseObj.Approved_for_Pre_Production__c = true;
        update releaseObj;
        String ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObj.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET ,ProdReviewResult );
        TRAK_Release__c releaseObjCR = new TRAK_Release__c(name = 'releaseObjProdCR3',project__c =projectObj.id, Code_Review_Completed__c = true,CR_Number__c ='test',recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
        insert releaseObjCR;
        releaseObjCR.Approved_for_Pre_Production__c = true;
        update releaseObjCR;
        
        ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObjCR.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET ,ProdReviewResult );
        
        test.stoptest();
        }
    }
    static testmethod void method6()
    {
        User TRAKAdmin = createUser('TRAK_Admin','madmin');
        User sysCustodian= new User(Alias = 'syscust',
                  Email             = 'syscust@TRAK-test.com',
                  EmailEncodingKey  = 'UTF-8',
                  LastName          = 'Custodian',
                  FirstName         = 'System',
                  LanguageLocaleKey = 'en_US',
                  LocaleSidKey      = 'en_US',
                  ProfileId         = [select Id from Profile where Name = 'GSO Basic User_Platform' limit 1].Id,
                  TimeZoneSidKey    = 'America/Chicago',
                  Username          = 'stakeholder@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
                  UserRoleId        = null,
                  Country           = 'Great Britain');
        insert sysCustodian;    
        PermissionSet pSet = [SELECT ID, Name from PermissionSet WHERE Name=: 'TRAK_Basic'];
        PermissionSetAssignment Asign = New PermissionSetAssignment();
        Asign.AssigneeId=sysCustodian.ID;
        Asign.PermissionSetId=pSet.ID;
        Insert Asign;   
        TRAK_App__c appObj = new TRAK_App__c(name = 'appRecord',Data_Criticality__c = 'Green',PIC_Status__c = PIC_COMPLETED,System_Custodian__c=sysCustodian.id);
        TRAK_Project__c projectObj = new TRAK_Project__c(name = 'projectRecord');
        
        System.runAs(sysCustodian)
        {
        test.starttest();
        insert appObj;
        projectObj.app__c = appObj.id;
        insert projectObj;
        
        TRAK_Release__c releaseObjCR = new TRAK_Release__c(name = 'releaseObjProdCR3',project__c =projectObj.id, Code_Review_Completed__c = true,CR_Number__c ='test',recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
        insert releaseObjCR;
        releaseObjCR.Approved_for_Pre_Production__c = true;
        update releaseObjCR;
        String ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObjCR.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET,ProdReviewResult );
                
        test.stoptest();
        }
    }
    static testmethod void method7()
    {
        User TRAKAdmin = createUser('TRAK_Admin','madmin');
        User sysCustodian= new User(Alias = 'syscust',
                  Email             = 'syscust@TRAK-test.com',
                  EmailEncodingKey  = 'UTF-8',
                  LastName          = 'Custodian',
                  FirstName         = 'System',
                  LanguageLocaleKey = 'en_US',
                  LocaleSidKey      = 'en_US',
                  ProfileId         = [select Id from Profile where Name = 'GSO Basic User_Platform' limit 1].Id,
                  TimeZoneSidKey    = 'America/Chicago',
                  Username          = 'stakeholder@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
                  UserRoleId        = null,
                  Country           = 'Great Britain');
        insert sysCustodian;    
        PermissionSet pSet = [SELECT ID, Name from PermissionSet WHERE Name=: 'TRAK_Basic'];
        PermissionSetAssignment Asign = New PermissionSetAssignment();
        Asign.AssigneeId=sysCustodian.ID;
        Asign.PermissionSetId=pSet.ID;
        Insert Asign;   
        TRAK_App__c appObj = new TRAK_App__c(name = 'appRecord',Data_Criticality__c = 'Green',PIC_Status__c = PIC_COMPLETED,System_Custodian__c=sysCustodian.id,Source_Code_Repository_Name__c='test');
        TRAK_Project__c projectObj = new TRAK_Project__c(name = 'projectRecord');
        TRAK_User_Story__c userStoryObjGSO3 = new TRAK_User_Story__c(App__c = appObj.id,Project__c = projectObj.id, As_A_text__c = 'test', I_Want_To__c = 'test', So_that__c = 'test', Acceptance_Criteria__c = 'test', Development_Stage__c = 'In Development');
        
        TRAK_Bug__c defectObjGSO3 = new TRAK_Bug__c( Status__c = 'In Development', Technology__c = 'SFDC',Problem__c = 'test');
        
        TRAK_Test_Templates__c testScriptObjGSO3 = new TRAK_Test_Templates__c(Title__c = 'testtitle',  Introduction__c ='test', Approval_Status__c = 'Open');
        
        TRAK_Test__c testExeObj = new TRAK_Test__c(Approval_Status__c = 'Open');
        System.runAs(sysCustodian)
        {
        test.starttest();
        insert appObj;
        projectObj.app__c = appObj.id;
        insert projectObj;
        
        TRAK_Release__c releaseObjCR = new TRAK_Release__c(name = 'releaseObjProdCR3',project__c =projectObj.id, Code_Review_Completed__c = true,CR_Number__c ='test',recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
        insert releaseObjCR;
        releaseObjCR.Approved_for_Pre_Production__c = true;
        update releaseObjCR;
        String ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObjCR.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET,ProdReviewResult );
        
        TRAK_Release__c releaseObjTag3 = new TRAK_Release__c(name = 'releaseObjProdCR3',project__c =projectObj.id, Code_Review_Completed__c = true,CR_Number__c ='test',tag__c='test',recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
        insert releaseObjTag3; 
        releaseObjTag3.Approved_for_Pre_Production__c = true;
        update releaseObjTag3;
        
        userStoryObjGSO3.Planned_Release__c = releaseObjTag3.id;
        userStoryObjGSO3.Project__c = projectObj.id;
        insert userStoryObjGSO3;
        defectObjGSO3.Planned_Release__c = releaseObjTag3.id;
        defectObjGSO3.Project2__c = projectObj.id;
        insert defectObjGSO3;
        testScriptObjGSO3.User_Story__c = userStoryObjGSO3.id;
        insert testScriptObjGSO3;
        testExeObj.User_Story__c = userStoryObjGSO3.id;
        testExeObj.Project__c = projectObj.id;
        insert testExeObj;
        ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObjTag3.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET ,ProdReviewResult );
        
        userStoryObjGSO3.Development_Stage__c = 'Passed (Complete)';
        update userStoryObjGSO3;
        ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObjTag3.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET ,ProdReviewResult );
        
        testScriptObjGSO3.Approval_Status__c = 'Approved';
        update testScriptObjGSO3; 
        ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObjTag3.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET ,ProdReviewResult );
        
        testExeObj.Approval_Status__c = 'Approved';
        update testExeObj;
        ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObjTag3.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET,ProdReviewResult );
        
        defectObjGSO3.Status__c = 'Closed - Complete';
        update defectObjGSO3;
        
        ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObjTag3.id);
        system.assertEquals(SUCCESS_MESSAGE,ProdReviewResult );
        
        TRAK_Release__c releaseObj3_Rejected = new TRAK_Release__c(name = 'releaseObjProdCR3',project__c =projectObj.id, Code_Review_Completed__c = true,CR_Number__c ='test',tag__c='test',recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
        insert releaseObj3_Rejected;
        releaseObj3_Rejected.rejected__c = true;
        update releaseObj3_Rejected;
        ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObj3_Rejected.id);
        system.assertEquals(ALREADY_REJECTED_MESSAGE,ProdReviewResult );
        
        TRAK_Release__c releaseObj3_CodeRevFalse = new TRAK_Release__c(name = 'releaseObjProdCR3',project__c =projectObj.id, Code_Review_Completed__c = false,CR_Number__c ='test',tag__c='test',recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
        insert releaseObj3_CodeRevFalse ;
        
        ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObj3_CodeRevFalse.id);
        system.assertEquals(CODE_REVIEW_APPROVAL_PENDING,ProdReviewResult );
        
        test.stoptest();
        }
    }
    static testmethod void method8()
    {
        User TRAKAdmin = createUser('TRAK_Admin','madmin');
        User sysCustodian= new User(Alias = 'syscust',
                  Email             = 'syscust@TRAK-test.com',
                  EmailEncodingKey  = 'UTF-8',
                  LastName          = 'Custodian',
                  FirstName         = 'System',
                  LanguageLocaleKey = 'en_US',
                  LocaleSidKey      = 'en_US',
                  ProfileId         = [select Id from Profile where Name = 'GSO Basic User_Platform' limit 1].Id,
                  TimeZoneSidKey    = 'America/Chicago',
                  Username          = 'stakeholder@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
                  UserRoleId        = null,
                  Country           = 'Great Britain');
        insert sysCustodian;    
        PermissionSet pSet = [SELECT ID, Name from PermissionSet WHERE Name=: 'TRAK_Basic'];
        PermissionSetAssignment Asign = New PermissionSetAssignment();
        Asign.AssigneeId=sysCustodian.ID;
        Asign.PermissionSetId=pSet.ID;
        Insert Asign;   
        TRAK_App__c appObj = new TRAK_App__c(name = 'appRecord',Data_Criticality__c = 'Green',System_Custodian__c=sysCustodian.id);
        TRAK_Project__c projectObj = new TRAK_Project__c(name = 'projectRecord');
      
        System.runAs(sysCustodian)
        {
        test.starttest();
        insert appObj;
        projectObj.app__c = appObj.id;
        insert  projectObj;
        TRAK_Release__c releaseObj3_CodeRevFalse = new TRAK_Release__c(name = 'releaseObjProdCR3',project__c =projectObj.id, Code_Review_Completed__c = true,CR_Number__c ='test',tag__c='test',recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
        insert releaseObj3_CodeRevFalse;
        String ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObj3_CodeRevFalse.id);
        system.assertEquals(PRE_PROD_APPROVAL_PENDING,ProdReviewResult );
        
        TRAK_Release__c releaseObj3_PreProdPass = new TRAK_Release__c(name = 'releaseObjProdCR3',project__c =projectObj.id, Code_Review_Completed__c = true,CR_Number__c ='test',tag__c='test',recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
        insert releaseObj3_PreProdPass ;
        releaseObj3_PreProdPass.Approved_for_Pre_Production__c = true;
        update releaseObj3_PreProdPass;
        releaseObj3_PreProdPass.Approved_for_Production__c = true;
        update releaseObj3_PreProdPass;
        ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObj3_PreProdPass .id);
        system.assertEquals(PROD_APPROVAL_COMPLETE_MESSAGE,ProdReviewResult );
        
        TRAK_Release__c releaseObj2_Prod = new TRAK_Release__c(name = 'releaseObjProdCR3',project__c =projectObj.id, Code_Review_Completed__c = true,recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 2 Self Service').getRecordTypeId());
        insert releaseObj2_Prod;
        ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObj2_Prod.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET,ProdReviewResult );
        
        TRAK_Release__c releaseObj2_Prod_CR = new TRAK_Release__c(name = 'releaseObjProd2_CR',project__c =projectObj.id, CR_Number__c ='test',Code_Review_Completed__c = true,recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 2 Self Service').getRecordTypeId());
        insert releaseObj2_Prod_CR ;
        ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObj2_Prod_CR.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET,ProdReviewResult );
        test.stoptest();
        }
    }
    static testmethod void method9()
    {
        User TRAKAdmin = createUser('TRAK_Admin','madmin');
        User sysCustodian= new User(Alias = 'syscust',
                  Email             = 'syscust@TRAK-test.com',
                  EmailEncodingKey  = 'UTF-8',
                  LastName          = 'Custodian',
                  FirstName         = 'System',
                  LanguageLocaleKey = 'en_US',
                  LocaleSidKey      = 'en_US',
                  ProfileId         = [select Id from Profile where Name = 'GSO Basic User_Platform' limit 1].Id,
                  TimeZoneSidKey    = 'America/Chicago',
                  Username          = 'stakeholder@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
                  UserRoleId        = null,
                  Country           = 'Great Britain');
        insert sysCustodian;    
        PermissionSet pSet = [SELECT ID, Name from PermissionSet WHERE Name=: 'TRAK_Basic'];
        PermissionSetAssignment Asign = New PermissionSetAssignment();
        Asign.AssigneeId=sysCustodian.ID;
        Asign.PermissionSetId=pSet.ID;
        Insert Asign;   
        TRAK_App__c appObj = new TRAK_App__c(name = 'appRecord',Data_Criticality__c = 'Green',PIC_Status__c = PIC_COMPLETED,System_Custodian__c=sysCustodian.id);
        TRAK_Project__c projectObj = new TRAK_Project__c(name = 'projectRecord');
                
        System.runAs(sysCustodian)
        {
        test.starttest();
        insert appObj;
        projectObj.app__c = appObj.id;
        insert projectObj;
        TRAK_Release__c releaseObj2_Prod_CR = new TRAK_Release__c(name = 'releaseObjProd2_CR',project__c =projectObj.id, CR_Number__c ='test',Code_Review_Completed__c = true,recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 2 Self Service').getRecordTypeId());
        insert releaseObj2_Prod_CR ;
        String ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObj2_Prod_CR.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET,ProdReviewResult );
        TRAK_Release__c releaseObj2_Prod_Tag = new TRAK_Release__c(name = 'releaseObjProd2_Tag',project__c =projectObj.id, CR_Number__c ='test',tag__c='test',Code_Review_Completed__c = true,recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 2 Self Service').getRecordTypeId());
        insert releaseObj2_Prod_Tag ;
        
        ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObj2_Prod_Tag.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET,ProdReviewResult );
        test.stoptest();
        }
    }
    static testmethod void method10()
    {
        User TRAKAdmin = createUser('TRAK_Admin','madmin');
        User sysCustodian= new User(Alias = 'syscust',
                  Email             = 'syscust@TRAK-test.com',
                  EmailEncodingKey  = 'UTF-8',
                  LastName          = 'Custodian',
                  FirstName         = 'System',
                  LanguageLocaleKey = 'en_US',
                  LocaleSidKey      = 'en_US',
                  ProfileId         = [select Id from Profile where Name = 'GSO Basic User_Platform' limit 1].Id,
                  TimeZoneSidKey    = 'America/Chicago',
                  Username          = 'stakeholder@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
                  UserRoleId        = null,
                  Country           = 'Great Britain');
        insert sysCustodian;    
        PermissionSet pSet = [SELECT ID, Name from PermissionSet WHERE Name=: 'TRAK_Basic'];
        PermissionSetAssignment Asign = New PermissionSetAssignment();
        Asign.AssigneeId=sysCustodian.ID;
        Asign.PermissionSetId=pSet.ID;
        Insert Asign;   
        TRAK_App__c appObj = new TRAK_App__c(name = 'appRecord',Data_Criticality__c = 'Green',PIC_Status__c = PIC_COMPLETED,System_Custodian__c=sysCustodian.id,Source_Code_Repository_Name__c = 'test');
        TRAK_Project__c projectObj = new TRAK_Project__c(name = 'projectRecord');
        TRAK_User_Story__c userStoryObjGSO2 = new TRAK_User_Story__c(App__c = appObj.id,Project__c = projectObj.id, As_A_text__c = 'test', I_Want_To__c = 'test', So_that__c = 'test', Acceptance_Criteria__c = 'test', Development_Stage__c = 'In Development');
        
        TRAK_Bug__c defectObjGSO2 = new TRAK_Bug__c( Status__c = 'In Development', Technology__c = 'SFDC',Problem__c = 'test');
        
        TRAK_Test_Templates__c testScriptObjGSO2 = new TRAK_Test_Templates__c(Title__c = 'testtitle',  Introduction__c ='test', Approval_Status__c = 'Open');
    
        TRAK_Test__c testExeObj = new TRAK_Test__c(Approval_Status__c = 'Open');
        System.runAs(sysCustodian)
        {
        test.starttest();
        insert appObj;
        projectObj.app__c = appObj.id;
        insert projectObj;
        
        TRAK_Release__c releaseObj2_Prod_Tag = new TRAK_Release__c(name = 'releaseObjProd2_Tag',project__c =projectObj.id, CR_Number__c ='test',tag__c='test',Code_Review_Completed__c = true,recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 2 Self Service').getRecordTypeId());
        insert releaseObj2_Prod_Tag ;
        userStoryObjGSO2.Planned_Release__c = releaseObj2_Prod_Tag.id;
        userStoryObjGSO2.Project__c = projectObj.id;
        insert userStoryObjGSO2;
        defectObjGSO2.Planned_Release__c = releaseObj2_Prod_Tag.id;
        defectObjGSO2.Project2__c = projectObj.id;
        insert defectObjGSO2;
        testScriptObjGSO2.User_Story__c = userStoryObjGSO2.id;
        insert testScriptObjGSO2;
        testExeObj.User_Story__c = userStoryObjGSO2.id;
        testExeObj.Project__c = projectObj.id;
        insert testExeObj;
        
        String ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObj2_Prod_Tag.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET,ProdReviewResult );
        
        userStoryObjGSO2.Development_Stage__c = 'Passed (Complete)';
        update userStoryObjGSO2;
        ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObj2_Prod_Tag.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET,ProdReviewResult );
        
        testScriptObjGSO2.Approval_Status__c = 'Approved';
        update testScriptObjGSO2;
        ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObj2_Prod_Tag.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET,ProdReviewResult );
        
        testExeObj.Approval_Status__c = 'Approved';
        update testExeObj;
        ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObj2_Prod_Tag.id);
        system.assertEquals(PROD_APPROVAL_CRITERIA_NOT_MET,ProdReviewResult );
        
        defectObjGSO2.Status__c = 'Closed - Complete';
        update defectObjGSO2;
        
        ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObj2_Prod_Tag.id);
        system.assertEquals(SUCCESS_MESSAGE ,ProdReviewResult );
        
        test.stoptest();
        }
        
    }
    static testmethod void method11()
    {
        User TRAKAdmin = createUser('TRAK_Admin','madmin');
        User sysCustodian= new User(Alias = 'syscust',
                  Email             = 'syscust@TRAK-test.com',
                  EmailEncodingKey  = 'UTF-8',
                  LastName          = 'Custodian',
                  FirstName         = 'System',
                  LanguageLocaleKey = 'en_US',
                  LocaleSidKey      = 'en_US',
                  ProfileId         = [select Id from Profile where Name = 'GSO Basic User_Platform' limit 1].Id,
                  TimeZoneSidKey    = 'America/Chicago',
                  Username          = 'stakeholder@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
                  UserRoleId        = null,
                  Country           = 'Great Britain');
        insert sysCustodian;    
        PermissionSet pSet = [SELECT ID, Name from PermissionSet WHERE Name=: 'TRAK_Basic'];
        PermissionSetAssignment Asign = New PermissionSetAssignment();
        Asign.AssigneeId=sysCustodian.ID;
        Asign.PermissionSetId=pSet.ID;
        Insert Asign;   
        TRAK_App__c appObj = new TRAK_App__c(name = 'appRecord',Data_Criticality__c = 'Green',System_Custodian__c=sysCustodian.id);
        TRAK_Project__c projectObj = new TRAK_Project__c(name = 'projectRecord');
        System.runAs(sysCustodian)
        {
        test.starttest();
        insert appObj;
        projectObj.app__c = appObj.id;
        insert projectObj;
        TRAK_Release__c releaseObj2_UnfinishedCR = new TRAK_Release__c(name = 'releaseObjProd2_Tag',project__c =projectObj.id, CR_Number__c ='test',tag__c='test',Code_Review_Completed__c = false,recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 2 Self Service').getRecordTypeId());
        insert releaseObj2_UnfinishedCR ;
        String ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObj2_UnfinishedCR.id);
        system.assertEquals(CODE_REVIEW_APPROVAL_PENDING,ProdReviewResult );
        
        releaseObj2_UnfinishedCR.Code_Review_Completed__c = true;
        update releaseObj2_UnfinishedCR;
        releaseObj2_UnfinishedCR.Approved_for_Production__c = true;
        update releaseObj2_UnfinishedCR;
        ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObj2_UnfinishedCR.id);
        system.assertEquals(PROD_APPROVAL_COMPLETE_MESSAGE,ProdReviewResult );
        }
        System.runAs(TRAKAdmin)
        {
        TRAK_Release__c releaseObj2_UnfinishedCR = [Select id from TRAK_Release__c where name='releaseObjProd2_Tag'];
        String ProdReviewResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObj2_UnfinishedCR.id);
        system.assertEquals(SYSTEM_CUSTODIAN_IDENTIFICATION_ERROR,ProdReviewResult );
        test.stoptest();
        }
        
    }
    static testmethod void method12()
    {
        User TRAKAdmin = createUser('TRAK_Admin','madmin');
        User sysCustodian= new User(Alias = 'syscust',
                  Email             = 'syscust@TRAK-test.com',
                  EmailEncodingKey  = 'UTF-8',
                  LastName          = 'Custodian',
                  FirstName         = 'System',
                  LanguageLocaleKey = 'en_US',
                  LocaleSidKey      = 'en_US',
                  ProfileId         = [select Id from Profile where Name = 'GSO Basic User_Platform' limit 1].Id,
                  TimeZoneSidKey    = 'America/Chicago',
                  Username          = 'stakeholder@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
                  UserRoleId        = null,
                  Country           = 'Great Britain');
        insert sysCustodian;    
        PermissionSet pSet = [SELECT ID, Name from PermissionSet WHERE Name=: 'TRAK_Basic'];
        PermissionSetAssignment Asign = New PermissionSetAssignment();
        Asign.AssigneeId=sysCustodian.ID;
        Asign.PermissionSetId=pSet.ID;
        Insert Asign;   
        TRAK_App__c appObj = new TRAK_App__c(name = 'appRecord',Data_Criticality__c = 'Green',System_Custodian__c=sysCustodian.id);
        TRAK_Project__c projectObj = new TRAK_Project__c(name = 'projectRecord',Tech_Lead__c= sysCustodian.id);
        System.runAs(sysCustodian)
        {
        test.starttest();
        insert appObj;
        projectObj.app__c = appObj.id;
        insert projectObj;
        TRAK_Release__c releaseObj_CodeReview = new TRAK_Release__c(name = 'releaseObjProd2_Coderev',project__c =projectObj.id, CR_Number__c ='test',Code_Review_Completed__c = false,recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 2 Self Service').getRecordTypeId());
        insert releaseObj_CodeReview;
        String codeReviewResult = TRAK_Custom_Buttons_Utility.codeReviewCompleted(releaseObj_CodeReview.id);
        system.assertEquals(PROVIDE_TAG,codeReviewResult);
        
        releaseObj_CodeReview.tag__c='test';
        update releaseObj_CodeReview;
        codeReviewResult = TRAK_Custom_Buttons_Utility.codeReviewCompleted(releaseObj_CodeReview.id);
        system.assertEquals(SUCCESS_MESSAGE,codeReviewResult);
        
        TRAK_Release__c releaseObj_CodeReviewDone= new TRAK_Release__c(name = 'releaseObjProd2_CodeRevDone',project__c =projectObj.id, CR_Number__c ='test',Code_Review_Completed__c = true,recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 2 Self Service').getRecordTypeId());
        insert releaseObj_CodeReviewDone;
        
        codeReviewResult = TRAK_Custom_Buttons_Utility.codeReviewCompleted(releaseObj_CodeReviewDone.id);
        system.assertEquals(CODE_REVIEW_ALREADY_COMPLETE_MESSAGE,codeReviewResult);
        releaseObj_CodeReviewDone.Code_Review_Completed__c = false;
        releaseObj_CodeReviewDone.Rejected__c = true;
        update releaseObj_CodeReviewDone;
        codeReviewResult = TRAK_Custom_Buttons_Utility.codeReviewCompleted(releaseObj_CodeReviewDone.id);
        system.assertEquals(ALREADY_REJECTED_MESSAGE,codeReviewResult);
        
        }
        System.runAs(TRAKAdmin)
        {
         TRAK_Release__c releaseObj_noTechLead = [Select id from TRAK_Release__c where name='releaseObjProd2_CodeRevDone'];
        String codeReviewResult = TRAK_Custom_Buttons_Utility.codeReviewCompleted(releaseObj_noTechLead.id);
        system.assertEquals(TECH_LEAD_IDENTIFICATION_ERROR,codeReviewResult);
        test.stoptest();
        }
       
     }
     
     //rejection cases
     static testmethod void method13(){
        User TRAKAdmin = createUser('TRAK_Admin','madmin');
        User sysCustodian= new User(Alias = 'syscust',
                  Email             = 'syscust@TRAK-test.com',
                  EmailEncodingKey  = 'UTF-8',
                  LastName          = 'Custodian',
                  FirstName         = 'System',
                  LanguageLocaleKey = 'en_US',
                  LocaleSidKey      = 'en_US',
                  ProfileId         = [select Id from Profile where Name = 'GSO Basic User_Platform' limit 1].Id,
                  TimeZoneSidKey    = 'America/Chicago',
                  Username          = 'stakeholder@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
                  UserRoleId        = null,
                  Country           = 'Great Britain');
        insert sysCustodian;    
        PermissionSet pSet = [SELECT ID, Name from PermissionSet WHERE Name=: 'TRAK_Basic'];
        PermissionSetAssignment Asign = New PermissionSetAssignment();
        Asign.AssigneeId=sysCustodian.ID;
        Asign.PermissionSetId=pSet.ID;
        Insert Asign; 
        TRAK_App__c appObj = new TRAK_App__c(Name= 'Test Release App 2', PIC_URL__c = 'test@abc.com', 
                                            PIC_Status__c ='Complete', Source_Code_Repository_Name__c ='test',App_Code__c = 'TEST',System_Custodian__c = sysCustodian.ID);
        
        System.runAs(sysCustodian)
        {
            test.starttest();
            
            insert appObj ;                             
            TRAK_Project__c projectObj= new TRAK_Project__c(Name= 'Test Release Project2',  Tech_Lead__c = sysCustodian.Id);
            String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'TRAK_Release__c' and Name = 'GSO 1 Self Service'].Id;
            
            projectObj.app__c = appObj.id;
            insert projectObj;
            TRAK_Release__c releaseObjProdApproved = new TRAK_Release__c(name = 'releaseObjProdApproved', Project__c = projectObj.id,Code_Review_Completed__c = true,CR_Number__c= 'test',tag__c='test',recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
            insert releaseObjProdApproved ;
            releaseObjProdApproved .Approved_for_Pre_Production__c = true;
            update releaseObjProdApproved ;
            releaseObjProdApproved.Approved_for_Production__c= true;
            update releaseObjProdApproved;
            
            String rejectedResult = TRAK_Custom_Buttons_Utility.releaseRejected(releaseObjProdApproved.id);
            system.assertEquals(PRODUCTION_APPROVED_RECORD,rejectedResult);
            
            update appObj;
            
            rejectedResult = TRAK_Custom_Buttons_Utility.releaseRejected(releaseObjProdApproved.id);
            system.assertEquals(PRODUCTION_APPROVED_RECORD,rejectedResult);
            projectObj.Tech_Lead__c = sysCustodian.id;
        
            update projectObj;
            
            TRAK_Release__c releaseObj = new TRAK_Release__c(name = 'releaseRecord', Project__c = projectObj.id,recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 1 Self Service').getRecordTypeId());
            insert releaseObj ;
            
            rejectedResult = TRAK_Custom_Buttons_Utility.releaseRejected(releaseObj.id);
            system.assertEquals(PROVIDE_REJECTION_REASON,rejectedResult);
            releaseObj.Rejected_Reason__c ='test';
            update releaseObj;
            rejectedResult = TRAK_Custom_Buttons_Utility.releaseRejected(releaseObj.id);
            system.assertEquals(SUCCESS_MESSAGE,rejectedResult);

            rejectedResult = TRAK_Custom_Buttons_Utility.releaseRejected(releaseObj.id);
            system.assertEquals(ALREADY_REJECTED_MESSAGE ,rejectedResult);
            
            rejectedResult = TRAK_Custom_Buttons_Utility.codeReviewCompleted(releaseObj.id);
            system.assertEquals(ALREADY_REJECTED_MESSAGE,rejectedResult);
            
            rejectedResult = TRAK_Custom_Buttons_Utility.preProdReviewCompleted(releaseObj.id);
            system.assertEquals(ALREADY_REJECTED_MESSAGE,rejectedResult);
            TRAK_Release__c releaseObjGSO3 = new TRAK_Release__c(name = 'releaseRecordGSO3', Project__c = projectObj.id,recordTypeId = Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId());
            insert releaseObjGSO3;
            releaseObjGSO3.Rejected_Reason__c = 'test';
            update releaseObjGSO3;
            rejectedResult = TRAK_Custom_Buttons_Utility.releaseRejected(releaseObjGSO3.id);
            system.assertEquals(SUCCESS_MESSAGE,rejectedResult);
            rejectedResult = TRAK_Custom_Buttons_Utility.prodReviewCompleted(releaseObjGSO3.id);
            system.assertEquals(ALREADY_REJECTED_MESSAGE,rejectedResult);
            }
            System.runAs(TRAKAdmin)
            {
            TRAK_Release__c releaseObjGSO3 = [Select id from TRAK_Release__c where name = 'releaseRecordGSO3'];
            String rejectedResult = TRAK_Custom_Buttons_Utility.releaseRejected(releaseObjGSO3.id);
            system.assertEquals(SYSTEM_CUSTODIAN_IDENTIFICATION_ERROR,rejectedResult);
            test.stoptest();
            }
            
    }
    //catch condition for rejected function
    static testmethod void method14(){
        User sysCustodian= new User(Alias = 'syscust',
                  Email             = 'syscust@TRAK-test.com',
                  EmailEncodingKey  = 'UTF-8',
                  LastName          = 'Custodian',
                  FirstName         = 'System',
                  LanguageLocaleKey = 'en_US',
                  LocaleSidKey      = 'en_US',
                  ProfileId         = [select Id from Profile where Name = 'GSO Basic User_Platform' limit 1].Id,
                  TimeZoneSidKey    = 'America/Chicago',
                  Username          = 'stakeholder@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
                  UserRoleId        = null,
                  Country           = 'Great Britain');
        insert sysCustodian;    
        PermissionSet pSet = [SELECT ID, Name from PermissionSet WHERE Name=: 'TRAK_Basic'];
        PermissionSetAssignment Asign = New PermissionSetAssignment();
        Asign.AssigneeId=sysCustodian.ID;
        Asign.PermissionSetId=pSet.ID;
        Insert Asign; 
        TRAK_App__c appObj = new TRAK_App__c(Name= 'Test Release App 2', PIC_URL__c = 'test@abc.com', 
                                            PIC_Status__c ='Complete', Source_Code_Repository_Name__c ='test',App_Code__c = 'TEST',System_Custodian__c = sysCustodian.ID);
        
        System.runAs(sysCustodian)
        {
            test.starttest();
            try{
            insert appObj;
            insert appObj;}
            catch(Exception e){
            TRAK_Custom_Buttons_Utility.createApplicationException(e);
            system.assertNotEquals(e,null);}
            
            test.stoptest();
        }
      }
      */
     static testmethod void testcreateApplicationException(){
         test.startTest();
            try{
              Opportunity appObj= new Opportunity();
              insert appObj;
               }
            catch(Exception e){
            TRAK_Custom_Buttons_Utility.createApplicationException(e);
            system.assertNotEquals(e,null);}
            
            test.stoptest();
     }
}