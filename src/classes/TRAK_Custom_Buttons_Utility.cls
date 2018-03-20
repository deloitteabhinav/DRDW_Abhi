/*************************************************************************\
    @ Author        : Deloitte Digital
    @ Date          : 1-Apr-2016
    @ Test Class    : 
    @ Description   : This class is used as for controlling the buttons on Release object.
****************************************************************************/
global with Sharing class TRAK_Custom_Buttons_Utility {
    
    global static final String SUCCESS_MESSAGE = 'success';
    global static final String FAILURE_MESSAGE = 'failure';
    global static final String PIC_COMPLETED = 'Complete';
    global static final String CODE_REVIEW_ALREADY_COMPLETE_MESSAGE = 'Code Review has already been completed !';
    global static final String PRE_PROD_APPROVAL_COMPLETE_MESSAGE = 'Pre-prod approval has already been completed !';
    global static final String CODE_REVIEW_APPROVAL_PENDING = 'Please submit for code review approval first !';
    global static final String PRE_PROD_APPROVAL_PENDING = 'Please submit for pre prod approval first !';
    global static final String PROD_APPROVAL_COMPLETE_MESSAGE = 'Prod approval has already been completed !';
    global static final String TECH_LEAD_IDENTIFICATION_ERROR = 'Only Tech Lead assigned on the project record is allowed to take this action !';
    global static final String SYSTEM_CUSTODIAN_IDENTIFICATION_ERROR = 'Only System Custodian or Backup System Custodian assigned on the app record is allowed to take this action !';        
    global static final String PROD_APPROVAL_CRITERIA_NOT_MET = 'Please complete the information in the Source Code Repository Name, Code Review Complete, Tag, Repo and Self Certification for DML related coding fields. Additionally, verify all user stories have the status (Passed-Complete), verify all test scripts and test executions associated to the user story have the approval status (approved), and verify all defects that have the status (Closed-Complete)';    
    global static final String PROVIDE_REJECTION_REASON = 'Please provide rejection reason!';
    global static final String ALREADY_REJECTED_MESSAGE = 'The record has already been rejected!';
    global static final String PRODUCTION_APPROVED_RECORD = 'The Release record is already approved for production !';
    global static final String PROVIDE_TAG = 'Please provide the tag number !';
    
       /** 
    * Method to Complete the Code Review Completed Approval on Release Record
    * 
    * US-41682
    * @Param Id
    * @return String
    * @throws NA
    */
    /*
    webservice static String codeReviewCompleted(Id releaseId){
        String result = FAILURE_MESSAGE;
        
        //fetching release record
        TRAK_Release__c releaseRecord = new TRAK_Release__c();
        releaseRecord = [SELECT Id, Code_Review_Completed__c,Rejected__c,Tag__c, Project__r.Tech_Lead__c FROM TRAK_Release__c WHERE Id =:releaseId];
        if (userinfo.getuserid() == releaseRecord.Project__r.Tech_Lead__c)    {
            if ((!releaseRecord.Code_Review_Completed__c) && (!releaseRecord.Rejected__c))    {
                //check code review checkbox
                If(TRAK_Release__c.Code_Review_Completed__c.getDescribe().isUpdateable() && TRAK_Release__c.sObjectType.getDescribe().isUpdateable())
                {
                    If(releaseRecord.Tag__c != Null)  {
                        releaseRecord.Code_Review_Completed__c = true;
                        try    {
                        update releaseRecord;
                        }
                        catch(Exception ex)    {
                            createApplicationException(ex);
                            System.debug('ex.getMessage '+ex.getMessage());
                            System.debug('ex.getStackTraceString() '+ ex.getStackTraceString());
                        }
                        result = SUCCESS_MESSAGE;
                        
                    }
                    else    {
                        result = PROVIDE_TAG;
                        return result;
                    }
                }
                return result;
                
            }
            else    {
                if (releaseRecord.Code_Review_Completed__c)  {
                  result = CODE_REVIEW_ALREADY_COMPLETE_MESSAGE;
                  return result;
                }
                if(releaseRecord.Rejected__c)  {
                  result = ALREADY_REJECTED_MESSAGE;
                  return result;
                }
                return result;
            }
        }
        else    {
            result = TECH_LEAD_IDENTIFICATION_ERROR;
            return result;
        }
    }
    
    /** 
    * Method to Complete the Preprod Review Completed Approval on Release Record
    * 
    * US-42322
    * @Param Id
    * @return String 
    * @throws NA
    */
    /*
     webservice static String preProdReviewCompleted(Id releaseId){
        String result = FAILURE_MESSAGE;
        
        //fetching release record
        TRAK_Release__c releaseRecord = new TRAK_Release__c();
        releaseRecord = [SELECT Id, Code_Review_Completed__c,Rejected__c, CR_Number__c , Project__r.App__r.PIC_Status__c, Tag__c, Approved_for_Pre_Production__c, Project__r.App__r.System_Custodian__c, Project__r.App__r.System_Custodian_Backup__c FROM TRAK_Release__c WHERE Id =:releaseId];
        
        List<TRAK_User_Story__c> relatedUserStoriesNotPassedCompleted = [SELECT Id FROM TRAK_User_Story__c WHERE Planned_Release__c=:releaseId AND Development_Stage__c !=:System.Label.TRAK_User_Story_Burn_Status];
        
        List<TRAK_Test_Templates__c> relatedTestScripts = [SELECT Id FROM TRAK_Test_Templates__c WHERE User_Story__r.Planned_Release__c=:releaseId AND Approval_Status__c !=:System.Label.TRAK_Test_Script_Approved_Approval_Status]; 
        
        List<TRAK_Test__c> relatedTestExecutions = [SELECT Id FROM TRAK_Test__c WHERE User_Story__r.Planned_Release__c=:releaseId AND Approval_Status__c!=:System.Label.TRAK_Test_Execution_Approved_Approval_Status];
        
        List<String> DefectClosedStatuses = System.Label.TRAK_Defects_Status_Closed_Complete.split(',');
        List<TRAK_Bug__c> relatedDefects = [SELECT Id FROM TRAK_Bug__c WHERE Planned_Release__c=:releaseId AND Status__c !=: System.Label.TRAK_Defect_ClosedComplete];
        
        if ((userinfo.getuserid() == releaseRecord.Project__r.App__r.System_Custodian_Backup__c) || (userinfo.getuserid() == releaseRecord.Project__r.App__r.System_Custodian__c))    {
            if ( (releaseRecord.Code_Review_Completed__c) && (!releaseRecord.Approved_for_Pre_Production__c) && (!releaseRecord.Rejected__c))    {
                
                
                /* US-44056 changes
                if (releaseRecord.CR_Number__c == null)    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else if (releaseRecord.Project__r.App__r.PIC_Status__c != PIC_COMPLETED)    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else*/
                
                /*if (releaseRecord.Source_Code_Repository_Name__c == null)    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }*/ /*
                if (releaseRecord.Tag__c == null)    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else if (releaseRecord.Rejected__c)    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else if (!relatedUserStoriesNotPassedCompleted.isEmpty())    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else if (!relatedTestScripts.isEmpty())    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else if (!relatedTestExecutions.isEmpty())    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else if (!relatedDefects.isEmpty())    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else  {
                  //mark pre prod approval
                  if(TRAK_Release__c.Approved_for_Pre_Production__c.getDescribe().isUpdateable() && TRAK_Release__c.sObjectType.getDescribe().isUpdateable())    {
                    releaseRecord.Approved_for_Pre_Production__c = true;
                    try    {
                        update releaseRecord;
                    }
                    catch(Exception ex)    {
                        createApplicationException(ex);
                    }
                    result = SUCCESS_MESSAGE;
                    }
                    return result;
                }
            }
            else    {
              if (releaseRecord.Rejected__c)    {
                    result = ALREADY_REJECTED_MESSAGE;
                    return result;
                }
                if (!releaseRecord.Code_Review_Completed__c)    {
                    result = CODE_REVIEW_APPROVAL_PENDING;
                    return result;
                }
                if (releaseRecord.Approved_for_Pre_Production__c)    {
                    result = PRE_PROD_APPROVAL_COMPLETE_MESSAGE;
                    return result;
                }
                return result;
            }
        }
        else    {
                result = SYSTEM_CUSTODIAN_IDENTIFICATION_ERROR;
                return result;
            }
        
    }
    /** 
    * Method to Complete the Ready for Production Approval on Release Record
    * 
    * US-42322
    * @Param Id
    * @return String 
    * @throws NA
    */
    /* 
    webservice static String prodReviewCompleted(Id releaseId){
        String result = FAILURE_MESSAGE;
        
        //fetching release record
        TRAK_Release__c releaseRecord = new TRAK_Release__c();
        releaseRecord = [SELECT Id, recordtypeid, Code_Review_Completed__c,Rejected__c, CR_Number__c , Project__r.App__r.PIC_Status__c, Tag__c, Approved_for_Pre_Production__c, Approved_for_Production__c, Project__r.App__r.System_Custodian__c, Project__r.App__r.System_Custodian_Backup__c FROM TRAK_Release__c WHERE Id =:releaseId];
        
        List<TRAK_User_Story__c> relatedUserStoriesNotPassedCompleted = [SELECT Id FROM TRAK_User_Story__c WHERE Planned_Release__c=:releaseId AND Development_Stage__c !=:System.Label.TRAK_User_Story_Burn_Status];
        
        List<TRAK_Test_Templates__c> relatedTestScripts = [SELECT Id FROM TRAK_Test_Templates__c WHERE User_Story__r.Planned_Release__c=:releaseId AND Approval_Status__c !=:System.Label.TRAK_Test_Script_Approved_Approval_Status]; 
        
        List<TRAK_Test__c> relatedTestExecutions = [SELECT Id FROM TRAK_Test__c WHERE User_Story__r.Planned_Release__c=:releaseId AND Approval_Status__c!=:System.Label.TRAK_Test_Execution_Approved_Approval_Status];
        
        List<String> DefectClosedStatuses = System.Label.TRAK_Defects_Status_Closed_Complete.split(',');
        List<TRAK_Bug__c> relatedDefects = [SELECT Id FROM TRAK_Bug__c WHERE Planned_Release__c=:releaseId AND Status__c !=: System.Label.TRAK_Defect_ClosedComplete];
        
        if (userinfo.getuserid() == releaseRecord.Project__r.App__r.System_Custodian__c || userinfo.getuserid() == releaseRecord.Project__r.App__r.System_Custodian_Backup__c)    {
        if (releaseRecord.RecordtypeId == Schema.SObjectType.TRAK_Release__c.getRecordTypeInfosByName().get('GSO 3 Self Service').getRecordTypeId())   {
            if ( (releaseRecord.Code_Review_Completed__c) && (releaseRecord.Approved_for_Pre_Production__c) && (!releaseRecord.Approved_for_Production__c) && (!releaseRecord.Rejected__c))    {
                
                /* US-44056 changes
                if (releaseRecord.CR_Number__c == null)    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else if (releaseRecord.Project__r.App__r.PIC_Status__c != PIC_COMPLETED)    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else
                if (releaseRecord.Source_Code_Repository_Name__c == null)    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                if (releaseRecord.Tag__c == null)    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else if (releaseRecord.Rejected__c)    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else if (!relatedUserStoriesNotPassedCompleted.isEmpty())    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else if (!relatedTestScripts.isEmpty())    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else if (!relatedTestExecutions.isEmpty())    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else if (!relatedDefects.isEmpty())    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else{
                    if( TRAK_Release__c.Approved_for_Production__c.getDescribe().isUpdateable() && TRAK_Release__c.sObjectType.getDescribe().isUpdateable()) {
                        releaseRecord.Approved_for_Production__c = true;
                        try {
                            update releaseRecord;
                        }
                        catch(Exception ex)    {
                            createApplicationException(ex);
                        }
                        result = SUCCESS_MESSAGE;
                    }
                    return result;
                    
                }
            }
            else    {
              if (releaseRecord.Rejected__c)    {
                    result = ALREADY_REJECTED_MESSAGE;
                    return result;
                }
                if (!releaseRecord.Code_Review_Completed__c)    {
                    result = CODE_REVIEW_APPROVAL_PENDING;
                    return result;
                }
                if (!releaseRecord.Approved_for_Pre_Production__c)    {
                    result = PRE_PROD_APPROVAL_PENDING;
                    return result;
                }
                if (releaseRecord.Approved_for_Production__c)    {
                    result = PROD_APPROVAL_COMPLETE_MESSAGE;
                    return result;
                }
                return result;
            }
        }
        else{
            if ( (releaseRecord.Code_Review_Completed__c) && (!releaseRecord.Approved_for_Production__c))    {
              /* US-44056 changes   
                if (releaseRecord.CR_Number__c == null)    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else if (releaseRecord.Project__r.App__r.PIC_Status__c != PIC_COMPLETED)    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                
                if (releaseRecord.Tag__c == null)    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                /*else if (releaseRecord.Source_Code_Repository_Name__c == null)    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else if (releaseRecord.Rejected__c)    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else if (!relatedUserStoriesNotPassedCompleted.isEmpty())    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else if (!relatedTestScripts.isEmpty())    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else if (!relatedTestExecutions.isEmpty())    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else if (!relatedDefects.isEmpty())    {
                    result = PROD_APPROVAL_CRITERIA_NOT_MET;
                    return result;
                }
                else{
                    If( TRAK_Release__c.Approved_for_Production__c.getDescribe().isUpdateable() && TRAK_Release__c.sObjectType.getDescribe().isUpdateable()) {
                        releaseRecord.Approved_for_Production__c = true;
                        try    {
                            update releaseRecord;
                        }
                        catch(Exception ex)    {
                        createApplicationException(ex);
                        }
                        result = SUCCESS_MESSAGE;
                    }
                    return result;
                }
            }
            else    {
                if (!releaseRecord.Code_Review_Completed__c)    {
                    result = CODE_REVIEW_APPROVAL_PENDING;
                    return result;
                }
                else if (releaseRecord.Approved_for_Production__c)    {
                    result = PROD_APPROVAL_COMPLETE_MESSAGE;
                    return result;
                }
                return result;
            }

        }
        return result;
        
    }
    else
    {
        result =  SYSTEM_CUSTODIAN_IDENTIFICATION_ERROR ;
        return result;
    }
    
    } */
    /*
    webservice static String releaseRejected(Id releaseId){
        String result = FAILURE_MESSAGE;
        //fetching release record
        TRAK_Release__c releaseRecord = new TRAK_Release__c();
        releaseRecord = [SELECT Id, Rejected__c ,Approved_for_Production__c, Rejected_Reason__c, Project__r.Tech_Lead__c,Project__r.App__r.System_Custodian__c,Project__r.App__r.System_Custodian_Backup__c  FROM TRAK_Release__c WHERE Id =:releaseId];
        if (userinfo.getuserid() == releaseRecord.Project__r.App__r.System_Custodian__c || userinfo.getuserid() == releaseRecord.Project__r.App__r.System_Custodian_Backup__c)    {
            if ((!releaseRecord.Rejected__c) && (!releaseRecord.Approved_for_Production__c))    {
                //check code review checkbox
                if(releaseRecord.Rejected_Reason__c == NULL){
                result = PROVIDE_REJECTION_REASON;
                return result;
                }
                If(TRAK_Release__c.Rejected__c.getDescribe().isUpdateable() && TRAK_Release__c.sObjectType.getDescribe().isUpdateable())   {
                    releaseRecord.Rejected__c = true;
                    try{
                        update releaseRecord;
                    }
                    catch(Exception ex)    {
                        createApplicationException(ex);
                    }
                    result = SUCCESS_MESSAGE;
                }
                return result;
            }
            else    {
              if (releaseRecord.Rejected__c)  {
                  result = ALREADY_REJECTED_MESSAGE ;
                  return result;
              }
              if(releaseRecord.Approved_for_Production__c){
                result = PRODUCTION_APPROVED_RECORD ;
                  return result;
              }
              return result;
            }
       }
       else
       {
           result =  SYSTEM_CUSTODIAN_IDENTIFICATION_ERROR ;
           return result;   
       }
    } */
    public static void createApplicationException(Exception ex) {
            GLBL_Error_Log__c log = new GLBL_Error_Log__c();
            log.Error_Message__c = ex.getTypeName();
            log.Error_Datetime__c = Date.today();
            log.Running_User__c = UserInfo.getUserId();
            log.Stack_Trace__c = ex.getStackTraceString();   
            log.Additional_Information__c = 'Class name: '+ex.getStackTraceString().Substring(ex.getStackTraceString().indexof('.')+1,ex.getStackTraceString().lastindexof('.'))  + ' Method name: ' + ex.getStackTraceString().Substring(ex.getStackTraceString().lastindexof('.')+1,ex.getStackTraceString().indexof(':')) ;        
            System.debug('Additional Info'+log.Additional_Information__c);
    }
}