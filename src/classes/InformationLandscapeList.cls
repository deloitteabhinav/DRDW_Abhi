/****************************************************************************************************************************************** 
 * Class Name   : InformationLandscapeList 
 * Description  : Class to display the List of Landscape records
 * Created By   : Deloitte Consulting 
 * 
 *****************************************************************************************************************************************/
Public with sharing class InformationLandscapeList {

    Public ApexPages.StandardSetController cLandscapeListController {
        get;
        set;
    }
    Public string sField {
        get;
        set;
    }
    Public string sSearchWord {
        get;
        set;
    }
    Public string sOrder {
        get;
        set;
    }
    Public Map < String, Integer > mCategoyCount {
        get;
        set;
    }
    Public List < SelectOption > oLandscapeOptions {
        get;
        set;
    }
    Public string sAccessDetailType {
        get;
        set;
    }
    Public List < Integer > lPageNumbers {
        get;
        private set;
    }
    Public Integer iPageNumber {
        get;
        set;
    }
    Public Map < String, List < wLandscapeObject >> mInfoLandscapeStructure {
        get;
        set;
    }
    public Integer pNoLimit {
        get;
        set;
    }
    public Decimal dPageCount {
        get;
        set;
    }
    public string previousSField {
        get;
        set;
    }
    
     public boolean bShowMoreFlag 
    {
        get;
        set;
    }
    
    public List < wFieldSelected > lFieldWrapper;

    public set < id > sSelectedLandscapeId {get; set;}
    public Set < String > sSelectedFields {get; set;}
    public List < String > lSelectedFields {get; set;}

    Public Map < String, String > mFieldList;

    Public List < Information_Landscape__c > LandscapeSelectedList {get; set;}
    Public List < String > lSections {get; set;}
    Public Map < String, String > mLabel {get; set;}
    Public List < wFieldSelected > FieldList {get; set;}
    @TestVisible List < wLandscapeRecordWrap > lLandscapeRecordWrap {get; set;}
    
    Public List<wOrganisation> lwOrganisation{get;set;}
    Public Boolean bShowButton{get;set;}
     

    /* 
     * @Method Name                    :  getLandscapes
     * @Description                    :  Initialize cLandscapeListController and return a list of records
     * @Return Type                    :  list of data Landscape records
     * @Parameters                     :  None
     */
    Public List < Information_Landscape__c > getLandscapes() {
        return (List < Information_Landscape__c > ) cLandscapeListController.getRecords();
    }
    


    //Loading the constructor the page
    Public InformationLandscapeList() {
        pNoLimit = 20;
        // Initialisation 
        sField = 'Name';
        previousSField = 'Name';
        sOrder = 'ASC NULLS FIRST';
        bShowMoreFlag = TRUE;
        mInfoLandscapeStructure = new Map < String, List < wLandscapeObject >> ();
        lwOrganisation = new List<wOrganisation>();
        
        //Initialisation for compare report collections
        sSelectedFields = new Set < String > ();
        lSelectedFields = new List < String > ();
        mFieldList = new Map < String, String > ();
        sSelectedLandscapeId = new Set < Id > ();
        LandscapeSelectedList = new List < Information_Landscape__c > ();
        lSections = new List < String > ();
        lLandscapeRecordWrap = new List < wLandscapeRecordWrap > ();



        // Methods for call
        DescribeObjectWithDetails();
        Query(string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder));  
        FieldListMaker();
        FieldList = getFieldList();  
        FetchOrgs();

    }
    
    
    /*
     * @Method Name                    :  getlLandscapeRecordWrap
     * @Description                    :  making a wrapper with selection choices
     * @Return Type                    :  list of record wrapper
     * @Parameters                     :  None
     */
    Public List<wLandscapeRecordWrap> getlLandscapeRecordWrap() {
        lLandscapeRecordWrap = new List<wLandscapeRecordWrap>();
        for (Information_Landscape__c oLandscape : (List<Information_Landscape__c >)cLandscapeListController.getRecords())
            lLandscapeRecordWrap.add(new wLandscapeRecordWrap(oLandscape));

        return lLandscapeRecordWrap;
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

    /* 
     * @Method Name                    :  DescribeObjectWithDetails
     * @Description                    :  This method populates the filtering fields on the UI page 
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    Public Void DescribeObjectWithDetails() {
        List < wLandscapeObject > lPicklist = new List < wLandscapeObject > ();
        mCategoyCount = new Map < String, Integer > ();

        // Not using global describe which is taking longer time, hence hardcoding the field for describe
        for (Schema.Picklistentry oPicklistValues: Information_Landscape__c.Source_Type__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wLandscapeObject(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mInfoLandscapeStructure.put('Source_Type__c', lPicklist);

        lPicklist = new List < wLandscapeObject > ();
        for (Schema.Picklistentry oPicklistValues: Information_Landscape__c.Information_Type__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wLandscapeObject(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mInfoLandscapeStructure.put('Information_Type__c', lPicklist);

        lPicklist = new List < wLandscapeObject > ();
        for (Schema.Picklistentry oPicklistValues: Information_Landscape__c.Regulatory_Indicator__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wLandscapeObject(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mInfoLandscapeStructure.put('Regulatory_Indicator__c', lPicklist);

        lPicklist = new List < wLandscapeObject > ();
        for (Schema.Picklistentry oPicklistValues: Information_Landscape__c.Sensitivity__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wLandscapeObject(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mInfoLandscapeStructure.put('Sensitivity__c', lPicklist);

    }

    /* 
     * @Method Name                    :  FrameClause
     * @Description                    :  This method constructs the query clause if check boxes are checked on UI 
     * @Return Type                    :  string
     * @Parameters                     :  List of wLandscapeObject  
     */
    Public string FrameClause(List < wLandscapeObject > lWrapperForProcessing) {
        String sClause = '';

        for (wLandscapeObject oWrapper: lWrapperForProcessing) {
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
     * @Method Name                    :  CombineQuery
     * @Description                    :  This method combines all query clauses generated in FrameClause() method 
     * @Return Type                    :  string
     * @Parameters                     :  string and list of strings
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

    /* 
     * @Method Name                    :  Query
     * @Description                    :  This method queries the data base and displays the results on UI 
     * @Return Type                    :  void
     * @Parameters                     :  String sOrder
     */
    Public void Query(String sOrder) {
        String sRegionClause = '';
        String sAccessMethodClause = '';
        String sTherapeuticAreaClause = '';
        String sTypeofDatabaseClause = '';
        String sAccessDetailClause = '';
        String sSearchClause = '';
        List < Information_Landscape__c > lSearchWordProjects = new List < Information_Landscape__c > ();

        sRegionClause = FrameClause(mInfoLandscapeStructure.get('Source_Type__c'));
        if (sRegionClause != '') {
            sRegionClause = ' Source_Type__c IN ' + sRegionClause;
        }

        sAccessMethodClause = FrameClause(mInfoLandscapeStructure.get('Information_Type__c'));
        if (sAccessMethodClause != '') {
            sAccessMethodClause = ' Information_Type__c IN ' + sAccessMethodClause;
        }

        sTherapeuticAreaClause = FrameClause(mInfoLandscapeStructure.get('Regulatory_Indicator__c'));
        if (sTherapeuticAreaClause != '') {
            sTherapeuticAreaClause = ' Regulatory_Indicator__c IN ' + sTherapeuticAreaClause;
        }

        sTypeofDatabaseClause = FrameClause(mInfoLandscapeStructure.get('Sensitivity__c'));
        if (sTypeofDatabaseClause != '') {
            sTypeofDatabaseClause = ' Sensitivity__c IN ' + sTypeofDatabaseClause;
        }
        
        If(sAccessDetailType != null && sAccessDetailType != '') {
            sAccessDetailClause = ' SDLC_Classification__c  IN (\'' + string.escapeSingleQuotes(sAccessDetailType) + '\')';
        } 

        if ((sSearchWord != null && sSearchWord.length()>1) && sSearchWord.trim() != '') {
            sSearchClause = ' Id IN : lSearchWordProjects';
        }

        if ((sSearchWord != null && sSearchWord.length()>1) && sSearchWord.trim() != '') {

            List < List < sObject >> lDynamicSearchResult = search.query('FIND \'' + string.escapeSingleQuotes(sSearchWord) + '\' IN ALL FIELDS RETURNING Information_Landscape__c (Id,Name,Source_Type__c,Information_Type__c,Regulatory_Indicator__c, Sensitivity__c, SDLC_Classification__c, Source_Description__c, Group_Name__c, Target_Decommissioning_Indicator__c, Integration_Mechanism__c ' + CombineQuery('WHERE', new List < String > {
                sRegionClause, sAccessMethodClause, sTherapeuticAreaClause, sTypeofDatabaseClause, sAccessDetailClause
            }) +  ' ORDER BY ' + sOrder + ')');
            lSearchWordProjects = lDynamicSearchResult[0];
            cLandscapeListController = new ApexPages.StandardSetController(lDynamicSearchResult[0]);
        } else {
            cLandscapeListController = new ApexPages.StandardSetController(Database.getQueryLocator(
                'SELECT Source_Type__c,SDLC_Classification__c,Information_Type__c,Regulatory_Indicator__c, Sensitivity__c, Name, Source_Description__c, Group_Name__c, Target_Decommissioning_Indicator__c, Integration_Mechanism__c  FROM Information_Landscape__c ' + CombineQuery('WHERE', new List < String > {
                    sRegionClause, sAccessMethodClause, sTherapeuticAreaClause, sTypeofDatabaseClause, sAccessDetailClause
                }) + ' ORDER BY ' + sOrder));
        }


        cLandscapeListController.setPageSize(50);
        lPageNumbers = new List < Integer > ();
        dPageCount = 0;
        dPageCount = (decimal.valueof(cLandscapeListController.getResultSize()) / decimal.valueof(cLandscapeListController.getPageSize()));
        dPageCount = dPageCount.round(System.RoundingMode.UP);

        for (Integer i = 1; i <= dPageCount; i++) {
            lPageNumbers.add(i);
            if (lPageNumbers.size() == pNoLimit)
                break;
        }

        for (String mCount: mCategoyCount.keyset()) {
            mCategoyCount.put(mCount, 0);
        }
        for (AggregateResult ar: database.query('SELECT count(Id),Source_Type__c FROM Information_Landscape__c where Source_Type__c!=null ' + CombineQuery('AND', new List < String > {
                sRegionClause, sAccessMethodClause, sTherapeuticAreaClause, sTypeofDatabaseClause,sAccessDetailClause,sSearchClause
            }) + ' Group BY Source_Type__c')) {
            mCategoyCount.put((String) ar.get('Source_Type__c'), (Integer) ar.get('expr0'));
        }
        for (AggregateResult ar: database.query('SELECT count(Id),Information_Type__c FROM Information_Landscape__c where Information_Type__c !=null ' + CombineQuery('AND', new List < String > {
                sRegionClause, sAccessMethodClause, sTherapeuticAreaClause, sTypeofDatabaseClause,sAccessDetailClause,sSearchClause
            }) + ' Group BY Information_Type__c')) {
            mCategoyCount.put((String) ar.get('Information_Type__c'), (Integer) ar.get('expr0'));
        }

        for (AggregateResult ar: database.query('SELECT count(Id),Regulatory_Indicator__c FROM Information_Landscape__c where Regulatory_Indicator__c!=null ' + CombineQuery('AND', new List < String > {
                sRegionClause, sAccessMethodClause, sTherapeuticAreaClause, sTypeofDatabaseClause,sAccessDetailClause,sSearchClause
            }) + ' Group BY Regulatory_Indicator__c')) {
            mCategoyCount.put((String) ar.get('Regulatory_Indicator__c'), (Integer) ar.get('expr0'));
        }

        for (AggregateResult ar: database.query('SELECT count(Id),Sensitivity__c FROM Information_Landscape__c where Sensitivity__c!=null ' + CombineQuery('AND', new List < String > {
                sRegionClause, sAccessMethodClause, sTherapeuticAreaClause, sTypeofDatabaseClause,sAccessDetailClause,sSearchClause
            }) + ' Group BY Sensitivity__c')) {
            mCategoyCount.put((String) ar.get('Sensitivity__c'), (Integer) ar.get('expr0'));
        }

        //Initialise dropdown of OwnerType
        oLandscapeOptions = new List < SelectOption > ();
        oLandscapeOptions.add(new SelectOption('', 'All SDLC Type'));
        for (AggregateResult ar: database.query('SELECT count(Id),SDLC_Classification__c FROM Information_Landscape__c where SDLC_Classification__c !=null AND SDLC_Classification__c !=null' + CombineQuery('AND', new List < String > {
                sRegionClause, sAccessMethodClause, sTherapeuticAreaClause, sTypeofDatabaseClause,sAccessDetailClause,sSearchClause
            }) + ' Group BY SDLC_Classification__c')) {
            oLandscapeOptions.add(new SelectOption((String) ar.get('SDLC_Classification__c'), (String) ar.get('SDLC_Classification__c')));
        }
    }

    /*
     * Method name  : sort
     * Description  : Sorting of the results displayed by clicking on the column link
     * Return Type  : void
     * @Parameters  : None
     */

    Public void sort() {

        if (sField == previousSField) {
            if (sOrder.contains('ASC')) {
                sOrder = sOrder.replace('ASC', 'DESC');
                sOrder = sOrder.replace('FIRST', 'LAST');
            } else {
                sorder = sorder.replace('DESC', 'ASC');
                sOrder = sOrder.replace('LAST', 'FIRST');
            }
        } else {
            sOrder = 'ASC NULLS FIRST';
            previoussField = sField;
        }

        Query(string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder));
    }

    /* 
     * @Method Name                    :  FetchDataForCriteria
     * @Description                    :  This method is called upon anny action on UI to query the data base
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    public void FetchDataForCriteria() {
        Query(string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder));
    }

    /*
     * Method name  : GoToPageNumber
     * Description  : This method takes the user to results of that particular page on upon clicking any number on pagination panel on UI
     * Return Type  : void
     * @Parameters  : None
     */
    Public void GoToPageNumber() {
        cLandscapeListController.setPagenumber(iPageNumber);
    }

    /* 
     * @Method Name                    :  NextPageSeries
     * @Description                    :  This method takes the user to next set of pages on pagination panel on UI
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    Public void NextPageSeries() {

        Integer currentLimit = lPageNumbers[lPageNumbers.size() - 1];
        lPageNumbers = new List < Integer > ();
        for (Integer i = 1; i <= pNoLimit; i++) {
            if (currentLimit + i <= dPageCount) {
                lPageNumbers.add(currentLimit + i);
            }
        }
    }
    
    /* 
     * @Method Name                    :  PreviousPageSeries
     * @Description                    :  This method takes the user to previous set of pages on pagination panel on UI
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    Public void PreviousPageSeries() {

        Integer currentLimit = lPageNumbers[0] - pNoLimit - 1;

        lPageNumbers = new List < Integer > ();
        for (Integer i = 1; i <= pNoLimit; i++) {
            lPageNumbers.add(currentLimit + i);
        }
    }
    
       /*
     * @Method Name                    :  FieldListMaker
     * @Description                    :  This method queries the console objects and sets a map for a list of fields
     * @Return Type                    :  List
     * @Parameters                     :  None
     */

    Public void FieldListMaker() {

        //Map for Getting all the Fields from Data Landscape Object
        Map < String, Schema.SObjectField > M = new Map < String, Schema.SObjectField > ();
        M = Schema.SObjectType.Information_Landscape__c.fields.getMap();

        //Querying the Console object to get the data
        //Adding Fields Names and Label to the Map which are used for Reporting

        List < Console__c > lConsole = [Select Name, Id from Console__c where Name = 'Information Landscape'
                                             LIMIT 1
                                            ];
        For(Note oNote: [Select Title, Body from Note where ParentId IN: lConsole Order By CreatedDate]) {
            lSections.add(oNote.Title);
            For(String sField: oNote.Body.split(',')) {
                sField = sField.trim();
                For(String key: M.KeySet()) {
                    If(sField == M.get(key).getDescribe().getLabel()) {
                        mFieldList.put(key, oNote.Title);
                    }
                }
            }
        }

    }

    /*
     * @Method Name                    :  getFieldList
     * @Description                    :  This method constructs a wrapper for field list
     * @Return Type                    :  List
     * @Parameters                     :  None
     */


    Public List < wFieldSelected > getFieldList() {

        //Adding the Selected Fields to the Wrapper
        lFieldWrapper = new List < wFieldSelected > ();
        For(String sWrap: mFieldList.keySet()) {
            wFieldSelected wField = new wFieldSelected(Schema.SObjectType.Information_Landscape__c.fields.getMap().get(sWrap).getDescribe().getLabel(), sWrap, false, mFieldList.get(sWrap));
            if (this.sSelectedFields.contains(sWrap)) {
                wField.fselected = True;
            } else {
                wField.fselected = False;
            }
            lFieldWrapper.add(wField);
        }

        return lFieldWrapper;
    }

    /*
     * @Method Name                    :  Generate
     * @Description                    :  This method is called upon when a user gives an Generate report request from the UI
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */


    Public PageReference Generate() {
        For(wLandscapeRecordWrap oWrap: lLandscapeRecordWrap) {
            If(oWrap.isSelected) {
                sSelectedLandscapeId.add(oWrap.oLandscape.id);
            }
        }
        mLabel = new Map < String, String > ();

        For(wFieldSelected oWrapper: lFieldWrapper) {
            If(oWrapper.fselected) {
                Schema.DisplayType fType = Schema.SObjectType.Information_Landscape__c.fields.getMap().get(oWrapper.API).getDescribe().getType();
                if (String.valueof(fType) == 'REFERENCE') {
                    String s = oWrapper.API;
                    s = s.replace('__c', '__r.Name');
                    sSelectedFields.add(s);
                    mLabel.put(s, oWrapper.Label);
                } else {
                    sSelectedFields.add(oWrapper.API);
                    mLabel.put(oWrapper.API, oWrapper.Label);
                }

            }
        }
        lSelectedFields.addall(sSelectedFields);
        ShowTable();
        PageReference PageRef = new PageReference('/apex/DRDP_LandscapeCompare');
        PageRef.setRedirect(false);
        return PageRef;

    }

    /*
     * @Method Name                    :  ExportToExcel
     * @Description                    :  This method is called upon when a user gives an Export to excel request from the UI
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */

    Public PageReference ExportToExcel() {
        Generate();
        PageReference PageRef = new PageReference('/apex/DRDP_LandscapeReport');
        PageRef.setRedirect(false);
        return PageRef;
    }

    /*
     * @Method Name                    :  ShowTable
     * @Description                    :  This method is called upon when a user generates or exports a report
     * @Return Type                    :  void
     * @Parameters                     :  None
     */

    Public void ShowTable() {

        //Creating dynamic query with selected field
        String myQuery = 'Select Id,Name';

        for (String field : sSelectedFields) {
            If(field != 'Name') {
                myQuery += ',' + field + ' ';
            }
        }

        myQuery += ' from Information_Landscape__c Where Id IN:sSelectedLandscapeId LIMIT 50';

        //Executing the query and fetching results
        LandscapeSelectedList = Database.query(myQuery);
    }
    
    Public void FetchOrgs(){
        For(Account a: [Select Id,Name from Account ORDER BY NAME Limit 50000]){
            wOrganisation oW = new wOrganisation(False,a);
            lwOrganisation.add(oW);
        }
    }
    
    Public void ShowButton(){
        bShowButton = TRUE;
        List<String> lId = new List<String>();
        For(wOrganisation oW : lwOrganisation){
            If(oW.bSelected){
                lId.add(String.valueOf(oW.oAccount.Id).substring(0, 15));
            }
        }   
        If(lId.size() > 1){
            bShowButton = TRUE;
        } 
        Else{
            bShowButton = FALSE;
        }
    }
    
    Public PageReference GenerateOrgReport(){
        List<String> lId = new List<String>();
        String pv0 = '';
        String pv1 = '';
        String pv2 = '';
        String pv3 = '';
        For(wOrganisation oW : lwOrganisation){
            If(oW.bSelected){
                lId.add(String.valueOf(oW.oAccount.Id).substring(0, 15));
            }
        }
        If(lId.size() > 0){
            pv0 = lId[0];
        }
        If(lId.size() > 1){
            pv1 = lId[1];
        }
        If(lId.size() > 2){
            pv2 = lId[2];
        }
        If(lId.size() > 3){
            pv3 = lId[3];
        }
        Report report = [Select id From Report WHERE DeveloperName = 'Information_Sources_Across_Organizations' LIMIT 1];
        PageReference PageRef = new PageReference('/'+report.Id+'?pv0='+pv0+'&pv1='+pv1+'&pv2='+pv2+'&pv3='+pv3);
        return PageRef;  
    }

    /* **********************************************************************
     * Class name   : wLandscapeRecordWrap
     * Description  : This is a wrapper class to hold Checkbox against the Data Landscape Records to compare
      ********************************************************************** */

    Public class wLandscapeRecordWrap {
        Public Boolean isSelected {get; set;}
        Public Information_Landscape__c oLandscape {get; set;}
        Public wLandscapeRecordWrap (Information_Landscape__c DA) {
            oLandscape = DA;
        }
    }
    
    /*
     * Class name   : wLandscapeObject
     * Description  : This is a wrapper class which holds the picklist value name and checkbox to filter out results on Data Landscape list Page
     */

    Public class wLandscapeObject {
        Public Boolean isSelected {
            get;
            set;
        }
        Public string label {
            get;
            set;
        }
        public wLandscapeObject(String l, Boolean isC) {
            label = l;
            isSelected = isC;
        }
    }
    
    
    /* **********************************************************************
     * Class name   : wFieldSelected
     * Description  : This is a wrapper class which holds the field values and checkbox to generate dynamic report
     ********************************************************************** */

    Public class wFieldSelected {
        Public Boolean fSelected {get; set;}
        Public String Section {get; set;}
        Public String Label {get; set;}
        Public String API {get; set;}
        public wFieldSelected(String l, String a, Boolean isC, String s) {
            Label = l;
            API = a;
            fSelected = isC;
            Section = s;
        }
    }
    
    Public class wOrganisation {
        Public Boolean bSelected{get;set;}
        Public Account oAccount{get;set;}
        Public wOrganisation(Boolean b, Account a){
            bSelected = b;
            oAccount = a;
        }
    }




}