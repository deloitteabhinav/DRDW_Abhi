/****************************************************************************************************************************************** 
 * Class Name   : DataAssetList 
 * Description  : Class to display the List of Data Asset records
 * Created By   : Deloitte Consulting
 * 
 *****************************************************************************************************************************************/
Public with sharing class DataAssetList {

    Public ApexPages.StandardSetController cDataAssetListCntlr {
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
    Public List < SelectOption > oDataAssetOptions {
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
    Public Map < String, List < wDataAssetObject >> mDataAssetObjectStructure {
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

    public List < wFieldSelected > lFieldWrapper;

    public set < id > sSelectedAssetId {
        get;
        set;
    }
    public Set < String > sSelectedFields {
        get;
        set;
    }
    public List < String > lSelectedFields {
        get;
        set;
    }
    
    Public Map < String, String > mFieldList;

    Public List < Data_Asset__c > AssetSelectedList {
        get;
        set;
    }
    Public List < String > lSections {
        get;
        set;
    }
    Public Map < String, String > mLabel {
        get;
        set;
    }
     Public List < wFieldSelected > FieldList{
         get;
         set;
     }
     @TestVisible List < wAssetRecordWrap > lAssetRecordWrap {
         get;
         set;
     }
     public boolean bShowMoreFlag 
    {
        get;
        set;
    }
     
    /* Getter Setter to be removed after r20*/ 
    Public string sOwnerType {
        get;
        set;
    }

    /* 
     * @Method Name                    :  getDataAssets
     * @Description                    :  Initialize cDataAssetListCntlr and return a list of records
     * @Return Type                    :  list of data asset records
     * @Parameters                     :  None
     */
    Public List < Data_Asset__c > getDataAssets() {
        return (List < Data_Asset__c > ) cDataAssetListCntlr.getRecords();
    }
    
    /* 
     * @Method Name                    :  getlAssetRecordWrap
     * @Description                    :  making a data asset wrapper with selection choices
     * @Return Type                    :  list of data asset record wrapper
     * @Parameters                     :  None
     */
    Public List<wAssetRecordWrap> getlAssetRecordWrap() {
        lAssetRecordWrap = new List<wAssetRecordWrap>();
        for (Data_Asset__c oAsset : (List<Data_Asset__c>)cDataAssetListCntlr.getRecords())
            lAssetRecordWrap.add(new wAssetRecordWrap(oAsset));
    
        return lAssetRecordWrap;
    }


    //Loading the constructor the page
    Public DataAssetList() {
        pNoLimit = 20;
        // Initialisation 
        sField = 'Name';
        previousSField = 'Name';
        sOrder = 'ASC NULLS FIRST';
        bShowMoreFlag = TRUE;
        mDataAssetObjectStructure = new Map < String, List < wDataAssetObject >> ();

        //Initialisation for compare report collections
        sSelectedFields = new Set < String > ();
        lSelectedFields = new List < String > ();
        mFieldList = new Map < String, String > ();
        sSelectedAssetId = new Set < Id > ();
        AssetSelectedList = new List < Data_Asset__c > ();
        lSections = new List < String > ();
        lAssetRecordWrap = new List < wAssetRecordWrap > ();

        // Methods for call
        DescribeObjectWithDetails();
        Query(string.escapeSingleQuotes(sField) + ' ' + string.escapeSingleQuotes(sOrder));
        FieldListMaker();
        FieldList = getFieldList();     

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
        List < wDataAssetObject > lPicklist = new List < wDataAssetObject > ();
        mCategoyCount = new Map < String, Integer > ();

        // Not using global describe which is taking longer time, hence hardcoding the field for describe
        for (Schema.Picklistentry oPicklistValues: Data_Asset__c.Relevant_Therapeutic_Area__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wDataAssetObject(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mDataAssetObjectStructure.put('Relevant_Therapeutic_Area__c', lPicklist);

        lPicklist = new List < wDataAssetObject > ();
        for (Schema.Picklistentry oPicklistValues: Data_Asset__c.Region__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wDataAssetObject(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mDataAssetObjectStructure.put('Region__c', lPicklist);

        lPicklist = new List < wDataAssetObject > ();
        for (Schema.Picklistentry oPicklistValues: Data_Asset__c.Type_of_Database__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wDataAssetObject(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mDataAssetObjectStructure.put('Type_of_Database__c', lPicklist);

        lPicklist = new List < wDataAssetObject > ();
        for (Schema.Picklistentry oPicklistValues: Data_Asset__c.Access_Method__c.getDescribe().getPicklistValues()) {
            lPicklist.add(new wDataAssetObject(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mDataAssetObjectStructure.put('Access_Method__c', lPicklist);

    }

    /* 
     * @Method Name                    :  FrameClause
     * @Description                    :  This method constructs the query clause if check boxes are checked on UI 
     * @Return Type                    :  string
     * @Parameters                     :  List of wDataAssetObject  
     */
    Public string FrameClause(List < wDataAssetObject > lWrapperForProcessing) {
        String sClause = '';

        for (wDataAssetObject oWrapper: lWrapperForProcessing) {
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
        List < Data_Asset__c > lSearchWordProjects = new List < Data_Asset__c > ();

        sRegionClause = FrameClause(mDataAssetObjectStructure.get('Region__c'));
        if (sRegionClause != '') {
            sRegionClause = ' Region__c IN ' + sRegionClause;
        }

        sAccessMethodClause = FrameClause(mDataAssetObjectStructure.get('Access_Method__c'));
        if (sAccessMethodClause != '') {
            sAccessMethodClause = ' Access_Method__c IN ' + sAccessMethodClause;
        }

        sTherapeuticAreaClause = FrameClause(mDataAssetObjectStructure.get('Relevant_Therapeutic_Area__c'));
        if (sTherapeuticAreaClause != '') {
            sTherapeuticAreaClause = ' Relevant_Therapeutic_Area__c IN ' + sTherapeuticAreaClause;
        }

        sTypeofDatabaseClause = FrameClause(mDataAssetObjectStructure.get('Type_of_Database__c'));
        if (sTypeofDatabaseClause != '') {
            sTypeofDatabaseClause = ' Type_of_Database__c IN ' + sTypeofDatabaseClause;
        }

        If(sAccessDetailType != null && sAccessDetailType != '') {
            sAccessDetailClause = ' Access_Details__c  IN (\'' + string.escapeSingleQuotes(sAccessDetailType) + '\')';
        }

        if (sSearchWord != null && sSearchWord.trim() != '') {
            sSearchClause = ' Id IN : lSearchWordProjects';
        }

        if (sSearchWord != null && sSearchWord.trim() != '') {

            List < List < sObject >> lDynamicSearchResult = search.query('FIND \'' + string.escapeSingleQuotes(sSearchWord) + '\' IN ALL FIELDS RETURNING Data_Asset__c (Id,Name,Region__c,Access_Method__c,Relevant_Therapeutic_Area__c,Asset_Status__c,Type_of_Database__c,Access_Details__c  ' + CombineQuery('WHERE', new List < String > {
                sRegionClause, sAccessMethodClause, sTherapeuticAreaClause, sTypeofDatabaseClause, sAccessDetailClause
            }) +  ' ORDER BY ' + sOrder + ')');
            lSearchWordProjects = lDynamicSearchResult[0];
            cDataAssetListCntlr = new ApexPages.StandardSetController(lDynamicSearchResult[0]);
        } else {
            cDataAssetListCntlr = new ApexPages.StandardSetController(Database.getQueryLocator(
                'SELECT Name,Region__c,Access_Method__c,Relevant_Therapeutic_Area__c,Asset_Status__c,Type_of_Database__c,Access_Details__c  FROM Data_Asset__c ' + CombineQuery('WHERE', new List < String > {
                    sRegionClause, sAccessMethodClause, sTherapeuticAreaClause, sTypeofDatabaseClause, sAccessDetailClause
                }) + ' ORDER BY ' + sOrder));
        }


        cDataAssetListCntlr.setPageSize(50);
        lPageNumbers = new List < Integer > ();
        dPageCount = 0;
        dPageCount = (decimal.valueof(cDataAssetListCntlr.getResultSize()) / decimal.valueof(cDataAssetListCntlr.getPageSize()));
        dPageCount = dPageCount.round(System.RoundingMode.UP);

        for (Integer i = 1; i <= dPageCount; i++) {
            lPageNumbers.add(i);
            if (lPageNumbers.size() == pNoLimit)
                break;
        }

        for (String mCount: mCategoyCount.keyset()) {
            mCategoyCount.put(mCount, 0);
        }
        for (AggregateResult ar: database.query('SELECT count(Id),Relevant_Therapeutic_Area__c FROM Data_Asset__c where Relevant_Therapeutic_Area__c!=null ' + CombineQuery('AND', new List < String > {
                sRegionClause, sAccessMethodClause, sTypeofDatabaseClause, sAccessDetailClause, sSearchClause
            }) + ' Group BY Relevant_Therapeutic_Area__c')) {
            mCategoyCount.put((String) ar.get('Relevant_Therapeutic_Area__c'), (Integer) ar.get('expr0'));
        }
        for (AggregateResult ar: database.query('SELECT count(Id),Region__c FROM Data_Asset__c where Region__c !=null ' + CombineQuery('AND', new List < String > {
                sTherapeuticAreaClause, sAccessMethodClause, sTypeofDatabaseClause, sAccessDetailClause, sSearchClause
            }) + ' Group BY Region__c')) {
            mCategoyCount.put((String) ar.get('Region__c'), (Integer) ar.get('expr0'));
        }

        for (AggregateResult ar: database.query('SELECT count(Id),Type_of_Database__c FROM Data_Asset__c where Type_of_Database__c!=null ' + CombineQuery('AND', new List < String > {
                sRegionClause, sAccessMethodClause, sTherapeuticAreaClause, sAccessDetailClause, sSearchClause
            }) + ' Group BY Type_of_Database__c')) {
            mCategoyCount.put((String) ar.get('Type_of_Database__c'), (Integer) ar.get('expr0'));
        }

        for (AggregateResult ar: database.query('SELECT count(Id),Access_Method__c FROM Data_Asset__c where Access_Method__c!=null ' + CombineQuery('AND', new List < String > {
                sRegionClause, sTherapeuticAreaClause, sTypeofDatabaseClause, sAccessDetailClause, sSearchClause
            }) + ' Group BY Access_Method__c')) {
            mCategoyCount.put((String) ar.get('Access_Method__c'), (Integer) ar.get('expr0'));
        }

        //Initialise dropdown of OwnerType
        oDataAssetOptions = new List < SelectOption > ();
        oDataAssetOptions.add(new SelectOption('', 'All Access Details'));
        for (AggregateResult ar: database.query('SELECT count(Id),Access_Details__c FROM Data_Asset__c where Access_Details__c !=null AND Access_Details__c !=null' + CombineQuery('AND', new List < String > {
                sRegionClause, sAccessMethodClause, sTherapeuticAreaClause, sTypeofDatabaseClause, sSearchClause
            }) + ' Group BY Access_Details__c')) {
            oDataAssetOptions.add(new SelectOption((String) ar.get('Access_Details__c'), (String) ar.get('Access_Details__c')));
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
        cDataAssetListCntlr.setPagenumber(iPageNumber);
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

        //Map for Getting all the Fields from Data Asset Object
        Map < String, Schema.SObjectField > M = new Map < String, Schema.SObjectField > ();
        M = Schema.SObjectType.Data_Asset__c.fields.getMap();

        //Querying the Console object to get the data
        //Adding Fields Names and Label to the Map which are used for Reporting

        List < Console__c > lConsole = [Select Name, Id from Console__c where Name = 'RWD Inventory'
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
            wFieldSelected wField = new wFieldSelected(Schema.SObjectType.Data_Asset__c.fields.getMap().get(sWrap).getDescribe().getLabel(), sWrap, false, mFieldList.get(sWrap));
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
        For(wAssetRecordWrap oWrap: lAssetRecordWrap) {
            If(oWrap.isSelected) {
                sSelectedAssetId.add(oWrap.oAsset.id);
            }
        }
        mLabel = new Map < String, String > ();

        For(wFieldSelected oWrapper: lFieldWrapper) {
            If(oWrapper.fselected) {
                Schema.DisplayType fType = Schema.SObjectType.Data_Asset__c.fields.getMap().get(oWrapper.API).getDescribe().getType();
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
        PageReference PageRef = new PageReference('/apex/AssetCompare');
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
        PageReference PageRef = new PageReference('/apex/AssetReport');
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
        String myQuery = 'Select Id,Name,Asset_Status__c';

        for (String field: sSelectedFields) {
            myQuery += ',' + field + ' ';
        }

        myQuery += ' from Data_Asset__c Where Id IN:sSelectedAssetId LIMIT 50';

        //Executing the query and fetching results  
        AssetSelectedList = Database.query(myQuery);
    }
    
    Public class wAssetRecordWrap {
        Public Boolean isSelected {
            get;
            set;
        }
        Public Data_Asset__c oAsset {
            get;
            set;
        }
        Public wAssetRecordWrap (Data_Asset__c DA){
            oAsset = DA;
        }
     }


    /*
     * Class name   : wDataAssetObject
     * Description  : This is a wrapper class which holds the picklist value name and checkbox to filter out results on Data Asset list Page
     */

    Public class wDataAssetObject {
        Public Boolean isSelected {
            get;
            set;
        }
        Public string label {
            get;
            set;
        }
        public wDataAssetObject(String l, Boolean isC) {
            label = l;
            isSelected = isC;
        }
    }

    /*
     * Class name   : wFieldSelected
     * Description  : This is a wrapper class which holds the field values and checkbox to generate dynamic report
     */

    Public class wFieldSelected {
        Public Boolean fSelected {
            get;
            set;
        }
        Public String Section {
            get;
            set;
        }
        Public String Label {
            get;
            set;
        }
        Public String API {
            get;
            set;
        }
        public wFieldSelected(String l, String a, Boolean isC, String s) {
            Label = l;
            API = a;
            fSelected = isC;
            Section = s;
        }
    }


}