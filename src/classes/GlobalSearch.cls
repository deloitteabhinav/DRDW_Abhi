/****************************************************************************************************************************************** 
* Class Name   : GlobalSearch
* Description  : Class for Global Search on the UI
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/
Public with sharing class GlobalSearch {
    //Instantiate the StandardSetController  
    public ApexPages.StandardSetController cStudiesListController{get;set;}
    public ApexPages.StandardSetController cPartnershipListController{get;set;}
    public ApexPages.StandardSetController cRequestListController{get;set;}
    public ApexPages.StandardSetController cLandscapeListController{get;set;}
    public ApexPages.StandardSetController cRelationshipController{get;set;}

    public Integer pNoLimit {get;set;}
    public string previousSField {get;set;}
    public string sField {get;set;}
    public string sOrder {get;set;}
    public string sFinalSort{get;set;}
    
    Public List < Integer > lStudyPageNumbers{get;private set;}
    Public List < Integer > lPartnershipPageNumbers{get;private set;}
    Public List < Integer > lRequestPageNumbers{get;private set;}
    Public List < Integer > lLandscapePageNumbers{get;private set;}
    Public List < Integer > lRelationshipPageNumbers{get;private set;}
    
    Public Integer iPageNumber{get;set;}
        
    public Decimal dStudyPageCount{get;set;}
    public Decimal dPartnershipPageCount{get;set;}
    public Decimal dRequestPageCount{get;set;}
    public Decimal dLandscapePageCount{get;set;}
    public Decimal dRelationshipPageCount{get;set;}
        
    public Boolean isStudies {get;set;}    
    public Boolean isPartnerships {get;set;}
    public Boolean isRequests {get;set;}
    public Boolean isLandscapes{get;set;}
    public Boolean isRelationships{get;set;}

    public Boolean isShrink {get;set;}
    public string sLocalSearch {get;set;}
    public Map < string, Boolean > mTimeFrameFilter {get;set;}

    Public List < Project__c > lProjects {get;set;}
    Public List < Request__c > lPartnerShips {get;set;}
    Public List < Request__c > lRequests {get;set;}
    Public List <Information_Landscape__c> lLandscapes{get;set;}
    Public List <Contact> lRelationships{get;set;}

    public Map < string, string > mURLparams = new map < string, string > ();
    public Map < String, Integer > mCategoyCount;
    Public Map < String, List < wStudyObject >> mStudyObjectStructure {get;set;}
    
    public boolean bShowMoreFlag{get;set;} 

    //Constructor of the Page
    Public GlobalSearch() {
        sField = 'Name';
        previousSField = 'Name';
        sOrder = 'ASC NULLS FIRST';
        pNoLimit = 10;
        isShrink = FALSE;
        bShowMoreFlag = True;
        mURLparams = ApexPages.currentPage().getParameters();
        mStudyObjectStructure = new Map < String, List < wStudyObject >> ();
        //Populating picklist filters
        mStudyObjectStructure.put('TherapeuticArea', populateTherapeuticArea());
        mStudyObjectStructure.put('BU', populateBU());
        mTimeFrameFilter = populateTimeFrame();

        //setting the boolean attributes to choose objects for search
            isRequests = true;
            isPartnerships = true;
            isStudies = true;
            isLandscapes = true;
            isRelationships = true;
        
        String sQuery = string.escapeSingleQuotes(sField)+' '+string.escapeSingleQuotes(sOrder);
        Query(sQuery,null);
    }
    
     /* 
     * @Method Name                    :  toggleOff
     * @Description                    :  Show More filter is toggled OFF
     * @Return Type                    :  None
     * @Parameters                     :  None
     */
    
    Public void toggleOff() {
        bShowMoreFlag= false;
    }

    
     Public List < Project__c > getStudies() {
        return (List < Project__c > ) cStudiesListController.getRecords();
    }
    Public List < Request__c > getPartnerships() {
        return (List < Request__c > ) cPartnershipListController.getRecords();
    }
    Public List < Request__c > getRequests() {
        return (List < Request__c > ) cRequestListController.getRecords();
    }
    Public List < Information_Landscape__c > getLandscapes() {
        return (List < Information_Landscape__c > ) cLandscapeListController.getRecords();
    }
    Public List < Contact > getRelationships() {
        return (List < Contact > ) cRelationshipController.getRecords();
    }

    /* 
    * @Method Name                    :  populateTherapeuticArea
    * @Description                    :  Method to populate therapeutic area picklist filter
    * @Return Type                    :  List
    * @Parameters                     :  None
    */  
    Public list < wStudyObject > populateTherapeuticArea() {

        List < wStudyObject > lPicklist = new List < wStudyObject > ();        
        for (Schema.Picklistentry oPicklistValues : Project__c.Therapeutic_Area_Primary__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wStudyObject(oPicklistValues.Value, false));
        }

        return lPicklist;
    }

    /* 
    * @Method Name                    :  populateBU
    * @Description                    :  Method to populate BU picklist filter
    * @Return Type                    :  List
    * @Parameters                     :  None
    
    */  
    Public list < wStudyObject > populateBU() {

        List < wStudyObject > lPicklist = new List < wStudyObject > ();
        for (Schema.Picklistentry oPicklistValues: Request__c.Business_Unit_Primary__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wStudyObject(oPicklistValues.Value, false));
        }

        return lPicklist;
    }


    /* 
    * @Method Name                    :  populateTimeFrame
    * @Description                    :  Method to populate Time Frame picklist filter
    * @Return Type                    :  Map
    * @Parameters                     :  None
    */  
    Public Map < string, Boolean > populateTimeFrame() {

        Map < string, Boolean > mTimeFrame = new Map < string, Boolean > ();

        mTimeFrame.put('This Year', false);
        mTimeFrame.put('This Quarter', false);
        mTimeFrame.put('This Month', false);
        mTimeFrame.put('This Week', false);
        mTimeFrame.put('Previous Years', false);

        return mTimeFrame;
    }

     /* 
    * @Method Name                    :  FrameClause
    * @Description                    :  Creating query parameters for checkboxes selected
    * @Return Type                    :  string
    * @Parameters                     :  lWrapperForProcessing
    */  
    Public string FrameClause(List < wStudyObject > lWrapperForProcessing) {
        String sClause = '';
        for (wStudyObject oWrapper: lWrapperForProcessing) {
            if (oWrapper.isSelected) {
                sClause += '\'' + oWrapper.label + '\',';
            }
        }
        if (sClause != '') {
            sClause = '(' + sClause.removeend(',') + ')';
        }
        return sClause;
    }

     /* 
    * @Method Name                    :  TimeClause
    * @Description                    :  Creating query parameters for checkboxes selected
    * @Return Type                    :  string
    * @Parameters                     :  mFilter
    */  
    Public string TimeClause(Map < string, Boolean > mFilter) {
        String sClause = '';
        if (mFilter.get('Previous Years') && (mFilter.get('This Week') == False) && (mFilter.get('This Quarter') == False) && (mFilter.get('This Year') == False) && (mFilter.get('This Month') == False)) {
            sClause = 'LAST_N_YEARS:100';
            return '(' + sClause + ')';
        }

        if (mFilter.get('Previous Years') && (mFilter.get('This Week') || mFilter.get('This Quarter') || mFilter.get('This Year') || mFilter.get('This Month'))) {
            sClause = 'LAST_N_YEARS:100,';
            if (mFilter.get('This Year')) {
                sClause += 'THIS_YEAR';
                return '(' + sClause + ')';
            }
            if (mFilter.get('This Quarter')) {
                sClause += 'THIS_QUARTER';
                return '(' + sClause + ')';
            }
            if (mFilter.get('This Month')) {
                sClause += 'THIS_MONTH';
                return '(' + sClause + ')';
            }
            if (mFilter.get('This Week')) {
                sClause += 'THIS_WEEK';
                return '(' + sClause + ')';
            }
        }

        if ((mFilter.get('Previous Years') == false) && ((mFilter.get('This Week') == true) || (mFilter.get('This Quarter') == true) || (mFilter.get('This Year') == False) || (mFilter.get('This Month') == False))) {
            sClause = '';
            if (mFilter.get('This Year')) {
                sClause += 'THIS_YEAR';
                return '(' + sClause + ')';
            }
            if (mFilter.get('This Quarter')) {
                sClause += 'THIS_QUARTER';
                return '(' + sClause + ')';
            }
            if (mFilter.get('This Month')) {
                sClause += 'THIS_MONTH';
                return '(' + sClause + ')';
            }
            if (mFilter.get('This Week')) {
                sClause += 'THIS_WEEK';
                return '(' + sClause + ')';
            }
        }

        return NULL;

    }

    /* 
    * @Method Name                    :  CombineQuery
    * @Description                    :  Method to combine all query parameters
    * @Return Type                    :  string
    * @Parameters                     :  sPrefix,sClauses
    */
    public String CombineQuery(String sPrefix, List < String > sClauses) {
        List < String > sCombineClause = new List < String > ();
        for (String sClause: sClauses) {
            if (sClause != null && sClause != '')
                sCombineClause.add(sClause);
        }
        if (sCombineClause.size() > 0)
            return ' ' + sPrefix + ' ' + string.join(sCombineClause, ' AND ');
        return '';
    }

    //Query constructor method
     /* 
    * @Method Name                    :  Query
    * @Description                    :  Query constructor method
    * @Return Type                    :  void
    * @Parameters                     :  None
    */
    Public void Query(string sFinalSort,string sObjectName) {


            String sDynamicQuery;
            String sDynamicQuery2;

            String sSearchWord = mURLparams.get('searchWord');
            if(sSearchWord.length()>49){
                isShrink=TRUE;
            }   
            String sReqStudyTherapeuticAreaClause = '';
            String sRelationshipTherapeuticAreaClause = '';
            String sLandscapeBUClause = '';
            String sRequestStudyBUClause = '';
            String sRelationshipBUClause = '';
            String sTimeFrameClause = '';
            String sSearchClause = '';
            String sStudyIDClause = '';
            String sRequestIDClause = '';


            /*Start of Related Object Search Section*/

            //Initial Sets. Used for related object search
            set<id> sStudyIDs = new set<id>();
            set<id> sRequestIDs = new set<id>();

            sSearchWord = sSearchWord.trim();
            if(sLocalSearch != NULL){
                sLocalSearch = sLocalSearch.trim();
            }

            String sWord;

            //Searching related objects and adding them to the initial Set
            if (sSearchWord != null && sSearchWord.trim() != '') {
                sWord = sSearchWord;
            }
            
            //Searching related objects and adding them to the initial Set
             if (sWord != null && sWord.trim() != '') {
               for(DRDP_Study_Molecule__c oMol : Database.Query('Select id,Project__c from DRDP_Study_Molecule__c where Molecule__r.name like \'%_'+string.escapeSingleQuotes(sWord)+'_%\' OR Molecule__r.name like \'%_'+string.escapeSingleQuotes(sWord)+'\' OR Molecule__r.name like \''+string.escapeSingleQuotes(sWord)+'_%\' OR Molecule__r.name like \'' +string.escapeSingleQuotes(sWord)+'\'')){
                    sStudyIDs.add(oMol.Project__c);
                }  
                for(Study_Country__c oCountry: Database.Query('Select id,Study__c from Study_Country__c where Country__r.name like \'%_'+string.escapeSingleQuotes(sWord)+'_%\' OR Country__r.name like \'%_'+string.escapeSingleQuotes(sWord)+'\' OR Country__r.name like \''+string.escapeSingleQuotes(sWord)+'_%\' OR Country__r.name like \'' +string.escapeSingleQuotes(sWord)+'\'')){
                    sStudyIDs.add(oCountry.Study__c);
                }
                for(Request__c oRequest: Database.Query('Select id,Related_Project__c from Request__c where  Name like \'%_'+string.escapeSingleQuotes(sWord)+'_%\' OR Name like \'%_'+string.escapeSingleQuotes(sWord)+'\' OR Name like \''+string.escapeSingleQuotes(sWord)+'_%\'OR Name like \'' +string.escapeSingleQuotes(sWord)+'\'')){
                    sStudyIDs.add(oRequest.Related_Project__c);
                }
                for(Related_Data_Asset__c oDataAsset: Database.Query('Select id,Project__c from Related_Data_Asset__c where Data_Asset__r.name like \'%_'+string.escapeSingleQuotes(sWord)+'_%\' OR Data_Asset__r.name like \'%_'+string.escapeSingleQuotes(sWord)+'\' OR Data_Asset__r.name like \''+string.escapeSingleQuotes(sWord)+'_%\' OR Data_Asset__r.name like \'' +string.escapeSingleQuotes(sWord)+'\'')){
                    sStudyIDs.add(oDataAsset.Project__c);
                }
                for(Related_Country__c oCountry: Database.Query('Select id,Project__c,Request__c from Related_Country__c where Country__r.name like \'%_'+string.escapeSingleQuotes(sWord)+'_%\' OR Country__r.name like \'%_'+string.escapeSingleQuotes(sWord)+'\' OR Country__r.name like \''+string.escapeSingleQuotes(sWord)+'_%\' OR Country__r.name like \'' +string.escapeSingleQuotes(sWord)+'\'')){
                    sStudyIDs.add(oCountry.Project__c);
                    sRequestIDs.add(oCountry.Request__c);
                }
                for(Request_Data_Asset__c oReq: Database.Query('Select id,Request__c from Request_Data_Asset__c where  Data_Asset__r.name like \'%_'+string.escapeSingleQuotes(sWord)+'_%\' OR Data_Asset__r.name like \'%_'+string.escapeSingleQuotes(sWord)+'\' OR Data_Asset__r.name like \''+string.escapeSingleQuotes(sWord)+'_%\' OR Data_Asset__r.name like \'' +string.escapeSingleQuotes(sWord)+'\'')){
                    sRequestIDs.add(oReq.Request__c);
                }
                for(DRDP_Request_Molecule__c oMol : Database.Query('Select id,Request__c from DRDP_Request_Molecule__c where  Molecule__r.name like \'%_'+string.escapeSingleQuotes(sWord)+'_%\' OR Molecule__r.name like \'%_'+string.escapeSingleQuotes(sWord)+'\' OR Molecule__r.name like \''+string.escapeSingleQuotes(sWord)+'_%\' OR Molecule__r.name like \'' +string.escapeSingleQuotes(sWord)+'\'')){
                    sRequestIds.add(oMol.Request__c);
                }
            }

            If(!sStudyIDs.IsEmpty()){
                sStudyIDClause = 'ID IN :sStudyIDs';
            }
            If(!sRequestIDs.IsEmpty()){
                sRequestIDClause = 'ID IN :sRequestIDs';
            }



            //SOSL query to return the filtered records (drill down from child results)
            if (sSearchWord != null && sSearchWord.trim() != '' && sLocalSearch != null && sLocalSearch.trim() != '' && (!sStudyIDs.IsEmpty() || !sRequestIDs.IsEmpty())) {

                sDynamicQuery2 = 'FIND \'' + string.escapeSingleQuotes(sLocalSearch) + '\' IN ALL FIELDS RETURNING ';
                
                If(!sStudyIDs.IsEmpty()){
                    sDynamicQuery2 += 'Project__c  (id' + CombineQuery('WHERE',new List <String>{sReqStudyTherapeuticAreaClause, sRequestStudyBUClause, sTimeFrameClause,sStudyIDClause}) + '),';
                }
                If(!sRequestIDs.IsEmpty()){
                    sDynamicQuery2 += 'Request__c (id ' + CombineQuery('WHERE',new List <String>{sReqStudyTherapeuticAreaClause, sLandscapeBUClause, sTimeFrameClause,sRequestIDClause}) + '),';
                }

                sDynamicQuery2 = sDynamicQuery2.removeEnd(',');

                List < List < sObject >> lDynamicSearchResult2 = search.query(sDynamicQuery2);

                list<Project__c> lStudies3 = new list<Project__c>();
                list<Request__c> lReqs3 = new list<Request__c>();

                If(!sStudyIDs.IsEmpty() && sRequestIDs.IsEmpty()){
                    lStudies3 = lDynamicSearchResult2[0];
                }
                If(sStudyIDs.IsEmpty() && !sRequestIDs.IsEmpty()){
                    lReqs3 =lDynamicSearchResult2[0];
                }
                If(!sStudyIDs.IsEmpty() && !sRequestIDs.IsEmpty()){
                    lStudies3 = lDynamicSearchResult2[0];
                    lReqs3 = lDynamicSearchResult2[1];
                }



                sStudyIDs.clear();
                For(Project__c oProject : lStudies3){
                    sStudyIDs.add(oProject.id);
                }

                sRequestIDs.clear();
                For(Request__c oRequest : lReqs3){
                    sRequestIDs.add(oRequest.id);
                }

            }
       


            //Getting Therapeutic Areas based on User Selection. This set will be used to filter the records obtained for related object search
            Set<String> sChildTherapeuticArea = new Set<String>();
            for (wStudyObject oWrapper: mStudyObjectStructure.get('TherapeuticArea')) {
            if (oWrapper.isSelected) {
                sChildTherapeuticArea.add(oWrapper.label);
                }
            }

            //Getting Region based on User Selection. This set will be used to filter the records obtained for related objects search
            Set<String> sChildRegion = new Set<String>();
            for (wStudyObject oWrapper: mStudyObjectStructure.get('BU')) {
            if (oWrapper.isSelected) {
                sChildRegion.add(oWrapper.label);
                }
            }

            //Getting Time Filter based on User Selection. This will be used to filter the records obtained for related objects search
            String sLastModifiedDate = NULL;
            String sPreviousYears = NULL;
            For(String s: mTimeFrameFilter.Keyset()){
                    If(mTimeFrameFilter.get('This Week')){
                        sLastModifiedDate = 'THIS_WEEK';
                    }
                    If(mTimeFrameFilter.get('This Month')){
                       sLastModifiedDate = 'THIS_MONTH';
                    }
                    If(mTimeFrameFilter.get('This Quarter')){
                       sLastModifiedDate = 'THIS_QUARTER';
                    }
                    If(mTimeFrameFilter.get('This Year')){
                      sLastModifiedDate = 'THIS_YEAR';
                    }
                    If(mTimeFrameFilter.get('Previous Years')){
                        sPreviousYears ='LAST_N_YEARS:100';
                    }
            }

            //Final Set of Ids for Child Search

            set<id> cStudyIDs = new set<id>();
            set<id> cRequestIDs = new set<id>();

            String sStudyQuery;
            String sRequestQuery;
  
            //If None of the Filters are Selected.
            If(sChildRegion.IsEmpty() && sChildTherapeuticArea.IsEmpty() && sLastModifiedDate == NULL &&  sPreviousYears == NULL){
                cStudyIDs.addall(sStudyIDs);
                cRequestIDs.addall(sRequestIDs);
            }

            //If all Filters are Selected.
            If(!sChildRegion.IsEmpty() && !sChildTherapeuticArea.IsEmpty() && (sLastModifiedDate != NULL || sPreviousYears!=NULL)){
                sStudyQuery = 'Select Id from Project__c where Business_Unit_Primary__c IN: sChildRegion AND Therapeutic_Area_Primary__c IN: sChildTherapeuticArea AND (LastModifiedDate ='+sLastModifiedDate+' OR LastModifiedDate='+sPreviousYears+') AND ID IN: sStudyIDs';
                sRequestQuery = 'Select Id from Request__c where Business_Unit_Primary__c IN: sChildRegion AND Therapeutic_Area_Primary__c IN: sChildTherapeuticArea AND (LastModifiedDate ='+sLastModifiedDate+' OR LastModifiedDate='+sPreviousYears+') AND ID IN :sRequestIDs ';
                For(Project__c oStudy: Database.Query(sStudyQuery)){
                    cStudyIDs.add(oStudy.id);
                }
                For(Request__c oRequest: Database.Query(sRequestQuery)){
                    cRequestIDs.add(oRequest.id);
                }
            }

            //If ONLY Thereapeutic Area is Selected.
            If(sChildRegion.IsEmpty() && !sChildTherapeuticArea.IsEmpty() && (sLastModifiedDate == NULL && sPreviousYears==NULL)){
                sStudyQuery = 'Select Id from Project__c where Therapeutic_Area_Primary__c IN: sChildTherapeuticArea AND ID IN :sStudyIDs';
                sRequestQuery = 'Select Id from Request__c where Therapeutic_Area_Primary__c IN: sChildTherapeuticArea AND ID IN :sRequestIDs';
                For(Project__c oStudy: Database.Query(sStudyQuery)){
                    cStudyIDs.add(oStudy.id);
                }
                For(Request__c oRequest: Database.Query(sRequestQuery)){
                    cRequestIDs.add(oRequest.id);
                }
            }

            //If ONLY Region is Selected.
            If(!sChildRegion.IsEmpty() && sChildTherapeuticArea.IsEmpty() && (sLastModifiedDate == NULL && sPreviousYears==NULL)){
                sStudyQuery = 'Select Id from Project__c where Business_Unit_Primary__c IN: sChildRegion AND ID IN :sStudyIDs';
                sRequestQuery = 'Select Id from Request__c where Business_Unit_Primary__c IN: sChildRegion AND ID IN :sRequestIDs';
                For(Project__c oStudy: Database.Query(sStudyQuery)){
                    cStudyIDs.add(oStudy.id);
                }
                For(Request__c oRequest: Database.Query(sRequestQuery)){
                    cRequestIDs.add(oRequest.id);
                }
            }

            //If ONLY Time Filter is Selected.
            If(sChildRegion.IsEmpty() && sChildTherapeuticArea.IsEmpty() && (sLastModifiedDate != NULL || sPreviousYears!=NULL)){
                sStudyQuery = 'Select Id from Project__c where (LastModifiedDate ='+sLastModifiedDate+' OR LastModifiedDate='+sPreviousYears+') AND ID IN :sStudyIDs';
                sRequestQuery = 'Select Id from Request__c where (LastModifiedDate ='+sLastModifiedDate+' OR LastModifiedDate='+sPreviousYears+') AND ID IN :sRequestIDs';
                For(Project__c oStudy: Database.Query(sStudyQuery)){
                    cStudyIDs.add(oStudy.id);
                }
                For(Request__c oRequest: Database.Query(sRequestQuery)){
                    cRequestIDs.add(oRequest.id);
                }
            }

            //If ONLY Thereapeutic Area and Region is Selected.
            If(!sChildRegion.IsEmpty() && !sChildTherapeuticArea.IsEmpty() && (sLastModifiedDate == NULL && sPreviousYears==NULL)){
                sStudyQuery = 'Select Id from Project__c where Business_Unit_Primary__c IN: sChildRegion AND Therapeutic_Area_Primary__c IN: sChildTherapeuticArea AND ID IN :sStudyIDs';
                sRequestQuery = 'Select Id from Request__c where Business_Unit_Primary__c IN: sChildRegion AND Therapeutic_Area_Primary__c IN: sChildTherapeuticArea AND ID IN :sRequestIDs';
                For(Project__c oStudy: Database.Query(sStudyQuery)){
                    cStudyIDs.add(oStudy.id);
                }
                For(Request__c oRequest: Database.Query(sRequestQuery)){
                    cRequestIDs.add(oRequest.id);
                }
            }

             //If ONLY Thereapeutic Area and Time Filter is Selected.
            If(sChildRegion.IsEmpty() && !sChildTherapeuticArea.IsEmpty() && (sLastModifiedDate != NULL || sPreviousYears!=NULL)){
                sStudyQuery = 'Select Id from Project__c where Therapeutic_Area_Primary__c IN: sChildTherapeuticArea AND (LastModifiedDate ='+sLastModifiedDate+' OR LastModifiedDate='+sPreviousYears+') AND ID IN :sStudyIDs';
                sRequestQuery = 'Select Id from Request__c where Therapeutic_Area_Primary__c IN: sChildTherapeuticArea AND (LastModifiedDate ='+sLastModifiedDate+' OR LastModifiedDate='+sPreviousYears+') AND ID IN :sRequestIDs';
                For(Project__c oStudy: Database.Query(sStudyQuery)){
                    cStudyIDs.add(oStudy.id);
                }
                For(Request__c oRequest: Database.Query(sRequestQuery)){
                    cRequestIDs.add(oRequest.id);
                }

            }

            // If ONLY Region and Time Filter is Selected.
            If(!sChildRegion.IsEmpty() && sChildTherapeuticArea.IsEmpty() && (sLastModifiedDate != NULL || sPreviousYears!=NULL)){
                sStudyQuery = 'Select Id from Project__c where Business_Unit_Primary__c IN: sChildRegion AND (LastModifiedDate ='+sLastModifiedDate+' OR LastModifiedDate='+sPreviousYears+') AND ID IN :sStudyIDs';
                sRequestQuery = 'Select Id from Request__c where Business_Unit_Primary__c IN: sChildRegion AND (LastModifiedDate ='+sLastModifiedDate+' OR LastModifiedDate='+sPreviousYears+') AND ID IN :sRequestIDs';
                For(Project__c oStudy: Database.Query(sStudyQuery)){
                    cStudyIDs.add(oStudy.id);
                }
                For(Request__c oRequest: Database.Query(sRequestQuery)){
                    cRequestIDs.add(oRequest.id);
                }

            }    

            /*End of Related Object Search Section*/
            
            sLandscapeBUClause = FrameClause(mStudyObjectStructure.get('BU'));
            if (sLandscapeBUClause != '') {
                sLandscapeBUClause = ' Business_Unit__c IN ' + sLandscapeBUClause ;
            }
            
            sRelationshipBUClause = FrameClause(mStudyObjectStructure.get('BU'));
            if (sRelationshipBUClause != '') {
                sRelationshipBUClause = ' Account.Sponsorship_Function__c IN ' + sRelationshipBUClause ;
            }
            
            sRequestStudyBUClause = FrameClause(mStudyObjectStructure.get('BU'));
            if (sRequestStudyBUClause != '') {
                sRequestStudyBUClause = ' Business_Unit_Primary__c IN ' + sRequestStudyBUClause ;
            }


            sReqStudyTherapeuticAreaClause = FrameClause(mStudyObjectStructure.get('TherapeuticArea'));
            if (sReqStudyTherapeuticAreaClause != '') {
                sReqStudyTherapeuticAreaClause = ' Therapeutic_Area_Primary__c IN ' + sReqStudyTherapeuticAreaClause;
            }
            
            sRelationshipTherapeuticAreaClause = FrameClause(mStudyObjectStructure.get('TherapeuticArea'));
            if (sRelationshipTherapeuticAreaClause != '') {
                sRelationshipTherapeuticAreaClause = ' Therapeutic_Area__c IN ' + sRelationshipTherapeuticAreaClause;
            }


            sTimeFrameClause = TimeClause(mTimeFrameFilter);
            if (sTimeFrameClause != '' && sTimeFrameClause != NULL) {
                sTimeFrameClause = ' LastModifiedDate IN ' + sTimeFrameClause;
            }


            //SOSL query to return the filtered records
            if (sSearchWord != null && sSearchWord.trim() != '') {
                if (sLocalSearch != null && sLocalSearch.trim() != '') {
                    sDynamicQuery = 'FIND \'' + string.escapeSingleQuotes(sSearchWord) + ' AND ' + string.escapeSingleQuotes(+sLocalSearch) + '\' IN ALL FIELDS RETURNING ';

                } else {
                    sDynamicQuery = 'FIND \'' + string.escapeSingleQuotes(sSearchWord) + '\' IN ALL FIELDS RETURNING ';
                }
                
                
                sDynamicQuery += 'Project__c  (id ' + CombineQuery('WHERE',new List <String>{sReqStudyTherapeuticAreaClause, sRequestStudyBUClause, sTimeFrameClause}) + '),';
                sDynamicQuery += 'Request__c (id ' + CombineQuery('WHERE',new List <String>{sReqStudyTherapeuticAreaClause, sRequestStudyBUClause, sTimeFrameClause}) + '),';
                sDynamicQuery += 'Information_Landscape__c (id '+ CombineQuery(' WHERE',new List<String>{sReqStudyTherapeuticAreaClause,sLandscapeBUClause,sTimeFrameClause}) + '),';
                sDynamicQuery += 'Contact (id '+ CombineQuery(' WHERE',new List<String>{sRelationshipTherapeuticAreaClause,sRelationshipBUClause,sTimeFrameClause}) + '),';
            }

            sDynamicQuery = sDynamicQuery.removeEnd(',');

            List < List < sObject >> lDynamicSearchResult = search.query(sDynamicQuery);

            list<Project__c> lStudies2 = new list<Project__c>();
            list<Request__c> lReqs2 = new list<Request__c>();
            list<Data_Asset__c> lDA2 = new list<Data_Asset__c>();
            list<Information_Landscape__c> lLandscape2 = new list<Information_Landscape__c>();
            list<Contact> lRelationships2 = new list<Contact>();

            
            lStudies2 = lDynamicSearchResult[0];
            lReqs2 =lDynamicSearchResult[1];
            If(lDynamicSearchResult.size() > 2){
                lLandscape2 = lDynamicSearchResult[2];
            }
            If(lDynamicSearchResult.size() > 3){
                lRelationships2 = lDynamicSearchResult[3];
            }
                       
                        
            //Final Queries of the records
            list<Project__c> lStudies = new list<Project__c>();
            list<Request__c> lReqs = new list<Request__c>();
            list<Request__c> lPartners = new list<Request__c>();
            list<Information_Landscape__c> lLandscape = new list<Information_Landscape__c>();
            list<Contact> lRelationship = new list<Contact>();
            
            
            if(sObjectName=='Studies'){
                lStudies = Database.query('Select id,Name,Study_Project_ID__c,Research_Type__c,Owner.Name,Project_Status__c,Study_Description__c,Execution_Function__c From Project__c  where id in:lStudies2 OR id in:cStudyIDs Order By '+ sFinalSort);
            }else{
                lStudies = Database.query('Select id,Name,Study_Project_ID__c,Research_Type__c,Owner.Name,Project_Status__c,Study_Description__c,Execution_Function__c From Project__c  where id in:lStudies2 OR id in:cStudyIDs Order By Name ASC NULLS FIRST ');    
            }
            if(sObjectName=='Requests'){
                lReqs = Database.query('Select id,Name,Type_of_Partner__c,Priority__c,Request_Duration__c,Requestor_Functional_Area__c ,Partnership_Status__c,Requestor__r.name,recordtype.name,Request_Status__c, Outcome_TF__c,region__c, Partnership_Sponsor__c,recordtype.developername From Request__c  where id in: lReqs2 OR id in:cRequestIDs Order By '+ sFinalSort);
            }else{
                lReqs = Database.query('Select id,Name,Type_of_Partner__c,Priority__c,Request_Duration__c,Requestor_Functional_Area__c ,Partnership_Status__c,Requestor__r.name,recordtype.name,Request_Status__c, Outcome_TF__c, region__c, Partnership_Sponsor__c,recordtype.developername From Request__c  where id in: lReqs2 OR id in:cRequestIDs Order By Name ASC NULLS FIRST ');
            }
            if(sObjectName=='Landscapes'){
                lLandscape = Database.query('Select id,Name,Source_Description__c,Group_Name__c,Target_Decommissioning_Indicator__c,Integration_Mechanism__c From Information_Landscape__c where id in: lLandscape2 Order By '+ sFinalSort);
            }else{
                lLandscape = Database.query('Select id,Name,Source_Description__c,Group_Name__c,Target_Decommissioning_Indicator__c,Integration_Mechanism__c From Information_Landscape__c where id in: lLandscape2 Order By Name ASC NULLS FIRST ');
            }
            if(sObjectName=='Relationships'){
                lRelationship = Database.query('Select id,Account.RecordType.Name,Name,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Account.Name,Language_s__c From Contact where id in: lRelationships2 Order By '+ sFinalSort);
            }else{
                lRelationship = Database.query('Select id,Account.RecordType.Name,Name,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Account.Name,Language_s__c From Contact where id in: lRelationships2 Order By Name ASC NULLS FIRST ');
            }
            if (lReqs.size() > 0) {
                for (Request__c oReq: lReqs) {
                    if (oReq.recordtype.developername == 'Partnership_Exploration') {
                        lPartners.add(oReq);
                    }
                }
            }
            
            lProjects = new List < Project__c > ();
            lPartnerShips = new List < Request__c > ();
            lRequests = new List < Request__c > ();
            lLandscapes = new List < Information_Landscape__c >();
            lRelationships = new List < Contact >(); 
                //If no object is selected then below logic will select all objects
                If((isStudies == false && isPartnerships == false && isRequests == false && isLandscapes == false && isRelationships == false) || (isLandscapes && isStudies && isPartnerships && isRequests && isRelationships)) {

                    lProjects.addall(lStudies);
                    lRequests.addall(lReqs);
                    lPartnerShips.addall(lPartners);
                    lLandscapes.addall(lLandscape);
                    lRelationships.addall(lRelationship);
                    
                } else {
                    If(isStudies) {
                        lProjects.addall(lStudies);
                    }
                    If(isPartnerships) {
                        lPartnerShips.addall(lPartners);
                    }
                    If(isRequests) {
                        lRequests.addall(lReqs);
                    }
                    If(isLandscapes){
                        lLandscapes.addall(lLandscape);
                    }
                    If(isRelationships){
                        lRelationships.addall(lRelationship);
                    }
                }

                cStudiesListController = new ApexPages.StandardSetController(lProjects);
                cStudiesListController.setPageSize(20);
                cPartnershipListController= new ApexPages.StandardSetController(lPartnerships);
                cPartnershipListController.setPageSize(20);
                cRequestListController= new ApexPages.StandardSetController(lRequests);
                cRequestListController.setPageSize(20);
                cLandscapeListController = new ApexPages.StandardSetController(lLandscapes);
                cLandscapeListController.setPageSize(20);
                cRelationshipController = new ApexPages.StandardSetController(lRelationships);
                cRelationshipController.setPageSize(20);
                
                                
                lStudyPageNumbers = new List < Integer > ();
                lPartnershipPageNumbers = new List < Integer > ();
                lRequestPageNumbers= new List < Integer > ();
                lLandscapePageNumbers = new List < Integer >();
                lRelationshipPageNumbers = new List < Integer >();
                
                dPartnershipPageCount= pagecount(cPartnershipListController);
                dRequestPageCount= pagecount(cRequestListController);
                dLandscapePageCount = pagecount(cLandscapeListController);
                dRelationshipPageCount = pagecount(cRelationshipController);
                                
                lStudyPageNumbers = pagenumbers(dStudyPageCount);
                lPartnershipPageNumbers = pagenumbers(dPartnershipPageCount);
                lRequestPageNumbers=pagenumbers(dRequestPageCount);
                lLandscapePageNumbers = pagenumbers(dLandscapePageCount);
                lRelationshipPageNumbers = pagenumbers(dRelationshipPageCount);
                                
        }
        
        public list<integer> pagenumbers(decimal pagecount){
        list<integer> lPageNumbers = new list<integer>();
            for (Integer i = 1; i <= pagecount; i++) {
                    lPageNumbers.add(i);
                    if (lPageNumbers.size() == pNoLimit)
                        break;
                }
                return lPagenumbers;
        }
        
        public decimal pagecount(ApexPages.StandardSetController stdcntrlr){
            decimal dStudyPageCount= 0;
            dStudyPageCount= (decimal.valueof(stdcntrlr.getResultSize()) / decimal.valueof(stdcntrlr.getPageSize()));
            dStudyPageCount= dStudyPageCount.round(System.RoundingMode.UP);
            return dStudyPageCount;
        }
    /*
     * Method name  : GoToPageNumber
     * Description  : This method takes the user to results of that particular page on upon clicking any number on pagination panel on UI
     * Return Type  : void
     * @Parameters  : None
     */
    Public void GoToStudyPageNumber() 
    {   
        cStudiesListController.setPagenumber(iPageNumber);
    }
    Public void GoToLandscapePageNumber() 
    {   
        cLandscapeListController.setPagenumber(iPageNumber);
    }
    Public void GoToPartnershipPageNumber() 
    {   
        cPartnershipListController.setPagenumber(iPageNumber);
    }
    Public void GoToRequestPageNumber() {
        cRequestListController.setPagenumber(iPageNumber);
    }  
    Public void GoToRelationshipPageNumber() {
        cRelationshipController.setPagenumber(iPageNumber);
    }       

    Public list<integer> NextPageSeries(list<integer> lPageNumbers,Decimal dPageCount) {
        Integer currentLimit = lPageNumbers[lPageNumbers.size() - 1];
        lPageNumbers = new List < Integer > ();
        for (Integer i = 1; i <= pNoLimit; i++) 
        {
            if (currentLimit + i <= dPageCount) 
            {
                lPageNumbers.add(currentLimit + i);
            }
        }
        return lPageNumbers;
    }

    Public list<integer> PreviousPageSeries(list<integer> lPageNumbers) {
        Integer currentLimit = lPageNumbers[0] - pNoLimit - 1;

        lPageNumbers = new List < Integer > ();
        for (Integer i = 1; i <= pNoLimit; i++) 
        {
            lPageNumbers.add(currentLimit + i);
        }
        return lPageNumbers;
    }
    
    Public void NextStudyPageSeries(){
       lStudyPageNumbers= NextPageSeries(lStudyPageNumbers,dStudyPageCount);
    }
    Public void PreviousStudyPageSeries(){
       lStudyPageNumbers= PreviousPageSeries(lStudyPageNumbers);
    }
    Public void NextPartnershipPageSeries(){
       lPartnershipPageNumbers= NextPageSeries(lPartnershipPageNumbers,dPartnershipPageCount);
    }
    Public void PreviousPartnershipPageSeries(){
       lPartnershipPageNumbers= PreviousPageSeries(lPartnershipPageNumbers);
    }
    Public void NextRequestPageSeries(){
       lRequestPageNumbers= NextPageSeries(lRequestPageNumbers,dRequestPageCount);
    }
    Public void PreviousRequestPageSeries(){
       lRequestPageNumbers= PreviousPageSeries(lRequestPageNumbers);
    }
    Public void NextLandscapePageSeries(){
       lLandscapePageNumbers = NextPageSeries(lLandscapePageNumbers,dLandscapePageCount);
    }
    Public void PreviousLandscapePageSeries(){
       lLandscapePageNumbers= PreviousPageSeries(lLandscapePageNumbers);
    }
    Public void NextRelationshipPageSeries(){
       lRelationshipPageNumbers = NextPageSeries(lRelationshipPageNumbers,dRelationshipPageCount);
    }
    Public void PreviousRelationshipPageSeries(){
       lRelationshipPageNumbers= PreviousPageSeries(lRelationshipPageNumbers);
    }
    
    public void sortStudies(){
        sort();
        query(sFinalSort ,'Studies');
    }
    public void sortRequests(){
        sort();
        query(sFinalSort ,'Requests');
    }
    public void sortLandscapes(){
        sort();
        query(sFinalSort, 'Landscapes');
    }
    public void sortRelationships(){
        sort();
        query(sFinalSort,'Relationships');
    }
    
    
    /*
     * Method name  : sort
     * Description  : Sorting of the results displayed by clicking on the column link
     * Return Type  : void
     * @Parameters  : None
     */

    Public void sort() 
    {
        if (sField == previousSField) 
        {
            if (sOrder.contains('ASC')) 
            {
                sOrder = sOrder.replace('ASC', 'DESC');
                sOrder = sOrder.replace('FIRST', 'LAST');
            } 
            else 
            {
                sorder = sorder.replace('DESC', 'ASC');
                sOrder = sOrder.replace('LAST', 'FIRST');
            }
        } 
        else 
        {
            sOrder = 'ASC NULLS FIRST';
            previoussField = sField;
        }
        
        sFinalSort = string.escapeSingleQuotes(sField)+' '+string.escapeSingleQuotes(sOrder);
    }
    
    /*
         * Class name   : wStudyObject
         * Description  : This is a wrapper class which holds the picklist value name and checkbox to filter out results on Global Search Page
         */

        Public class wStudyObject {
            Public Boolean isSelected {get;set;}
            Public string label {get;set;}

            public wStudyObject(String l, Boolean isC) {
                isSelected = isC;
                label = l;
            }
        }
        
        public void FetchDataForCriteria(){
        String sQuery = string.escapeSingleQuotes(sField)+' '+string.escapeSingleQuotes(sOrder);
        Query(sQuery,null);
    }
}