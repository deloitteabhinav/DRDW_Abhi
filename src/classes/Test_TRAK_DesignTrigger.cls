@isTest(seeAllData = false)
private class Test_TRAK_DesignTrigger {

    static testMethod void testDesignHistory() {
        List<User> lUser = Test_Utility.createUser('Senior System Administrator',1,'test');
        System.assertNotEquals(lUser[0].id,null);
        System.runAs(lUser[0]){
        TRAK_Design__c design = new TRAK_Design__c();  
        //insert approver
        User approver = new User(Alias             = 'aprvr',
                            Email             = 'approver@TRAK-test.com',
                            EmailEncodingKey  = 'UTF-8',
                            LastName          = 'User',
                            FirstName         = 'Approver',
                            LanguageLocaleKey = 'en_US',
                            LocaleSidKey      = 'en_US',
                            ProfileId         = [select Id from Profile where Name = 'Global CDL/CDC' limit 1].Id,
                            TimeZoneSidKey    = 'America/Chicago',
                            Username          = 'stakeholder@TRAK-test' + Math.round(Math.random() * 10000) + '.com',
                            UserRoleId        = null,
                            Country           = 'India');
        insert approver;
        System.assertNotEquals(approver.id,null);
        
      //  design.App__c = app.Id;
     //   design.Project__c = project.Id;
        design.Overview__c = 'Test';
        design.Data_Model__c = 'Test';
        design.Fields__c = 'Test';
        design.Objects__c = 'Test';
        design.Other_Components__c = 'Test';
        design.Page_Layouts__c = 'Test';
        design.Visualforce_Pages__c = 'Test';
        design.Apex_Classes__c = 'Test';
        design.Apex_Trigger__c = 'Test';
        design.TRAK_Approver__c = approver.Id;
        
        insert design;
        System.assertNotEquals(design.id,null);
        
        //run the test
        test.startTest();
        
        design.Approval_Status__c = 'Pending Approval';
        
        update design;
        
        TRAK_Design_History__c designHistory = new TRAK_Design_History__c();
        designHistory = ([SELECT Id, Design_Overview__c, Data_Model__c, Fields__c,
                          Objects__c, Other_Components__c, Apex_Classes__c , Apex_Trigger__c , 
                          Approver__c, Approval_Date__c 
                   FROM TRAK_Design_History__c
                   WHERE Design__c = :design.Id 
                   LIMIT 1])[0];
        
        // check values are copied over
        System.assertEquals(design.Overview__c, designHistory.Design_Overview__c);
        System.assertEquals(design.Data_Model__c, designHistory.Data_Model__c);
        System.assertEquals(design.Fields__c, designHistory.Fields__c);
        System.assertEquals(design.Objects__c, designHistory.Objects__c);
        System.assertEquals(design.Other_Components__c, designHistory.Other_Components__c);
        System.assertEquals(design.Apex_Classes__c, designHistory.Apex_Classes__c);
        System.assertEquals(design.Apex_Trigger__c, designHistory.Apex_Trigger__c);
        System.assertEquals(design.TRAK_Approver__c, designHistory.Approver__c);
        
        
        design.Approval_Status__c = 'Approved';
        
        update design;
        
        designHistory = ([SELECT Id, Approval_Date__c 
                   FROM TRAK_Design_History__c
                   WHERE Design__c = :design.Id 
                   LIMIT 1])[0];
        test.stopTest();
    }   
    }    
}