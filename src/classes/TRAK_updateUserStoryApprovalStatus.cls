public with sharing class TRAK_updateUserStoryApprovalStatus {
    public static void updateUserStoryApprovalStatusMethod(list<TRAK_User_Story_Approval_History__c> newList) {

        List<TRAK_User_Story__c> userStoryList = new List<TRAK_User_Story__c>();
        TRAK_User_Story__c userStoryObj=new TRAK_User_Story__c();

        for(TRAK_User_Story_Approval_History__c usHistoryobj: newList ){
            userStoryObj=new TRAK_User_Story__c();
            userStoryObj.Approval_Status__c=usHistoryobj.Approval_Status__c;
            userStoryObj.id=usHistoryobj.User_Story__c;
            if(usHistoryobj.System_Custodian_Approved__c && usHistoryobj.System_Owner_Approved__c){
                userStoryObj.TRAK_System_Custodian_Approved__c = true;
                userStoryObj.TRAK_System_Owner_Approved__c = true;
            }
            if(usHistoryobj.Business_Quality_Approved__c && usHistoryobj.Computer_Systems_Quality_Approved__c){
                userStoryObj.TRAK_Business_Quality_Approved__c = true;
                userStoryObj.TRAK_Computer_Systems_Quality_Approved__c = true;
            }
            userStoryList.add(userStoryObj);
        }
        try{
            if(userStoryList.size()>0)
            update userStoryList;
        }
        catch(Exception e){
           TRAK_TestDataUtilityClass.createErrorLog(e);      
            
         }
    }
}