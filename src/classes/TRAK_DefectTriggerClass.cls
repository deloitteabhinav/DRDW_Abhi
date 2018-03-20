public class TRAK_DefectTriggerClass {
public static void populateManualStep(Boolean Flag,List < TRAK_Bug__c > defect, Map < Id, TRAK_Bug__c > mapManualSteps,  Map < Id, TRAK_Bug__c > oldMapManualSteps) {
 if(!defect.isEmpty() && flag){
            
            for (TRAK_Bug__c bug: defect) {
                if(bug.Release_Comment__c!='' && bug.Release_Comment__c!=null)
                    bug.Has_Pre_Manual_Steps__c=true;
                else if(bug.Release_Comment__c=='' || bug.Release_Comment__c==null)
                    bug.Has_Pre_Manual_Steps__c=false;
                if(bug.Post_Deployment_Manual_steps__c!='' && bug.Post_Deployment_Manual_steps__c!=null)
                    bug.Has_Post_Manual_Steps__c=true;
                else if(bug.Post_Deployment_Manual_steps__c=='' || bug.Post_Deployment_Manual_steps__c==null)
                    bug.Has_Post_Manual_Steps__c=false;
                if(bug.Data_Steps__c!='' && bug.Data_Steps__c!=null)
                    bug.Has_Data_Steps__c=true;
                else if(bug.Data_Steps__c=='' || bug.Data_Steps__c==null)
                    bug.Has_Data_Steps__c=false;
                if(bug.Validation_steps__c!='' && bug.Validation_steps__c!=null)
                    bug.Has_Validation_Steps__c=true;
                else if(bug.Validation_steps__c=='' || bug.Validation_steps__c==null)
                    bug.Has_Validation_Steps__c=false;
        
            }
        
    }
    else if(!mapManualSteps.isEmpty() && !flag){
    
        
         for (TRAK_Bug__c bugObj: mapManualSteps.values()) {
             if(bugObj.Release_Comment__c!=oldMapManualSteps.get(bugObj.id).Release_Comment__c){
                if(bugObj.Release_Comment__c!='' && bugObj.Release_Comment__c!=null)
                    bugObj.Has_Pre_Manual_Steps__c=true;
                else
                    bugObj.Has_Pre_Manual_Steps__c=false;
             }
              if(bugObj.Post_Deployment_Manual_steps__c!=oldMapManualSteps.get(bugObj.id).Post_Deployment_Manual_steps__c){
                if(bugObj.Post_Deployment_Manual_steps__c!='' && bugObj.Post_Deployment_Manual_steps__c!=null)
                    bugObj.Has_Post_Manual_Steps__c=true;
                else
                    bugObj.Has_Post_Manual_Steps__c=false;
              }
              if(bugObj.Data_Steps__c!=oldMapManualSteps.get(bugObj.id).Data_Steps__c){
                if(bugObj.Data_Steps__c!='' && bugObj.Data_Steps__c!=null)
                    bugObj.Has_Data_Steps__c=true;
                else
                    bugObj.Has_Data_Steps__c=false;
              }
              if(bugObj.Validation_steps__c!=oldMapManualSteps.get(bugObj.id).Validation_steps__c){
                if(bugObj.Validation_steps__c!='' && bugObj.Validation_steps__c!=null)
                    bugObj.Has_Validation_Steps__c=true;
                else
                    bugObj.Has_Validation_Steps__c=false;
              }
            
         }
        
    }
}

public static void validateAllRegressionDefectsPassed(List<TRAK_Bug__c> lDefect, Map<Id,TRAK_Bug__c> lDefectOld) {
Set<Id> sDefect = new Set<Id>();
for(TRAK_Bug__c oDefect : lDefect) {
if((oDefect.Status__c.containsIgnoreCase('Passed'))) {
    sDefect.add(oDefect.Id);
}
}

if(sDefect.size() > 0) {
Map<Id , TRAK_Bug__c> mRegressionDefects = new Map<Id , TRAK_Bug__c> ([Select Id, (Select Id from
Regression_Defects__r where (Status__c != 'Passed Test' AND Status__c != 'Passed Test PreProd')) from TRAK_Bug__c where Id IN :sDefect]);
if(mRegressionDefects.size() > 0) {
for(TRAK_Bug__c oDefect : lDefect) {
if(mRegressionDefects.get(oDefect.Id) != null && mRegressionDefects.get(oDefect.Id).Regression_Defects__r != null 
 && mRegressionDefects.get(oDefect.Id).Regression_Defects__r.size() > 0) {
oDefect.addError(Label.TRAK_Regression_Defect_Error);
}
}

}
}
}

public static void populateNumberOfDefects(List<TRAK_Bug__c> lUserStory, List<TRAK_Bug__c> lUserStoryOld) {
        Set<Id> sRelease = new Set<Id>();
        List<TRAK_Release__c> lRelease = new List<TRAK_Release__c> ();
        for(TRAK_Bug__c oUserStory : lUserStory) {
        if(oUserStory.Production_Release__c != null) {
                sRelease.add(oUserStory.Production_Release__c);
                }
                
        }
        for(TRAK_Bug__c oUserStory : lUserStoryOld) {
        if(oUserStory.Production_Release__c != null) {
                sRelease.add(oUserStory.Production_Release__c);
                }
                
        }
        Set<ID> sReleaseUpdate = new Set<ID>();
        if(sRelease.size() > 0) {
        
        AggregateResult[] sumRelease = [Select COUNT(id) numberOfUserStories, Production_Release__c from TRAK_Bug__c where 
        Production_Release__c != null and Production_Release__c IN :sRelease group by Production_Release__c];
        TRAK_Release__c oRelease;
        if(sumRelease.size() > 0) {
        for(AggregateResult ar : sumRelease) {
        oRelease = new TRAK_Release__c();
        oRelease.Id = String.ValueOf(ar.get('Production_Release__c'));
        oRelease.Number_of_Defects__c = Integer.valueOf(ar.get('numberOfUserStories'));
        sReleaseUpdate.add(oRelease.Id);
        lRelease.add(oRelease);
        }
        }
        
        //TRAK_Release__c oRelease;
        for(ID oReleaseId : sRelease) {
        if(!sReleaseUpdate.contains(oReleaseId)) {
        oRelease = new TRAK_Release__c();
        oRelease.Id = oReleaseId;
        oRelease.Number_of_Defects__c = 0;
        sReleaseUpdate.add(oReleaseId);
        lRelease.add(oRelease);
        }
        }
        
        try {
        update lRelease;
        }
        catch(Exception e) {
        lUserStory[0].addError('Error while updating User Story Count:'+e.getMessage());
        }
        }
    }
    
    

}