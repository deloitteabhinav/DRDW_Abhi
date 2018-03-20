/* Class Name  : Test_MeetingController
* Description  : Test Class for MeetingController
* Created By   : Deloitte
* Created Date : 17th December 2015
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
*/

@isTest(SeeAllData = False)

public with sharing class Test_MeetingController
{

    /* 
    * @Method Name                    :  testMeetingConsole
    * @Description                    :  Method to test Meeting Console Page
    * @Return Type                    :  void
    * @Parameters                     :  None
    */      
    static testMethod void testMeetingConsole() 
    {

        User u = DataFactory.getTestingUser();
        DataFactory.givePermissions(u.id, 'Admin');    
        
        User u2 = DataFactory.getTestingUser();
        DataFactory.givePermissions(u2.id, 'Supplier_Assessor');
        DataFactory.assignToPublicGroup(u2.id,'Supplier_Assessor');
        
        User uAdmin = DataFactory.getTestingUser();
        String pId = [select Id from Profile where Name = 'System Administrator'].Id;
        uAdmin.profileId = pid;
        Update uAdmin;
        
        //Inserting Custom Setting Data
        System.runAs(uAdmin){
            Insert new AccountFields__c(
            Name = 'A1',
            Field_API__c = 'Services_Provided__c'
            );
            Insert new AccountFields__c(
            Name = 'A2',
            Field_API__c = 'Misc_Benchmarking_Information__c'
            );
        }
        
        Test.startTest();
        Event oEvent = new Event();
       
        System.runAs(u) 
        {
        list<Account> lAccounts = DataFactory.returnSupplierAccounts(1);
        Insert lAccounts;
        system.assertNotEquals(lAccounts.size(),0);
        list<Event> lEvents = DataFactory.returnSupplierEvents(lAccounts,1);
        Insert lEvents;
        system.assertNotEquals(lEvents.size(),0);
        oEvent = lEvents[0];
        
        AccountShare oShare = new AccountShare();
        //oShare.AccountAccessLevel = 'Edit';
        //oShare.UserOrGroupId = u2.id;
        //oShare.AccountId = lAccounts[0].Id;
        //oShare.OpportunityAccessLevel = 'None';
        //Insert oShare;
        //system.assertNotEquals(oShare,NULL);
        
        PageReference pageRef = new pageReference('/apex/Meeting?Id='+lEvents[0].Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController stdController = new ApexPages.StandardController(lEvents[0]);         
        MeetingController oMeetingControl = new MeetingController(stdController); 
        
        //Adding Meeting Notes
        oMeetingControl.oMeeting.Meeting_Notes__c = 'Test Notes';
        oMeetingControl.AddMeetingNotes();
        system.assertNotEquals(oMeetingControl.oMeeting.Meeting_Notes__c ,NULL);
        
        //Adding Tasks
        oMeetingControl.oTask.Subject = 'Test Subject';
        oMeetingControl.oTask.OwnerId = NULL;
        oMeetingControl.oTask.Priority = 'Medium';
        oMeetingControl.AddTasks();
        oMeetingControl.oTask.Subject = 'Test Subject';
        oMeetingControl.oTask.OwnerId = u.Id;
        oMeetingControl.oTask.Priority = 'Medium';
        oMeetingControl.AddTasks();
        system.assertNotEquals(oMeetingControl.oTask,NULL);
        
        //Updating Tasks
        oMeetingControl.oTask = oMeetingControl.lTasks[0];
        oMeetingControl.oTask.Subject = 'New Subject';
        oMeetingControl.oTask.OwnerId = u2.Id;
        oMeetingControl.UpdateTasks();
        oMeetingControl.oTask.OwnerId = UserInfo.getUserId();
        oMeetingControl.UpdateTasks();
        
        
        //Adding New Agendas via Parameters and Saving Changes 
        oMeetingControl.AddNewAgenda();
        oMeetingControl.SaveChanges();
        oMeetingControl.lwFieldList[0].fSelected = TRUE;
        oMeetingControl.AddNewAgenda();
        oMeetingControl.lwFieldList[1].fSelected = TRUE;
        oMeetingControl.AddNewAgenda();
        oMeetingControl.lwFieldList[0].fSelected = TRUE;
        oMeetingControl.lwFieldList[1].fSelected = TRUE;
        oMeetingControl.AddNewAgenda();
        oMeetingControl.lwAgendaWrap[0].oAgenda.Order__c = 100;
        oMeetingControl.SaveChanges();
        
        //Adding Custom Agenda via Modal
        oMeetingControl.oAgenda.Name = 'New Agenda';
        oMeetingControl.AddCustomAgenda();
        
        //Deleting Agenda
        oMeetingControl.oAgenda = oMeetingControl.lwAgendaWrap[0].oAgenda;
        oMeetingControl.DeleteAgenda();
        }
        
        System.runAs(u2) 
        {
        PageReference pageRef = new pageReference('/apex/Meeting?Id='+oEvent.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController stdController = new ApexPages.StandardController(oEvent);         
        MeetingController oMeetingControl = new MeetingController(stdController); 
        } 
        
        Test.stopTest();
    }

}