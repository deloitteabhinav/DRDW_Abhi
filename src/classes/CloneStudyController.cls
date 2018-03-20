/****************************************************************************************************************************************** 
 * Class Name   : CloneStudyController
 * Description  : Clones the study and its releated records
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with Sharing Class CloneStudyController {
    Public Project__c StudyDetails {
        get;
        set;
    }
    Public Request__c oRequest;
    List < String > sStudyAttribute = new List < String > ();
    
    //Loading the constructor
    public CloneStudyController(ApexPages.StandardController controller) {
        StudyDetails = new Project__c();
        Map < String, Schema.SObjectField > schemaFieldMap = Schema.SObjectType.project__c.fields.getMap();
               
            for (String fieldName: schemaFieldMap.keySet()) {
                sStudyAttribute.add(fieldName);
            }
            if(!test.isRunningTest()){ controller.addfields(sStudyAttribute);
        }

    //Fetching the current Record
        StudyDetails = (Project__c) controller.getrecord();
        oRequest = new Request__c();
        if(StudyDetails.DRDW_Partner__c!= NULL){
            oRequest = [SELECT recordtype.developername,id,Request_Status__c from Request__c where id =: StudyDetails.DRDW_Partner__c];
        }
        
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Are you sure you want to Clone the Existing Study? (Please note that Unique Local Identifier field wont be copied)');
        ApexPages.addMessage(myMsg);
    }
    
    
/* 
* @Method Name                    :  CloneStudy
* @Description                    :  This method clones the study and its related records
* @Return Type                    :  pagereference
* @Parameters                     :  None
*/ 
    Public PageReference CloneStudy() {
    
        //Cloning the Master Record 
        try{
        Project__c oStudyClone = StudyDetails.clone(false, true);
        If(oRequest.recordtype.developername == 'RWE_Partnership_Exploration' && oRequest.Request_Status__c == 'Accepted'){
            oStudyClone.DRDW_Partner__c = StudyDetails.DRDW_Partner__c; 
        }Else{
            oStudyClone.DRDW_Partner__c = NULL; 
        }
        oStudyClone.Study_Stage__c=NULL;
        insert oStudyClone;
        List<DRDP_Study_Molecule__c> lStudyMolecules = new List<DRDP_Study_Molecule__c>();
        List<Related_Country__c> lStudyBenifitingcountries = new List<Related_Country__c>();
        List<Study_Country__c> lStudyConductingCountries = new List<Study_Country__c>();
        List<Project__Share> lStudyTeamMembers = new List<Project__Share >();
        
        //Cloning Team Members
        for (Project__Share oShare: [Select ParentId, AccessLevel, UserOrGroupId from Project__Share where ParentId = : StudyDetails.id AND AccessLevel = 'Edit']) {
            Project__Share oTeamMember= new Project__Share();
            oTeamMember.AccessLevel = 'Edit';
            oTeamMember.UserOrGroupId = oShare.UserOrGroupId ;
            oTeamMember.ParentId=oStudyClone.id;
            lStudyTeamMembers.add(oTeamMember);
        }
        
        //Cloning all the Related Lists
        for(DRDP_Study_Molecule__c oStudyMol : [SELECT Molecule__c from DRDP_Study_Molecule__c where Project__c =: StudyDetails.id] ){
            DRDP_Study_Molecule__c  oMol = new DRDP_Study_Molecule__c();
            oMol.Molecule__c = oStudyMol.Molecule__c;
            oMol.Project__c=oStudyClone.id;
            lStudyMolecules.add(oMol);
        }
        for(Related_Country__c oCountry : [SELECT Country__c from Related_Country__c where Project__c =: StudyDetails.id] ){
            Related_Country__c  oStudyCountry = new Related_Country__c();
            oStudyCountry.Country__c=oCountry.Country__c;
            oStudyCountry.Project__c=oStudyClone.id;
            lStudyBenifitingcountries.add(oStudyCountry);
        }
        for(Study_Country__c oCountry : [SELECT Country__c from Study_Country__c where Study__c =: StudyDetails.id] ){
            Study_Country__c  oStudyCountry = new Study_Country__c();
            oStudyCountry.Country__c =oCountry.Country__c ;
            oStudyCountry.Study__c=oStudyClone.id;
            lStudyConductingCountries.add(oStudyCountry);
        }
        
        
        if(lStudyConductingCountries.size()>0){
            insert lStudyConductingCountries;
        }
        if(lStudyBenifitingcountries.size()>0){
            insert lStudyBenifitingcountries;
        }
        if(lStudyMolecules.size()>0){
            insert lStudyMolecules;
        }
        if(lStudyTeamMembers.size()>0){
            insert lStudyTeamMembers;
        }
        
        //Redirecting to the newly cloned record
        PageReference pageRef = new PageReference('/apex/CreateStudy?id='+oStudyClone.id+'&isEdit=true');
        return pageRef;
        }catch(exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, e.getmessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        
    }

}