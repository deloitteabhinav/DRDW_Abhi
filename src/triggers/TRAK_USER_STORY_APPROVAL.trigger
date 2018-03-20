trigger TRAK_USER_STORY_APPROVAL on TRAK_User_Story_Approval_History__c (after insert,after update) {
    if(TRAK_Release_Tracker__c.getInstance().Disable_Approval_Validation__c == false) {
    if(trigger.isinsert){
     for (TRAK_User_Story_Approval_History__c a : trigger.new) {
    if(a.System_Custodian__c!=null && a.System_Owner__c!=null){
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();

        app.setObjectId(a.id);

        Approval.ProcessResult result = Approval.process(app);
 
    }
  }
 }
    if(Trigger.isUpdate) {
     TRAK_updateUserStoryApprovalStatus.updateUserStoryApprovalStatusMethod(trigger.new);
     }
     }
}