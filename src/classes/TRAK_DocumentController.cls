/****************************************************************************************************************************************** 
* Class Name   : automateBurnDown
* Description  : This is a class that will both create the initial burndown records + updated them when user stories are closed    
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/

public  class TRAK_DocumentController {

    public String Definitions { get; set; }
    private String                          soql                    {get;set;}
    public TRAK_Release__c oRelease {set;get;}
    public list<cUS>                        lstUS                   {get;set;}
    public list<TRAK_User_Story__c>           lstFullUS               {get;set;}
    public list<TRAK_User_Story__c>            selectedUS              {get;set;}
    public list<TRAK_User_Story__c>            unselectedUS              {get;set;}
    private set<TRAK_User_Story__c>            selectedSetUS           {get;set;}
    private set<TRAK_User_Story__c>            unselectedSetUS           {get;set;}
    public List<FieldHistory> lHistory {set;get;}
    
    public TRAK_User_Story__c                  initUS                  {get;set;}
    
    public list<id>                         lstSprintProposed      {get;set;}
    public list<id>                         lstSprintAllocated      {get;set;}
    public list<SelectOption>               optionsAllocatedSprint  {get;set;}
    public list<SelectOption>               optionsProposedSprint   {get;set;}
    public list<string>                     DevelopmentStage        {get;set;}
    
    public list<cUS>                        userStoriesList         {get;set;}
    public map<string,Id> MapSelOps = new Map<string,Id>();
    public map<TRAK_Design__c,list<TRAK_User_Story__c>> designQuery         {get;set;}  
    
    // Map added to show Functional Document .
    public map<string,list<TRAK_User_Story__c>> Func_UserStory         {get;set;} 
    
    public string AuthorRole                                        {get;set;}
    public string Author                                            {get;set;}
    public string ReviewAuthorRole1                                 {get;set;}
    public string ReviewAuthor1                                     {get;set;}
    public string ReviewAuthorRole2                                 {get;set;}
    public string ReviewAuthor2                                     {get;set;}
    public string ReviewAuthorRole3                                 {get;set;}
    public string ReviewAuthor3                                     {get;set;}
    public string ReviewAuthorRole4                                 {get;set;}
    public string ReviewAuthor4                                     {get;set;}
    public string ReviewAuthorRole5                                 {get;set;}
    public string ReviewAuthor5                                     {get;set;}
    
     public string Project_Name {get;set;}  
    public string Deliverable_Id {get;set;}  
    public string Version{get;set;}  
    public string Change_Desp{get;set;} 
    public boolean SelectAll {get;set;}
    public string Organization {get; set;}
    public List<SelectOption> ProjNameList = new List<SelectOption>();
    public boolean DefinitionsExist {get;set;}    
    public boolean ReferencesExist {get;set;}
    public String ReleaseId {set;get;}
    public List<TRAK_Bug__c> lDefect {set;get;}
    
    public List<SelectOption> getProjNameList(){
        List<SelectOption> TempSelOpt = new List<SelectOption>();
        TempSelOpt.add(new SelectOption('--None--', '--None--'));
        return TempSelOpt;
    }  
    
    public list<cUS> getUserStories() {
         userStoriesList = new list<cUS>();
         if (lstFullUS != null){
            for(TRAK_User_Story__c s: lstFullUS) {
                userStoriesList.add(new cUS(s,SelectAll));
            }
        }
        return userStoriesList;
    }
    
    public List<ProcessInstance> lApprovalHistory {set;get;}
    public TRAK_DocumentController() {
        ReleaseId = ApexPages.currentPage().getParameters().get('ReleaseId');
        oRelease = new TRAK_Release__c();
        lstFullUS = new List<TRAK_User_Story__c>();
        selectedUS = new List<TRAK_User_Story__c>();
        lDefect = new List<TRAK_Bug__c>();
        if(ReleaseId != null) {
        lHistory = new List<FieldHistory>();
        List<TRAK_Release__c> lRelease = [Select Id,Name, Code_Handover_Date__c,Number_of_User_Stories__c, Number_of_Defects__c,  Tag__c, Branch_Name__c, Repository_Name__c, Commit_Id__c, 
        Release_Date__c, (SELECT Id, IsDeleted, ParentId, CreatedBy.Name, CreatedDate, Field, OldValue, NewValue FROM Histories order by CreatedDate desc) from TRAK_Release__c where Id = :ReleaseId];
        lApprovalHistory = [SELECT Id, CompletedDate, (SELECT Id, StepStatus, Comments,Actor.Name, OriginalActor.Name, CreatedDate
         FROM StepsAndWorkitems order by Id Desc)
        FROM ProcessInstance where TargetObjectId = :ReleaseId order by CompletedDate desc];
        if(lRelease.size() > 0) {
         version = lRelease[0].Name;
         if(lRelease[0].Histories.size() > 0) {
             for(TRAK_Release__History relHistory : lRelease[0].Histories) {
                 FieldHistory fieldHistObj = new FieldHistory(relHistory.OldValue, relHistory.newValue, relHistory.CreatedDate, relHistory.Createdby.Name);
                 if((relHistory.OldValue != null) || (relHistory.NewValue != null)) {
                 fieldHistObj.action = ('Changed '+TRAK_Release__c.SobjectType.getDescribe().fields.getMap().get(relHistory.Field).getDescribe().getLabel()+' from '+relHistory.OldValue+' to '+relHistory.NewValue).capitalize();                 
                 } else {
                 fieldHistObj.action = String.valueOf(relHistory.Field).capitalize();
                 }
                 if((relHistory.Field == 'Approver__c') ||  (relHistory.Field == 'Business_Analyst__c') ||  (relHistory.Field == 'Product_Owner__c') ||   (relHistory.Field == 'Release_Lead__c') ||  (relHistory.Field == 'System_Custodian__c')) {
                     if((relHistory.OldValue != null && !(String.valueOf(relHistory.OldValue).contains('005'))) || 
                      (relHistory.NewValue != null && !String.valueOf(relHistory.NewValue).contains('005'))) {
                 lHistory.add(fieldHistObj);     
                      }
                 } else {
                 
                 lHistory.add(fieldHistObj);
                 }
             }
         }
         oRelease = lRelease[0];
         Author = 'Eli Lilly';
         Organization = 'Eli Lilly';
         }
        
        lDefect = [Select id, Name, Root_Cause__c , Resolution__c, Status__c,Problem__c from TRAK_Bug__c where Production_Release__c = :ReleaseId];
         
        }
        soql = 'SELECT Name, As_A_Text__c, I_Want_To__c, So_that__c, Story_Points_Total__c, Development_Stage__c, Proposed_Sprint__c, Allocated_Sprint__c, Functional_Area__c,  User__r.Name, QRCode__c  FROM TRAK_User_Story__c ';
        
        initUS = new TRAK_User_Story__c();
        selectedUS = new list<TRAK_User_Story__c>();
        selectedsetUS = new set<TRAK_User_Story__c>();
        unselectedUS = new list<TRAK_User_Story__c>();
        unselectedsetUS = new set<TRAK_User_Story__c>();
        optionsAllocatedSprint = new list<selectOption>();
        optionsProposedSprint = new list<selectOption>();
        initSprint();
        selectAll = false;
        lstFullUS = Null;
        userStoriesList = Null;
        if(ReleaseId != null) {
            createDocument();
        }
    }
    
    private void initSprint() {
        lstSprintProposed = new list<id>(); 
        lstSprintAllocated = new list<id>();     
        
        for(TRAK_Sprint__c s: [SELECT Name FROM TRAK_Sprint__c]) {
            optionsAllocatedSprint.add(new SelectOption(s.Id,s.Name));  
            optionsProposedSprint.add(new SelectOption(s.Id,s.Name));  
        }
    }
    
     
    
    public void createQuerySOQL() {
        // Set up SOQL
        soql = 'SELECT Name, As_A_Text__c, I_Want_To__c, So_that__c, Development_Stage__c, Proposed_Sprint__c, Allocated_Sprint__c, Story_Points_Total__c, Functional_Area__c, Sub_Process__c, Developer__r.Name, Supporting_BA__r.Name, User__r.Name, QRCode__c FROM TRAK_User_Story__c ';

               if(lstSprintProposed.size() > 0) {
            soql = soql + ' WHERE Proposed_Sprint__c IN :lstSprintProposed ';
        }
        
        if(lstSprintAllocated.size() > 0) {
            if (lstSprintProposed.size() > 0){
                    soql = soql + ' AND Allocated_Sprint__c IN :lstSprintAllocated ';
            }
            else{        
                soql = soql + ' WHERE Allocated_Sprint__c IN :lstSprintAllocated ';
            }
        }
        
        if (initUS.Development_Stage__c != null){
            if(soql.contains('WHERE') ) {
                soql = soql + ' AND Development_Stage__c = \'' + initUS.Development_Stage__c + '\' ';
            }
            else {
                soql = soql + ' WHERE Development_Stage__c = \'' + initUS.Development_Stage__c + '\' ';
            }
        }
        
        if(initUS.Functional_Area__c != null) {
            if(soql.contains('WHERE')) {
                soql = soql +  ' AND Functional_Area__c = \'' + initUS.Functional_Area__c + '\' ';
            }
            else {
                soql = soql +  ' WHERE Functional_Area__c = \'' + initUS.Functional_Area__c + '\' ';
            }   
        }
        
        if(initUS.Sub_Process__c != null) {
        
            if(soql.contains('WHERE')) {
                soql = soql +  ' AND Sub_Process__c = \'' + initUS.Sub_Process__c + '\' ';
            }
            else {
                soql = soql +  ' WHERE Sub_Process__c = \'' + initUS.Sub_Process__c + '\' ';
            }
        }
        
        if(sortField != null) {
            soql = soql + sortField;
        }
        
        System.Debug('SOQL value: ' +  soql);
        System.Debug('initUS: ' + initUS);
        createQuery();
    }
    
    @TestVisible
    private void createQuery() {
        try {
            lstFullUS = new list<TRAK_User_Story__c>();
            System.Debug('lstFullUS: ' + lstFullUS);
            if(ReleaseID != null) {
            lstFullUS = [SELECT Name, As_A_Text__c, Acceptance_Criteria__c, I_Want_To__c, So_that__c, Development_Stage__c, Proposed_Sprint__c, Allocated_Sprint__c, Story_Points_Total__c, Functional_Area__c, Sub_Process__c, Developer__r.Name, Supporting_BA__r.Name, User__r.Name, QRCode__c FROM TRAK_User_Story__c where Cirrus_Release__c = :ReleaseId];
            } else {
            lstFullUS = Database.Query(soql);
            }
            if (lstFullUS.size()==0)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, 'NO Records found')); 
        } 
        catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Oooooooooops. Seems like the SOQL Query was wronly created.'));
        }
    }
    
    public String sortDir {
        get {
            if (sortDir == null) {
                sortDir = 'ASC';
            }
            return sortDir;
        }
        set;
    }
    
    public String sortField {
        get {
            if(sortField == null) {
                sortField = 'Name';
            }
            return ' ORDER BY ' + sortField + ' ' + sortDir;
        }
        set;
    }
    
    public void toggleSort() {
        sortDir = sortDir.equals('ASC') ? 'DESC' : 'ASC';
        createQuery();
    }
    
    public PageReference processSelected() {        
        // Iterate through the list of US and see if they are selected, if so add them to the newly created list
        
        for(cUS cUserStory: userStoriesList) {
            if(cUserStory.selected == true) {
                // See if item is not yet in the table
                selectedSetUS.add(cUserStory.reqUS);
            }
        }
        
        for(cUS cUserStory: userStoriesList) {
            if(ReleaseId != null) {
                // See if item is not yet in the table
                selectedSetUS.add(cUserStory.reqUS);
            }
        }
        
        selectedUS = new list<TRAK_User_Story__c>();
        selectedUS.addAll(selectedSetUS);
        
        System.Debug('Selected List of US: ' + selectedUS);
        selectAll = false;
        return null;
    }
    
     public PageReference processUnselected() {        
        // Iterate through the list of US and see if they are unselected, if so remove them from the newly created list
        
        for(cUS cUserStory: userStoriesList) {
            if(cUserStory.selected == false) {
                // See if item is not yet in the table
                unselectedSetUS.add(cUserStory.reqUS);
            }
        }
        unselectedUS = new list<TRAK_User_Story__c>();
        unselectedUS.addAll(unselectedSetUS);
        
        System.Debug('Unselected List of US: ' + unselectedUS);
        selectAll = false;
        return null;
    }
    
    public class cUS {
        public TRAK_User_Story__c reqUS {get; set;}
        public Boolean selected {get; set;}
        
        public cUS(TRAK_User_Story__c r) {
            reqUS = r;
            selected = false;
        }
        
        public cUS(TRAK_User_Story__c r,boolean b) {
            reqUS = r;
            selected = b;
        }
    }
    
 
    // TECHNICAL DOCUMENT
    //Public List<TRAK_Definitions__c> Definitions {get;set;}
    //Public List<TRAK_References__c> References {get;set;} 
    public Pagereference createDocument() {
        
        //Definitions = new List<TRAK_Definitions__c>();
        //References = new List<TRAK_References__c>();  
        designQuery = new map<TRAK_Design__c,list<TRAK_User_Story__c>>();
        list<id> idUS = new list<id>();
        Set <Id> US_With_Design = new Set<Id> ();
        List <string> US_NOT_DONE = new list <string> ();
        String Str = '';
        if(selectedUS == null) {
        selectedUS = new List<TRAK_User_Story__c>();
        }
        if(lstFullUS== null) {
        lstFullUS= new List<TRAK_User_Story__c>();
        }    
        if(ReleaseID != null) {
            lstFullUS = [SELECT Name, As_A_Text__c, I_Want_To__c, Acceptance_Criteria__c, So_that__c, Development_Stage__c, Proposed_Sprint__c, Allocated_Sprint__c, Story_Points_Total__c, Functional_Area__c, Sub_Process__c, Developer__r.Name, Supporting_BA__r.Name, User__r.Name, QRCode__c FROM TRAK_User_Story__c where Cirrus_Release__c = :ReleaseId];
            }
      //   ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,'line 303'+lstFullUS));         
        if (Version != '' && Organization !='' && (selectedUS.size() >0 || lstFullUS.size() > 0)) {
        
            for(TRAK_User_Story__c s: selectedUS) {
                idUS.add(s.id);
            }
            
            if(ReleaseId != null) {
             
            for(TRAK_User_Story__c s: lstFullUS) {
                idUS.add(s.id);
            }
            }
           
            for(TRAK_UserStory2Design__c u: [SELECT User_Story__c,User_Story__r.name,User_Story__r.Development_Stage__c, User_Story__r.Allocated_Sprint__r.Name,User_Story__r.Functional_Area__c,User_Story__r.Sub_Process__c,Id, Design__c,Design__r.name, Design__r.Overview__c, Design__r.Data_Model__c, Design__r.Objects__c, Design__r.Fields__c,
                                        Design__r.Apex_Classes__c, Design__r.Visualforce_Pages__c, Design__r.Page_Layouts__c, Design__r.Apex_Trigger__c, Design__r.Other_Components__c, Design__r.RecordType.Name
                                        FROM TRAK_UserStory2Design__c WHERE User_Story__c IN :idUS Order By User_Story__r.name,User_Story__r.Allocated_Sprint__r.Name,User_Story__r.Functional_Area__c,User_Story__r.Sub_Process__c ]) {
                if(designQuery.containsKey(u.Design__r)) {
                    designQuery.get(u.Design__r).add(u.User_Story__r);
                }
                else {
                    list<TRAK_User_Story__c> newList = new list<TRAK_User_Story__c>();
                    newList.add(u.User_Story__r);
                    designQuery.put(u.Design__r, newList);
                }
            }
            
            for (TRAK_Design__c D: designQuery.keyset()){
                for (TRAK_User_Story__c R : designQuery.get(D)){
                    US_With_Design.add(R.Id);
                }
            }
            
            system.debug('Design Query ' +designQuery);
            system.debug('US with design ....' + US_With_Design);
            for (TRAK_User_Story__c US:selectedUS){
                if (!US_With_Design.contains(US.Id)){
                    US_NOT_DONE.add(US.Name);
                    str = str + US.Name + ' ,';
                }
            }
            
            system.debug('US NOT DONE ' + US_NOT_DONE);
            if(US_NOT_DONE.size()>0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Please only select user stories which have a Design related to it.<br/> Below US do not have a design: <br/>' + str + '<br/>'));
                return null;
            }
            else {
              /*   if(Project_Name <> null && Project_Name != '--None--'){
                    system.debug('print the value of Project Id' + MapSelOps.get(Project_Name));
                    /*Definitions = [select id,Name,Project__c,Term_Acronym__c,Project__r.Name from TRAK_Definitions__c where Project__c =: MapSelOps.get(Project_Name)];
                    if(Definitions.size()>0){
                        DefinitionsExist = true;
                    }*/
                    //References  = [select id,Name,Document_ID__c,Project__c,Project__r.Name from TRAK_References__c where Project__c =: MapSelOps.get(Project_Name)];
                    /*if(References.size()>0){
                        ReferencesExist =true;
                    }
                }  */
            
            
                System.debug('Image:' + designQuery);
                System.Debug('SelectedUS: ' + selectedUS);
                //system.Debug('References' + References);
                //system.Debug('Definitions' + Definitions);
                System.Debug('idUS: ' + idUS);
                System.Debug('Design Query: ' + designQuery);
                PageReference p = Page.TRAK_TechnicalDesignDocumentPDF;
                  
                return p;
            }
        }
        else {
            if(selectedUS.size()==0){
            if(ReleaseId == null) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select at least one user story'));
                }
            }
            if(Version == ''){
            if(ReleaseId == null) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter a Version'));
                }
            }
            if(Organization == ''){
            if(ReleaseId == null) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter an Organization'));
                }
            }
            /* 
            if(Project_Name == '--None--'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter a Project Name'));
            } */
            return null;
        }
    }
    
    //FUNCTIONAL DOCUMENT    
    public pagereference CreateFunctionalDocument () {
        //Definitions = new List<TRAK_Definitions__c>();
        //References = new List<TRAK_References__c>();
        Func_UserStory = new map<string,list<TRAK_User_Story__c>> ();
        set<id> idUS = new set<id>();
        if (Version != '' && Organization !='' && selectedUS.size()>0 /* && Project_Name != '--None--' */)
        {
            for(TRAK_User_Story__c s: selectedUS) {
                idUS.add(s.id);
            }
            system.debug('---IdUS---'+ idUS);
            for(TRAK_User_Story__c R: [SELECT Id,As_A_Text__c,I_Want_To__c, So_that__c,Name,Allocated_Sprint__r.Name, Functional_Area__c,
                Sub_Process__c, Acceptance_Criteria__c, Compliance_Criteria__c, Story_Points_Total__c, Developer__r.Name, Supporting_BA__r.Name, User__r.Name, QRCode__c
                FROM TRAK_User_Story__c
                WHERE Id IN :idUS Order By Name,Allocated_Sprint__r.Name,Functional_Area__c,Sub_Process__c]) 
                {
                    if (!Func_UserStory.containsKey(R.Functional_Area__c))
                    Func_UserStory.put(R.Functional_Area__c,new list<TRAK_User_Story__c>());
                    system.debug('+++++++++++++++' + R.As_A_Text__c );
                If (R.As_A_Text__c != Null){
                    string temp = string.valueof(R.As_A_Text__c);
                    R.As_A_Text__c = temp.replace(';',',');
                    system.debug('+++++++++++++++' + R.As_A_Text__c );
                    }
                    Func_UserStory.get(R.Functional_Area__c).add(R);
                }
            
            Pagereference P = Page.TRAK_FunctionalDocumentPDF;
            return p;
        }
        
        else 
        {
            if(selectedUS.size()==0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select at least one user story'));
            }
            if(Version == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter a Version'));
            }
            if(Organization == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter an Organization'));
            }
            /* 
            if(Project_Name == '--None--'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter a Project Name'));
            } */
            return null;
        }
        
   }
   
   
    // QR CARD DOCUMENT
    public pagereference generateQAcards(){
        PageReference np = new PageReference('/apex/GenerateCard');
        np.setRedirect(false);
        return np;
        
    }
    
    public class FieldHistory {
    
    public Object OldValue {set;get;}
    public Object newValue {set;get;}
    public DateTime CreatedDate {set;get;}
    public String action {set;get;}
    public String actionuser {set;get;}
    public FieldHistory(Object oldValue, Object newValue, Datetime CreatedDate, String actionuser) {
        this.oldValue = oldValue;
        this.newValue = newValue ;
        this.CreatedDate= CreatedDate;
        this.actionuser= actionuser;
    }
    }
    
    public string domainName {
        get{
            if(domainName ==null){
                try{
                    Site siteObj= [select id,subdomain from site where name=:'QRScan'];
                    domainName = siteObj.subdomain;   
                    return 'https://chart.googleapis.com/chart?chf=bg,s,ffffff&cht=qr&chs=150x150&chl=https://'+domainName+'.secure.force.com/QRScan?id=';
                    
                }catch (exception e){
                    return null;
                }
            }
            else
             return null;            
        }
        private set{
        }
    }
    
}