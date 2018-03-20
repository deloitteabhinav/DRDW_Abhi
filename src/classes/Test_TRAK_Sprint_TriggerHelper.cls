/* Class Name  : Test_TRAK_Sprint_TriggerHelper
 * Description : TRAK_Sprint_TriggerHelper
 * CreatedBY   : Deloitte
 * Created Date: 11-08-2016
*/
@isTest(seealldata=false)
private class Test_TRAK_Sprint_TriggerHelper {
    
     /* 
* @Method Name                    :  testmeth_TRAK_Sprint_TriggerHelper
* @Description                    :  Test Method 
* @Return Type                    :  void
* @Param                          :  

*/
   static testMethod void testmeth_TRAK_Sprint_TriggerHelper(){
       
       List<TRAK_Sprint__c> lSprints = TRAK_Test_Utility.createSprint(1);
       insert lSprints;
       Set<ID> sprintIds = new Set<Id>();
       SprintIds.add(lSprints[0].id);
       
        List<TRAK_User_Story__c> lUsrStory = TRAK_Test_Utility.createUserStory(1);
        lUsrStory[0].Allocated_Sprint__c = lSprints[0].id;
        lUsrStory[0].Development_Stage__c = 'Backlog';
        insert lUsrStory;
        
        lUsrStory[0].Development_Stage__c = 'Passed (Complete)';
        lUsrStory[0].Approval_Status__c = 'Approved';
        update lUsrStory;
        
        List<TRAK_Bug__c> lDefects = TRAK_Test_Utility.createDefect(1);
        lDefects[0].Allocated_Sprint__c = lSprints[0].id;
        lDefects[0].Status__c = 'Raised';
        insert lDefects;
        
        lDefects[0].Status__c = 'Closed - Complete';
        update lDefects;
        
        TRAK_Sprint_TriggerHelper.updateAllocatedStoryPoints(SprintIds);
        TRAK_Sprint_TriggerHelper.updateCompletedStoryPoints(SprintIds);
   }
   
}