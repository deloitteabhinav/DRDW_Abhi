@RestResource(urlMapping='/TRAK_Webhook2Github')
global class TRAK_Webhook2Github{

    @HttpPost
    Global static boolean TRAK_Webhook2Github() {
        RestRequest req = RestContext.request;
        List<String> lRelatedDetails = new List<String>();
        
        
        if(req.requestBody!=null){
            
            //TRAK_Webhook cWebhook= TRAK_Webhook.parse(req.requestBody.toString().trim());
            TRAK_Webhook cWebhook= TRAK_Webhook.parse(req.requestBody.toString());
                       
            Pattern pDefectPattern = Pattern.compile('DEF-[0-9]*');
            
            Matcher mDefectmatcher = pDefectPattern.matcher(cWebhook.head_commit.message.normalizeSpace());
      
            while (mDefectmatcher.find()) {
                lRelatedDetails.add(mDefectmatcher.group(0));
            }
            
            Pattern pUserStoryPattern = Pattern.compile('US-[0-9]*');
            
            Matcher mUserstorymatcher = pUserStoryPattern.matcher(cWebhook.head_commit.message.normalizeSpace());
      
            while (mUserstorymatcher.find()) {
                lRelatedDetails.add(mUserstorymatcher.group(0));
            }
                
  
            //Insert Git record from the head message
            TRAK_Git_Commit__c oGit= new TRAK_Git_Commit__c ();
            oGit.Commit_ID__c= cWebhook.head_commit.Id;
            oGit.Author__c = cWebhook.head_commit.author.name;
            oGit.Commit_Comment__c = cWebhook.head_commit.message.normalizeSpace();
            oGit.Link__c = cWebhook.head_commit.url;
            insert oGit; 
            
            //Query defect record if the commit is for defect            
            List<TRAK_Bug__c> lDefects = [Select id from TRAK_Bug__c where name =: lRelatedDetails limit 50];

            if(lDefects.size()>0){
                List<TRAK_Defect_Commit__c> lDefectCommit = new List<TRAK_Defect_Commit__c>();
                for(TRAK_Bug__c oDefect : lDefects){
                    TRAK_Defect_Commit__c oDefectLink  = new TRAK_Defect_Commit__c();
                    oDefectLink.Defect__c = oDefect.Id;
                    oDefectLink.Git_Commit__c = oGit.Id;
                    lDefectCommit.add(oDefectLink);
                }
                Insert lDefectCommit;
            }
            
            //Query defect record if the commit is for defect. we want to error out if US too fails from the commit            
            List<TRAK_User_Story__c> lUserStories = [Select id from TRAK_User_Story__c where name =: lRelatedDetails limit 50];
            
            if(lUserStories.size() > 0) {
                List<TRAK_US_Commit__c > lUserStoryCommit = new List<TRAK_US_Commit__c >();
                
                for(TRAK_User_Story__c oUserStory : lUserStories ){
                    TRAK_US_Commit__c oUSLink  = new TRAK_US_Commit__c();
                    oUSLink.User_Story__c= oUserStory.Id;
                    oUSLink.Git_Commit__c = oGit.Id;
                    lUserStoryCommit.add(oUSLink);         
                }
                Insert lUserStoryCommit;   
            }
                                   
        }
        
        return true ;
    }
}