/******************************************************************************************************************************************
 * Class Name   : Study_TriggerHandler
 * Description  : Trigger Handler Class for Studies
 * Created By   : Deloitte Consulting
 *
 *****************************************************************************************************************************************/
Public with sharing class Study_TriggerHandler {

    /*
    * @Method Name                    :  ClearTPOLocation
    * @Description                    :  Method to Clear TPO Location if Execution Resource is not TPO
    * @Return Type                    :  void
    * @Parameters                     :  lStudies
    */

    public static void ClearTPOLocation(List < Project__c > lStudies) {
        For(Project__c oStudy : lStudies) {
            If(oStudy.Execution_Resource__c != 'TPO') {
                oStudy.TPO_Location__c = NULL;
            }
        }
    }


    /*
    * @Method Name                    :  QuestionnaireNeedsReview
    * @Description                    :  Method to check if any of the fields are changed in the fieldset.
    * @Return Type                    :  void
    * @Parameters                     :  lStudies
    */

    public static void QuestionnaireNeedsReview(List < Project__c > lStudies, Map<Id, Project__c> mStudies) {

        Set<String> sFieldSet = new Set<String>();
        List<Project__c> lStudiesUpdate = new List<Project__c>();
        For(Schema.FieldSetMember fields : Schema.SObjectType.Project__c.fieldSets.getMap().get('QuestionnaireFields').getFields()) {
            sFieldSet.add(fields.getFieldPath());
        }

        For(Project__c oProject: lStudies) {
            for (string s : sFieldSet) {
                if (oProject.get(s) != mStudies.get(oProject.Id).get(s) && oProject.Study_Stage__c != NULL && oProject.Study_Stage__c != '' && oProject.Classification__c == 'Study' && oProject.Study_Stage__c != 'Questionnaire Needs Review') {
                    oProject.Study_Stage__c = ' Questionnaire Needs Review';
                }
            }
        }
    }

    
    
    //This class is made to enforce without sharing method
        Public without sharing class CopyPMClass {

        /*
         * @Method Name                    :  CopyPM
         * @Description                    :  Method to add PM to Sharing Table
         * @Return Type                    :  void
         * @Parameters                     :  lStudies
         */

        Public void CopyPM(List < Project__c > lStudies) {
            Map < Id, Set < Id >> mCurrentSharingForStudies = new Map < Id, Set < Id >> ();
            Map < Id, Set < Id >> mPM = new Map < Id, Set < Id >> ();
            List < Project__Share> lShare = new List < Project__Share > ();

            for (Project__Share oShare : [Select ParentId, AccessLevel, UserOrGroupId from Project__Share where ParentId IN: lStudies AND(AccessLevel = 'Edit'
                    OR AccessLevel = 'All')]) {
                if (!mCurrentSharingForStudies.containsKey(oShare.ParentId)) {
                    mCurrentSharingForStudies.put(oShare.ParentId, new Set < id > {
                        oShare.UserOrGroupId
                    });
                } else {
                    mCurrentSharingForStudies.get(oShare.ParentId).add(oShare.UserOrGroupId);
                }

            }
            for (Project__c oStudies : lStudies) {
                mPM.put(oStudies.Id, new set < Id > ());
                if ((oStudies.Project_Manager__c != NULL && (!mCurrentSharingForStudies.containsKey(oStudies.Id) || !mCurrentSharingForStudies.get(oStudies.Id).contains(oStudies.Project_Manager__c ))) && oStudies.Project_Manager__c != oStudies.Ownerid) {
                    mPM.get(oStudies.Id).add(oStudies.Project_Manager__c);
                }
            }


            for (Id oShare : mPM.keyset()) {
                for (Id sId : mPM.get(oShare)) {
                    Project__Share oStudyShare = new Project__Share();
                    oStudyShare.UserOrGroupId = sId;
                    oStudyShare.AccessLevel = 'Edit';
                    oStudyShare.ParentId = oShare;
                    lShare.add(oStudyShare);
                }
            }

            If(!lShare.IsEmpty()) {
                database.insert(lShare, true);
            }


        }
    }
    
    // This class is made to enforce without sharing method
    Public without sharing class RemovePMClass {


        /*
         * @Method Name                    :  RemovePM
         * @Description                    :  Method to Remove Approver and PM to Sharing Table
         * @Return Type                    :  void
         * @Parameters                     :  lBusinessPlanning,mStudies
         */
        Public void RemovePM(List < Project__c > lStudy, Map < Id, Project__c > mStudies) {

            Map < Id, Set < id >> mPMtoRemove = new Map < id, Set < id >> ();
            Map < Id, Set < Id >> mCurrentSharingForStudies = new Map < Id, Set < Id >> ();
            Set < Id > lProject = new Set < Id > ();

            for (Project__c oStudy : lStudy) {
                If(oStudy.Id != NULL) {
                    lProject.add(oStudy.Id);
                }
            }

            for (Project__Share oShare : [Select ParentId, AccessLevel, UserOrGroupId from Project__Share where ParentId IN: lProject AND(AccessLevel = 'Edit'
                                               OR AccessLevel = 'All')]) {
                if (!mCurrentSharingForStudies.containsKey(oShare.ParentId)) {
                    mCurrentSharingForStudies.put(oShare.ParentId, new Set < id > {
                        oShare.UserOrGroupId
                    });
                } else {
                    mCurrentSharingForStudies.get(oShare.ParentId).add(oShare.UserOrGroupId);
                }
            }

            For(Project__c oStudy: lStudy) {
                Project__c oldStudy = mStudies.get(oStudy.id);
                If(oldStudy.Project_Manager__c != oStudy.Project_Manager__c) {
                    if (!mPMtoRemove.containsKey(oldStudy.id)) {
                        mPMtoRemove.put(oldStudy.id, new Set < id > {
                            oldStudy.Project_Manager__c
                        });
                    } else {
                        mPMtoRemove.get(oldStudy.id).add(oldStudy.Project_Manager__c);
                    }
                }
            }
            List < Project__Share > lShareToDelete = new List < Project__Share > ();
            List < Project__Share > lShare = new List < Project__Share > ();
            lShare = [Select ParentId, AccessLevel, UserOrGroupId from Project__Share where ParentId IN: mStudies.KeySet() AND AccessLevel = 'Edit'];
            If(!mPMtoRemove.IsEmpty() && !lShare.IsEmpty()) {
                For(Project__Share oShare: lShare) {
                    If(mPMtoRemove.containsKey(oShare.ParentId) && mPMtoRemove.get(oShare.ParentId).contains(oShare.UserOrGroupId)) {
                        lShareToDelete.add(oShare);
                    }
                }
            }

            If(!lShareToDelete.IsEmpty()) {
                Database.delete(lShareToDelete, false);
            }
        }
    }

}