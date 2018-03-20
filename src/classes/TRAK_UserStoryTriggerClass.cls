public class TRAK_UserStoryTriggerClass {
    /**
     * Creates custom AC history on user stories, as we can't do history tracking on rich text fields.
     */
    public static void createNewACHistoryRecord(Map < Id, String > mapStoryACHistory, Map < Id, String > mapStoryCCHistory) {
        List < TRAK_AC_History__c > lstACHistoryRecords = new List < TRAK_AC_History__c > ();
        TRAK_AC_History__c newACHistoryRecord;
        for (Id UserStoryId: mapStoryACHistory.keySet()) {
            newACHistoryRecord = new TRAK_AC_History__c();
            newACHistoryRecord.Acceptance_Criteria__c = mapStoryACHistory.get(UserStoryId);
            newACHistoryRecord.User_Story__c = UserStoryId;
            newACHistoryRecord.Type__c = 'Acceptance Criteria';
            lstACHistoryRecords.add(newACHistoryRecord);
        }
        TRAK_AC_History__c newCCHistoryRecord;
        for (Id UserStoryId: mapStoryCCHistory.keySet()) {
            newCCHistoryRecord = new TRAK_AC_History__c();
            newCCHistoryRecord.Acceptance_Criteria__c = mapStoryCCHistory.get(UserStoryId);
            newCCHistoryRecord.User_Story__c = UserStoryId;
            newCCHistoryRecord.Type__c = 'Compliance Criteria';
            lstACHistoryRecords.add(newCCHistoryRecord);
        }
        if (!lstACHistoryRecords.isEmpty()) {
            insert lstACHistoryRecords;
        }
    }
    public static void createNewApprovalHistoryRecord(Map < Id, TRAK_User_Story__c > mapStoryFields) {
        //List<TRAK_User_Story_Approval_History__c> rec=[Select name from TRAK_User_Story_Approval_History__c Limit 1];
        List < TRAK_User_Story_Approval_History__c > listUSHistoryRecords = new List < TRAK_User_Story_Approval_History__c > ();
        //if(rec.isEmpty()){
        TRAK_User_Story_Approval_History__c newRecord;
        for (TRAK_User_Story__c userStoryObj: mapStoryFields.values()) {
            newRecord = new TRAK_User_Story_Approval_History__c();
            newRecord.So_that__c = userStoryObj.So_that__c;
            newRecord.I_Want_To__c = userStoryObj.I_Want_To__c;
            newRecord.As_A_text__c = userStoryObj.As_A_text__c;
            newRecord.Approval_Status__c = userStoryObj.Approval_Status__c;
            newRecord.System_Owner__c = userStoryObj.System_Owner__c;
            newRecord.User_Story__c = userStoryObj.id;
            newRecord.Business_Quality__c = userStoryObj.Compliance_Owner__c;
            newRecord.System_Custodian__c = userStoryObj.System_Custodian__c;
            newRecord.Computer_Systems_Quality__c = userStoryObj.Computer_Systems_Quality__c;
            listUSHistoryRecords.add(newRecord);
        }
        insert listUSHistoryRecords;
    }

    /**
     * User stories should have their stakeholder fields populated. If they are left blank,
     * bring through the stakeholders from the associated TRAK_App__c record
     
    public static void populateAppStakeholders(List < TRAK_User_Story__c > userStories) {
        List < TRAK_User_Story__c > userStoriesWithMissingStakeholders = new List < TRAK_User_Story__c > ();
        List < Id > appIds = new List < Id > ();
        // find out which stories have missing stakeholders
        for (TRAK_User_Story__c story: userStories) {
            if (story.System_Custodian__c == null || story.System_Owner__c == null || story.Compliance_Owner__c == null || story.Computer_Systems_Quality__c == null) {
                userStoriesWithMissingStakeholders.add(story);
         //       appIds.add(story.App__c);
            }
        }
        // get the app records that contain this missing info
        Map < Id, TRAK_App__c > appMap = new Map < Id, TRAK_App__c > ([SELECT Id, System_Custodian__c, System_Owner__c, Business_Quality__c, Computer_Systems_Quality__c
            FROM TRAK_App__c
            WHERE Id in : appIds
         ]); 
        // now assign those values to the user story records
        for (TRAK_User_Story__c story: userStoriesWithMissingStakeholders) {
            if (appMap.get(story.App__c) != null) {
                if (story.System_Custodian__c == null) {
                    story.System_Custodian__c = appMap.get(story.App__c).System_Custodian__c;
                }
                if (story.System_Owner__c == null) {
                    story.System_Owner__c = appMap.get(story.App__c).System_Owner__c;
                }
                if (story.Compliance_Owner__c == null) {
                    story.Compliance_Owner__c = appMap.get(story.App__c).Business_Quality__c;
                }
                if (story.Computer_Systems_Quality__c == null) {
                    story.Computer_Systems_Quality__c = appMap.get(story.App__c).Computer_Systems_Quality__c;
                }
            } 
        }
    } */
    public static void populateManualStep(Boolean Flag, List < TRAK_User_Story__c > userStories, Map < Id, TRAK_User_Story__c > mapManualSteps, Map < Id, TRAK_User_Story__c > oldMapManualSteps) {
        List < TRAK_User_Story__c > listUserStory = new List < TRAK_User_Story__c > ();
        if (!userStories.isEmpty() && flag) {
            listUserStory.clear();
            for (TRAK_User_Story__c story: userStories) {
                if (story.Release_Steps_Manual__c != '' && story.Release_Steps_Manual__c != null)
                    story.Has_Pre_Manual_Steps__c = true;
                else if (story.Release_Steps_Manual__c == '' || story.Release_Steps_Manual__c == null)
                    story.Has_Pre_Manual_Steps__c = false;
                if (story.Post_Deployment_Manual_steps__c != '' && story.Post_Deployment_Manual_steps__c != null)
                    story.Has_Post_Manual_Steps__c = true;
                else if (story.Post_Deployment_Manual_steps__c == '' || story.Post_Deployment_Manual_steps__c == null)
                    story.Has_Post_Manual_Steps__c = false;
                if (story.Data_Steps__c != '' && story.Data_Steps__c != null)
                    story.Has_Data_Steps__c = true;
                else if (story.Data_Steps__c == '' || story.Data_Steps__c == null)
                    story.Has_Data_Steps__c = false;
                if (story.Validation_steps__c != '' && story.Validation_steps__c != null)
                    story.Has_Validation_Steps__c = true;
                else if (story.Validation_steps__c == '' || story.Validation_steps__c == null)
                    story.Has_Validation_Steps__c = false;
                listUserStory.add(story);
            }
            //    insert listUserStory;
        } else if (!mapManualSteps.isEmpty() && !flag) {
            listUserStory.clear();

            for (TRAK_User_Story__c userStoryObj: mapManualSteps.values()) {
                if (userStoryObj.Release_Steps_Manual__c != oldMapManualSteps.get(userStoryObj.id).Release_Steps_Manual__c) {
                    if (userStoryObj.Release_Steps_Manual__c != '' && userStoryObj.Release_Steps_Manual__c != null)
                        userStoryObj.Has_Pre_Manual_Steps__c = true;
                    else
                        userStoryObj.Has_Pre_Manual_Steps__c = false;
                }
                if (userStoryObj.Post_Deployment_Manual_steps__c != oldMapManualSteps.get(userStoryObj.id).Post_Deployment_Manual_steps__c) {
                    if (userStoryObj.Post_Deployment_Manual_steps__c != '' && userStoryObj.Post_Deployment_Manual_steps__c != null)
                        userStoryObj.Has_Post_Manual_Steps__c = true;
                    else
                        userStoryObj.Has_Post_Manual_Steps__c = false;
                }
                if (userStoryObj.Data_Steps__c != oldMapManualSteps.get(userStoryObj.id).Data_Steps__c) {
                    if (userStoryObj.Data_Steps__c != '' && userStoryObj.Data_Steps__c != null)
                        userStoryObj.Has_Data_Steps__c = true;
                    else
                        userStoryObj.Has_Data_Steps__c = false;
                }
                if (userStoryObj.Validation_steps__c != oldMapManualSteps.get(userStoryObj.id).Validation_steps__c) {
                    if (userStoryObj.Validation_steps__c != '' && userStoryObj.Validation_steps__c != null)
                        userStoryObj.Has_Validation_Steps__c = true;
                    else
                        userStoryObj.Has_Validation_Steps__c = false;
                }
                listUserStory.add(userStoryObj);
            }
            //  update listUserStory;
        }

    }

    public static void populateNumberOfUserStories(List < TRAK_User_Story__c > lUserStory, List < TRAK_User_Story__c > lUserStoryOld) {
        Set < Id > sRelease = new Set < Id > ();
        List < TRAK_Release__c > lRelease = new List < TRAK_Release__c > ();
        for (TRAK_User_Story__c oUserStory: lUserStory) {
            if (oUserStory.Cirrus_Release__c != null) {
                sRelease.add(oUserStory.Cirrus_Release__c);
            }

        }
        for (TRAK_User_Story__c oUserStory: lUserStoryOld) {
            if (oUserStory.Cirrus_Release__c != null) {
                sRelease.add(oUserStory.Cirrus_Release__c);
            }

        }
        Set < ID > sReleaseUpdate = new Set < ID > ();
        if (sRelease.size() > 0) {

            AggregateResult[] sumRelease = [Select COUNT(id) numberOfUserStories, Cirrus_Release__c from TRAK_User_Story__c where
                Cirrus_Release__c != null and Cirrus_Release__c IN: sRelease group by Cirrus_Release__c
            ];
            if (sumRelease.size() > 0) {
            TRAK_Release__c oRelease;
                for (AggregateResult ar: sumRelease) {
                    oRelease = new TRAK_Release__c();
                    oRelease.Id = String.ValueOf(ar.get('Cirrus_Release__c'));
                    oRelease.Number_of_User_Stories__c = Integer.valueOf(ar.get('numberOfUserStories'));
                    sReleaseUpdate.add(oRelease.Id);
                    lRelease.add(oRelease);
                }
            }
            TRAK_Release__c oRelease;
            for (ID oReleaseId: sRelease) {
                if (!sReleaseUpdate.contains(oReleaseId)) {
                    oRelease = new TRAK_Release__c();
                    oRelease.Id = oReleaseId;
                    oRelease.Number_of_User_Stories__c = 0;
                    sReleaseUpdate.add(oReleaseId);
                    lRelease.add(oRelease);
                }
            }

            try {
                update lRelease;
            } catch (Exception e) {
                lUserStory[0].addError('Error while updating User Story Count:' + e.getMessage());
            }
        }
    }

    public static void validateRegressionDefectsBeforePassingUS(List < TRAK_User_Story__c > lUserStory, Map<Id , TRAK_User_Story__c> mUserStory) {
    //validateRegressionDefectsBeforePassingUS
    Set<String> sUserStoryId = new Set<String>();
    Set<String> sUserStoryWithDefects = new Set<String>();
        for(TRAK_User_Story__c oUserStory : lUserStory) {
            if((oUserStory.Development_Stage__c == 'Passed Test') || 
            (oUserStory.Development_Stage__c == 'Passed Test PreProd')) {
                sUserStoryId.add(oUserStory.Id);
            }
        }
        if(sUserStoryId.size() > 0) {
        List<TRAK_Regression_Defect__c> lRegDefect = [Select Id , Name, Defect__r.User_Story__c from TRAK_Regression_Defect__c 
        where Defect__r.User_Story__c in :sUserStoryId and Status__c != 'Passed Test' AND Status__c != 'Passed Test PreProd' ];
        if(lRegDefect.size() > 0) {
            for(TRAK_Regression_Defect__c oRegression : lRegDefect) {
                sUserStoryWithDefects.add(oRegression.Defect__r.User_Story__c);
            }
        }
        }
        
        if(sUserStoryWithDefects.size() > 0) {
        for(TRAK_User_Story__c oUserStory : lUserStory) {
        if(sUserStoryWithDefects.contains(oUserStory.Id)) {
            oUserStory.addError(Label.TRAK_Regression_Defect_User_Story_Error);
        }
        }
        }
    }

    public static void addDesignBeforePassingUS(List < TRAK_User_Story__c > lUserStory, Map<Id , TRAK_User_Story__c> mUserStory) {
        Set<String> sUserStoryId = new Set<String>();
        Map<Id, TRAK_User_Story__c> mUS = new Map<Id, TRAK_User_Story__c>();
        for(TRAK_User_Story__c oUserStory : lUserStory) {
            if((oUserStory.Development_Stage__c == 'Ready for Test Release') || 
            (oUserStory.Development_Stage__c == 'Ready for Test PreProd')) {
                sUserStoryId.add(oUserStory.Id);
            }
        }
        
        if(sUserStoryId.size() > 0) {
         for(TRAK_User_Story__c oUS : [Select Id, 
         (Select Id from TRAK_Req2Design__r where Design__r.Approval_Status__c = 'Approved') from TRAK_User_Story__c 
         where Id IN :sUserStoryId]) {
         mUS.put(oUS.Id, oUS);
         }
         
         for(TRAK_User_Story__c oUserStory : lUserStory) {
         if((mUS.get(oUserStory.Id).TRAK_Req2Design__r == null)  ||
         (mUS.get(oUserStory.Id).TRAK_Req2Design__r.size() == 0)) {
         oUserStory.addError(Label.TRAK_Design_Error);
         }
         }
         }
        
    }

    public static void setApprovalStatusToOpen(List < TRAK_User_Story__c > lUserStory, Map < Id, TRAK_User_Story__c > mUserStoryOld) {
        Map < Id, TRAK_User_Story__c > mApprovalHistory = new Map < Id, TRAK_User_Story__c > ([Select Id, Name, (Select Id, Name from User_Story_Approval_History__r where Approval_Status__c = 'Pending Approval') from TRAK_User_Story__c
            where ID IN: lUserStory
        ]);
        for (TRAK_User_Story__c oUserStory: lUserStory) { // I_Want_To__c, So_that__c
            if ((oUserStory.Acceptance_Criteria__c != mUSerStoryOld.get(oUserStory.Id).Acceptance_Criteria__c) ||
                (oUserStory.As_A_text__c != mUSerStoryOld.get(oUserStory.Id).As_A_text__c) ||
                (oUserStory.I_Want_To__c != mUSerStoryOld.get(oUserStory.Id).I_Want_To__c) ||
                (oUserStory.So_that__c != mUSerStoryOld.get(oUserStory.Id).So_that__c)) {
                oUserStory.Approval_Status__c = 'Open';
                oUserStory.TRAK_Business_Quality_Approval_Date__c = null;
                oUserStory.TRAK_Business_Quality_Approved__c = false;
                oUserStory.TRAK_Computer_System_Qty_Approval_Date__c = null;
                oUserStory.TRAK_Computer_Systems_Quality_Approved__c = false;
                oUserStory.TRAK_System_Custodian_Approval_Date__c = null;
                oUserStory.TRAK_System_Custodian_Approved__c = false;
                oUserStory.TRAK_System_Owner_Approval_Date__c = null;
                oUserStory.TRAK_System_Owner_Approved__c = false;
                try {
                    if (mApprovalHistory.get(oUserStory.Id) != null) {
                        if (mApprovalHistory.get(oUserStory.Id).User_Story_Approval_History__r.size() > 0) {
                            TRAK_SubmitForApproval.recallApprovalRequest(mApprovalHistory.get(oUserStory.Id).User_Story_Approval_History__r[0].Id);
                        }
                    }
                } catch (Exception excep) {
                    TF_ErrorLogUtility.createErrorLog(excep, new TF_ErrorLogWrapper('TRAK_UserStoryTriggerClass', 'setApprovalStatusToOpen', 'TRAK_UserStoryTriggerClass - setApprovalStatusToOpen', '1'));
                }
            }
        }
    }
}