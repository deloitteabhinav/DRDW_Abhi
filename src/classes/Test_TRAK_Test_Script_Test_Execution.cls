@isTest
private class Test_TRAK_Test_Script_Test_Execution {
 /* 
    static testMethod void testScriptTriggerClass() {
      
        //set up the pre-requisite data
        /*TRAK_App__c app = new TRAK_App__c();
        app.Name = 'TRAK2';
        insert app;
        */
        /*
        TRAK_Project__c project = new TRAK_Project__c();
        project.Name = 'TRAKSprints2';
        insert project;
         
        TRAK_User_Story__c userstory = new TRAK_User_Story__c(
            I_Want_To__c            = 'Test-Description-User-Stroy',
            Acceptance_Criteria__c  = 'Test-Acceptance-Criteria',
            Story_Points__c         = '13',
            Story_Points_Other__c   = '13',
            Development_Stage__c    = 'Backlog' ,
            Priority__c             = 0,
            Project__c              = project.Id);
        insert userstory;
        
        //insert approver
        User approver = new User(
            Alias             = 'aprvr1',
            Email             = 'approver@TRAK-testscript.com',
            EmailEncodingKey  = 'UTF-8',
            LastName          = 'User',
            FirstName         = 'Approver',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey      = 'en_US',
            ProfileId         = [select Id from Profile where Name = 'GLBL_Chatter Only' limit 1].Id,
            TimeZoneSidKey    = 'America/Chicago',
            Username          = 'stakeholder@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
            UserRoleId        = null,
            Country           = 'Great Britain');
        insert approver;
        
        TRAK_test_templates__c testExec = new TRAK_Test_templates__c(
            user_story__c      = userstory.Id,
            Title__c           = 'My test template title',
            Introduction__c    = 'My test template introduction',
            Approver__c        = approver.Id,
            Approval_Status__c = 'Open');
        insert testExec;
        
        Test.StartTest();
            testExec.Approval_Status__c = 'Pending Approval';
            update testExec;
            testExec.Approval_Status__c = 'Approved';
            update testExec;
            
            TRAK_Test_Template_History__c tsh = [SELECT Id, Approval_Status__c FROM TRAK_Test_Template_History__c WHERE Test_Script__c = :testExec.Id ORDER BY LastModifiedDate DESC LIMIT 1];
            System.AssertEquals(testExec.Approval_Status__c,tsh.Approval_Status__c);
            
            testExec.Approval_Status__c = 'Pending Approval';
            update testExec;
            testExec.Approval_Status__c = 'Rejected';
            update testExec;
        Test.StopTest();
    }
    
    
    
    static testMethod void testExecutionTriggerClass() {
      
        //set up the pre-requisite data
        /*TRAK_App__c app = new TRAK_App__c();
        app.Name = 'TRAK3';
        insert app;*/
        /*
        TRAK_Project__c project = new TRAK_Project__c();
        project.Name = 'TRAKSprints3';
        insert project;
        
        TRAK_Sprint__c sprint = new TRAK_Sprint__c();
        sprint.Project__c = project.Id;
        insert sprint;
         
        TRAK_User_Story__c userstory = new TRAK_User_Story__c(
            I_Want_To__c            = 'Test-Description-User-Story',
            Acceptance_Criteria__c  = 'Test-Acceptance-Criteria3',
            Story_Points__c         = '13',
            Story_Points_Other__c   = '13',
            Development_Stage__c    = 'Backlog' ,
            Priority__c             = 0,
            Project__c              = project.Id);
        insert userstory;
        
        //insert approver
        User approver = new User(
            Alias             = 'aprvr2',
            Email             = 'approver@TRAK-testexec.com',
            EmailEncodingKey  = 'UTF-8',
            LastName          = 'User',
            FirstName         = 'Approver',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey      = 'en_US',
            ProfileId         = [select Id from Profile where Name = 'GLBL_Chatter Only' limit 1].Id,
            TimeZoneSidKey    = 'America/Chicago',
            Username          = 'stakeholder@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
            UserRoleId        = null,
            Country           = 'Great Britain');
        insert approver;
        
        TRAK_test_templates__c TT = new TRAK_Test_templates__c(
            user_story__c      = userstory.Id,
            Title__c           = 'My test template title',
            Introduction__c    = 'My test template introduction',
            Approver__c        = approver.Id,
            Approval_Status__c = 'Approved');
        insert TT;
        
        TRAK_Test__c testExec = new TRAK_Test__c(
            Template__c        = TT.Id,
            User_Story__c      = userstory.Id,
            Project__c         = project.Id,
            Sprint__c          = sprint.Id,
            Assigned_To__c     = approver.Id,
            Approver__c        = approver.Id,
            Approval_Status__c = 'Open',
            Status__c          = 'Not Started'
        );
        insert testExec;
        
        Test.StartTest();
            testExec.Approval_Status__c = 'Pending Approval';
            update testExec;
            testExec.Approval_Status__c = 'Approved';
            update testExec;
            
            TRAK_Test_Execution_History__c tsh = [SELECT Id, Approval_Status__c FROM TRAK_Test_Execution_History__c WHERE Test_Execution__c = :testExec.Id ORDER BY LastModifiedDate DESC LIMIT 1];
            System.AssertEquals(testExec.Approval_Status__c,tsh.Approval_Status__c);
            
            testExec.Approval_Status__c = 'Pending Approval';
            update testExec;
            testExec.Approval_Status__c = 'Rejected';
            testExec.Status__c = 'Complete';
            update testExec;
            
            //Call the test execution date method of the class
            TRAK_Test_ExecutionTriggerClass.updateTestExecutionDate(testExec.Id);
            TRAK_Test_ExecutionTriggerClass.updateTestExecutionDate(tt.Id);
        Test.StopTest();
    }
    */

}