/* Class Name  : Test_TRAK_SubmitForApproval
 * Description : TRAK_SubmitForApproval
 * CreatedBY   : Deloitte
 * Created Date: 11-08-2016
*/
@isTest(seealldata=false)
private class Test_TRAK_SubmitForApproval {
    
     /* 
* @Method Name                    :  testmeth_TRAK_SubmitForApproval
* @Description                    :  Test Method 
* @Return Type                    :  void
* @Param                          :  

*/
    static testMethod void testmeth_TRAK_SubmitForApproval(){
    
        Test.StartTest();
        List<TRAK_Sprint__c> lSprints = TRAK_Test_Utility.createSprint(1);
        insert lSprints;
        Set<ID> sprintIds = new Set<Id>();
        SprintIds.add(lSprints[0].id);
        
        List<TRAK_User_Story__c> lUsrStory = TRAK_Test_Utility.createUserStory(1);
        lUsrStory[0].Allocated_Sprint__c = lSprints[0].id;
        lUsrStory[0].Development_Stage__c = 'Backlog';
        insert lUsrStory;
        
        TRAK_SubmitForApproval oTSA = new TRAK_SubmitForApproval();
        TRAK_SubmitForApproval.SendEmailMethod(lUsrStory[0].id);
        Test.StopTest();
   }
   
   
}