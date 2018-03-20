/**
 * Extension to get the approval history information for the User_Story_Approval_History snapshot object for a given user story
 */
public class TRAK_UserStoryApprovalHistory {
    
    // variables
    private final TRAK_User_Story__c userStory;
    public Id approvalSnapshotId {get; set;}
    public ProcessInstance approvalProcess {get; set;}
    
    
    /**
     * Constructor
     */
    public TRAK_UserStoryApprovalHistory (ApexPages.StandardController controller) {

        this.userStory = (TRAK_User_Story__c) controller.getRecord();
        approvalSnapshotId = getLatestApprovalSnapshot().Id;
        
        if (approvalSnapshotId != null) {
            approvalProcess = getApprovalProcess(approvalSnapshotId);
        }
        
    }
    
    
    /**
     * Gets the latest snapshot record for this story 
     */
    private TRAK_User_Story_Approval_History__c getLatestApprovalSnapshot () {
        
        List<TRAK_User_Story_Approval_History__c> snapshots = [SELECT Id 
                                                               FROM TRAK_User_Story_Approval_History__c 
                                                               WHERE User_Story__c = :this.userStory.Id 
                                                               ORDER BY CreatedDate DESC 
                                                               LIMIT 1];
        
        if (snapshots.isEmpty()) {
            return new TRAK_User_Story_Approval_History__c();
        }
        else {
            return snapshots[0];
        }
            
    }
    
    
    /**
     * get the approval process for supplied object
     * @param targetObjectId the ID of the object for which we want to get the latest approval process
     */
    public ProcessInstance getApprovalProcess (Id targetObjectId) {
        
        List<ProcessInstance> approvalProcesses = [ SELECT Id, (SELECT Id, StepStatus, Comments, OriginalActor.Name, Actor.Name, SystemModStamp, ElapsedTimeInDays, ElapsedTimeInHours FROM StepsAndWorkitems WHERE StepStatus != 'Started' ORDER BY StepStatus DESC, SystemModStamp DESC)
                                                    FROM ProcessInstance 
                                                    WHERE TargetObjectID  = :targetObjectId
                                                    ORDER BY CreatedDate DESC
                                                    LIMIT 1];
        
        if (approvalProcesses.size() != 0) {
            return approvalProcesses[0];
        }
        else {
            return null;
        }
    }

}