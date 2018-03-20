/*
*@ Class Name                                                    : Test_TRAK_Report_Name_Redirect
*@ Description                                                   : Test class for TRAK_Report_Name_Redirect
*@ CreatedBy                                                     : Deloitte Consulting
*@ CreatedOn                                                     : 12-08-2016

*/
@isTest(seealldata=true) // reason for keeping seealldata true is, to access reports, as report cannot be deployed.
private class Test_TRAK_Report_Name_Redirect {

/*
 * Method Name    : testMeth_TRAK_Report_Name_Redirect
 * Description    : test method to cover actionRedirect()
 * Return Type    : void    
*/
    
    Static testmethod void testMeth_TRAK_Report_Name_Redirect(){
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
       System.assertNotEquals(oRelease.Id, null);
       
       
       TRAK_Report_Name_Redirect oTRNR = new  TRAK_Report_Name_Redirect(new ApexPages.StandardController(oRelease));
       
       oTRNR.reportName = 'TRAK_Number_of_Defects_in_this_Release';
       //Report oRep = [Select Id, developerName from Report Where DeveloperName Like '%TRAK_Number_of_Defects_in_this_Release%' and FolderName Like '%Release Tracker%' Limit 1];
       //system.assert(oRep.id !=null );
       oTRNR.actionRedirect();
      Test.stopTest();
    }
    
    /*
 * Method Name    : testMeth_TRAK_Report_Name_Redirect_negative
 * Description    : test method to cover actionRedirect()
 * Return Type    : void    
*/
    
    Static testmethod void testMeth_TRAK_Report_Name_Redirect_negative(){
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
       System.assertNotEquals(oRelease.Id, null);
       
       TRAK_Report_Name_Redirect oTRNR = new  TRAK_Report_Name_Redirect(new ApexPages.StandardController(oRelease));       
       oTRNR.actionRedirect();
      Test.stopTest();
    }
}