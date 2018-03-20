/* Class Name  : TRAK_Test_New_Release_Override
 * Description : TRAK_New_Release_Override
 * CreatedBY   : Deloitte
 * Created Date: 11-08-2016
*/
@isTest(seealldata=false)
private class TRAK_TEST_New_Release_Override {
    
     /* 
* @Method Name                    :  testmeth_New_Release_Override
* @Description                    :  Test Method 
* @Return Type                    :  void
* @Param                          :  

*/
   static testMethod void testmeth_New_Release_Override(){
       
       //User oUSR = new User();
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
       Test.startTest();
       TRAK_New_Release_Override oTNRO = new  TRAK_New_Release_Override(new ApexPages.StandardController(oRelease));
       oTNRO.actionRedirect();
       Test.stopTest();
    }
    
    
}