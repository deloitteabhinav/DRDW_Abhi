/* Class Name  : Test_TRAK_Note_TriggerHandler
 * Description : TRAK_Note_TriggerHandler - trigger Handler
 * Trigger     : TRAK_Notr_Trigger
 * CreatedBY   : Deloitte
 * Created Date: 13-08-2016
*/
@isTest(seealldata=false)
private class Test_TRAK_Note_TriggerHandler {
    /*
        Method          : testMeth_TRAK_NoteTriggerHandler
        Description     : Test class for TRAK_NoteTriggerHandler
        Parameters      : void
        
    */
    static testMethod void testmeth_TRAK_NoteTriggerHandler(){
        Test.startTest();
        
        TRAK_Release__c oRelease = new TRAK_Release__c();
        oRelease.Name = 'Test';
        oRelease.Release_Type__c = 'Weekly';
        oRelease.Approval_Status__c = 'Draft';
        oRelease.Release_Date__c = System.today();
        oRelease.Product_Owner__c = UserINFO.getUserID();
        oRelease.System_Custodian__c = UserINFO.getUserID();
        oRelease.Business_Analyst__c = UserINFO.getUserID();
        insert oRelease;
        
        List<Note> lnote = new List<Note>();
        Note oNote = new Note();
        oNote.Body = 'text';
        oNote.ParentId = oRelease.id;
        oNote.Title = 'Test';
        lnote.add(oNote);
        insert lnote;
        
        TRAK_NoteTriggerHandler oTNTH = new TRAK_NoteTriggerHandler();
        TRAK_NoteTriggerHandler.duplicateNameCheck(lnote);
        note oNoteDup = new Note();
        oNoteDup.Body = 'text';
        oNoteDup.ParentId = oRelease.id;
        oNoteDup.Title = 'Test';
        lnote.add(oNoteDup);
        try{
        upsert lnote;
        }
        catch(exception exp){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,exp.getMessage()));
        }
        
        Test.stopTest();
    }
}