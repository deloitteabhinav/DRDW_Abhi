/*
*@ Class Name                                                    : FeedbackReport
*@ Description                                                   : Controller class for showing a link to Custom UI Report on feedback detail page
*@ CreatedBy                                                     : Waseem Sabeel
*@ CreatedOn                                                     : 10th December 2015
*/

public with sharing class FeedbackReport
{
public string FBID {get;set;}
public string FBname {get;set;}
private Feedback__c oFeedback;
public Map<String,List<Feedback_Providers__c>> mResponders {get;set;}
public Map<String,String> mOuter {get;set;}
public Map<String,List<WReviews>> mInner {get;set;}
public boolean bIsError{get;set;}
public boolean bIsReminder{get;set;}
public boolean bIsDisabled{get;set;}

    //Constructor
     Public FeedbackReport(ApexPages.StandardController stdCon)
     {
        mResponders = new Map <String, List<Feedback_Providers__c>>();
        mOuter= new Map<String,String>();
        mInner= new Map<String,List<WReviews>>();
         //Initialising KEYs of the Responder Map
        mResponders.put(Constants.sFeedbackStatusSent,new List<Feedback_Providers__c>());
        mResponders.put(Constants.sFeedbackStatusSubmitted,new List<Feedback_Providers__c>());
        mResponders.put(Constants.sFeedbackStatusSaved,new List<Feedback_Providers__c>());
        FBID = stdCon.getRecord().Id;
        bIsDisabled = FALSE;
    }
    
/*******************************************
Method Name         :        SendReminder
Description        :        This method sends reminder mails to all those Users who have not yet submitted the Feedback
********************************************/  
    Public pagereference SendReminder()
     {
         list<Feedback_Providers__c> lNotYetResponded = new list<Feedback_Providers__c>();
         for(Feedback_Providers__c oFBP:mResponders.get(Constants.sFeedbackStatusSent))
         {
            oFBP.Send_Reminder__c= TRUE;
            lNotYetResponded.add(oFBP);    
         }
         for(Feedback_Providers__c oFBP:mResponders.get(Constants.sFeedbackStatusSaved))
         {
            oFBP.Send_Reminder__c= TRUE;
            lNotYetResponded.add(oFBP);    
         }
         update lNotYetResponded;
         bIsDisabled = TRUE;
         Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.INFO,'Reminder Sent to Feedback Providers who have not submitted their feedbacks.'));
         return null;
     }
     
/*******************************************
Method Name         :        RedirectChecker
Description        :        This method is called on page load.
********************************************/  
    Public pagereference RedirectChecker()
     {
        if ( FBID == NULL || FBID =='')
        {
            Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.ERROR,'You need to have a Feedback ID to view the corresponding Report!'));
            bIsError=true;
            return null;
        } 
        else
        {
            oFeedback=[select id,OwnerId from Feedback__c where ID =:FBID][0];
            if(oFeedback.OwnerId != UserInfo.getUserId() && 
                     [SELECT AssigneeId FROM PermissionSetAssignment 
                     WHERE PermissionSet.Name =: Constants.sSMINAdminPermissionAPI AND AssigneeId=:UserInfo.getUserId()].size()==0 &&
                     [SELECT Id,Feedback_Provider__c from Feedback_Providers__c where Feedback_Provider__c =: UserInfo.getUserId() AND Feedback_Id__c =: FBID].size()== 0
                   ){
                Apexpages.addmessage(new Apexpages.Message(ApexPages.Severity.ERROR,'You do not have the permission to access this report!'));
                bIsError=TRUE;
                return null;
            }
  
            Else if(oFeedback.OwnerId != UserInfo.getUserId() && 
                     [SELECT AssigneeId FROM PermissionSetAssignment 
                     WHERE PermissionSet.Name =: Constants.sSMINAdminPermissionAPI AND AssigneeId=:UserInfo.getUserId()].size()==0 &&
                     [SELECT Id,Feedback_Provider__c from Feedback_Providers__c where Feedback_Provider__c =: UserInfo.getUserId() AND Feedback_Id__c =: FBID].size() > 0
                   ){
                PageReference Redirect = new PageReference('/apex/Fill_Survey?id=' + FBID);
                Redirect.setRedirect(TRUE);
                return Redirect;
            }
            else 
            {   //Success - Page with values coming from 3 Maps
                bIsError=false;
                List<Feedback_Providers__c> lResponders = new List<Feedback_Providers__c>();
                lResponders=[select Feedback_Provider__r.Name,Status__c,Feedback_Id__c,Feedback_Id__r.Name from Feedback_Providers__c where Feedback_Id__c=:FBID];
                FBname=lResponders[0].Feedback_Id__r.Name;
    
                /*****  populating the Responder Map with Status mapped to List of Feedback Providers *****/
                for (Feedback_Providers__c oFBP: lResponders) 
                {
                    mResponders.get(oFBP.Status__c).add(oFBP);
                }
                
                If(mResponders.get(Constants.sFeedbackStatusSent).size()>0 || mResponders.get(Constants.sFeedbackStatusSaved).size()>0){  
                    bIsReminder=TRUE; 
                }
                else{
                    bIsReminder=FALSE; 
                }
               
                /***** populating the Outer Map with 'QuestionID+ContactID' ==> 'QuestionText+ContactName' *****/
                For (Review__c oRev: [select Question__c,Question_Text__c,Contact__c,Contact__r.Name,Feedback_Provider__c
                    from Review__c where Feedback_Provider__c=:lResponders[0].Id])
                {   
                    if(oRev.Contact__c!=NULL)
                    {   
                        mOuter.put(String.valueOf(oRev.Question__c)+String.valueOf(oRev.Contact__c),oRev.Question_Text__c+' - '+oRev.Contact__r.Name);
                    }
                    else
                    {
                        mOuter.put(String.valueOf(oRev.Question__c),oRev.Question_Text__c);
                    }   
                    
                }
    
                /***** populating the Inner Map with 'QuestionID+ContactID' ==> List<ReviewWrapper>(FBPName,Answer) ****/
                String tempKey='';
                For (Review__c oRev: [select Question__c,Question_Text__c,Contact__c,Contact__r.Name,Feedback_Provider__c,Feedback_Provider__r.Feedback_Provider__r.Name,Answer__c 
                    from Review__c 
                    where Feedback_Provider__c IN :lResponders])
                {   
                    tempKey=oRev.Contact__c!=NULL?String.valueOf(oRev.Question__c)+String.valueOf(oRev.Contact__c):String.valueOf(oRev.Question__c);
                    if(mInner.containskey(tempKey))
                    {
                        mInner.get(tempKey).add(new WReviews(oRev.Feedback_Provider__r.Feedback_Provider__r.Name,oRev.Answer__c));
                    }
                    else
                    {
                        mInner.put(tempKey, new List<WReviews>{new WReviews(oRev.Feedback_Provider__r.Feedback_Provider__r.Name,oRev.Answer__c)} );
                    }
                }
                return null;
            }
        }
     }

/*
*@ Class Name                                                    : WReviews
*@ Description                                                   : Wrapper class for wrapping the Feedback Provider Name with their Responses
*/
    public class WReviews
    {
        public string ReviewFBPName{get;set;}
        public string ReviewAnswer{get;set;}
    
        public WReviews(string FBPName, string Answer)
        {
            this.ReviewFBPName=FBPName;
            this.ReviewAnswer=Answer;
        }
    }
}