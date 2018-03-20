/*
*@ Class Name     : Test_TRAK_runTestScriptExtension
*@ Description    : Test class for TRAK_runTestScriptExtension
*@ CreatedBy      : Deloitte Consulting
*@ CreatedOn      : 12-08-2016
*/

@isTest(seeAllData = false)
public with sharing class Test_TRAK_runTestScriptExtension {
    /* 
* @Method Name                    :  testMeth_TRAK_runTestScriptExtension
* @Description                    :  Test Method 
* @Return Type                    :  void
* @Param                          :  

*/
    
    static testmethod void testMeth_TRAK_runTestScriptExtension(){
        
        Test.startTest();
        //Create sprint
        TRAK_Sprint__c sprint = new TRAK_Sprint__c();
        sprint.Name = 'tracker sprint 1';
        insert sprint;
        System.assertNotEquals(sprint.Id, null);
        
        List<TRAK_User_Story__c> lstUserStory = TRAK_Test_Utility.createUserStory(3);
        /*oUserStory.Story_Points__c = '0';
        oUserStory.Story_Points_Other__c = '0';
        oUserStory.Proposed_Sprint__c = sprint.Id;
        oUserStory.Development_Stage__c = 'Backlog ';
        oUserStory.Allocated_Sprint__c = sprint.Id; */
        insert lstUserStory;
        System.assertNotEquals(lstUserStory[0].Id, null);
        
        list<TRAK_Bug__c> lbugs = new list<TRAK_Bug__c>();
        TRAK_Bug__c odefect = new TRAK_Bug__c();
        odefect.Technology__c = 'SFDC';
        odefect.Status__c = 'Raised';
        odefect.Problem__c = 'defect raised'; 
        odefect.BusinessImpact__c = 'Low';
        insert odefect;
        
        TRAK_Test__c oTestExectn = new TRAK_Test__c();
        oTestExectn.Status__c = 'Not Started';
        oTestExectn.User_Story__c = lstUserStory[0].id;
        oTestExectn.Test_Outcome__c = 'Passed';
        insert oTestExectn;
        System.assert(oTestExectn.id != Null);
        ApexPages.currentpage().getparameters().put('id',oTestExectn.id);
        
        TRAK_Test_Templates__c oTT = new TRAK_Test_Templates__c();
        oTT.User_Story__c = lstUserStory[0].id;
        oTT.Introduction__c = 'Test';
        oTT.Title__c = 'Test Title';
        insert oTT;
        
        TRAK_Test_Template_Steps__c oTTTS = new TRAK_Test_Template_Steps__c();
        oTTTS.Test_Script__c  = oTT.id;
        insert oTTTS;
        
        TRAK_Test_Steps__c oTTS = new TRAK_Test_Steps__c();
        oTTS.Test__c = oTestExectn.id;
        oTTS.Template_Step__c =  oTTTS.id;
        insert oTTS;

        List<TRAK_Test_Steps__c> oTestScript = [Select Name from TRAK_Test_Steps__c where Id = :oTTS.Id];
        PageReference pr = new Pagereference('');
        pr.getParameters().put('testName',oTestScript[0].Name);
        pr.getparameters().put('id',oTestExectn.id);
        Test.setCurrentPage(pr);
                
        list<TRAK_Test_Bug_Link__c> lTTBL = new List<TRAK_Test_Bug_Link__c>();
        TRAK_Test_Bug_Link__c oTTBL = new TRAK_Test_Bug_Link__c();
        oTTBL.Bug__c = odefect.id;
        oTTBL.Test_Step_Result__c = oTTS.id;
        oTTBL.Test_Script__c = oTestExectn.id;
        lTTBL.add(oTTBL);
        upsert lTTBL;
        
        oDefect.Script_Number__c = oTestScript[0].Name;
        update oDefect;
        
        TRAK_Bug__c odefect_Save = new TRAK_Bug__c();
        odefect_Save.Technology__c = 'SFDC';
        odefect_Save.Status__c = 'Raised';
        odefect_Save.Problem__c = 'defect raised'; 
        odefect_Save.BusinessImpact__c = 'Low';
        odefect_Save.Script_Number__c = oTestScript[0].Name;
        
        lbugs.add(oDefect_Save);
        
        TRAK_runTestScriptExtension oTRTSE = new TRAK_runTestScriptExtension(new ApexPages.StandardController(oTestExectn));
        oTRTSE.addbug();
        oTRTSE.AttachFile();
        otrtse.bugs = lbugs;
        //otrtse.BugLink = lTTBL;
        oTRTSE.Save();
        
        oTRTSE.SaveStep();
        oTRTSE.viewAttachment();
        
        Test.stopTest();
    }
    
}