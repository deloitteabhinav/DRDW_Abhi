/******************************************************************************************************************************************
* Class Name   : RWDDashboard
* Description  : Controller class for Real World Data Dashboard
* Created By   : Waseem Sabeel
*
*****************************************************************************************************************************************/

Public without sharing class RWDDashboard {

    //empty constructor
    Public RWDDashboard() {}

    /******* Remote method to obtain the RWD Type Of Database Chart Wrapper Structure ******/
    @RemoteAction
    Public static wrapperRWD getwrapperRWD1() {
        Integer RWDAssetCount = 0;
        Integer RWDStudyCount = 0;
        Integer RWDAssetinStudyCount = 0;
        list<ChartData> lTypeRWDChart = new list<ChartData>();
        map<string, string> mPicklistVal = new map<string, string>();
        map<string, integer> mContent = new map<string, integer>();

        //Getting Picklist Value Restrictions
        for (Console__c oConsole : [SELECT id, Picklist_Field_Name__c, Name, Display_Name__c FROM Console__c WHERE RecordType.DeveloperName = 'Executive_Dashboard_Setting' AND Active__c = TRUE AND Picklist_Field_Name__c = 'Type of Database']) {
            if (oConsole != null) {
                if (oConsole.Display_Name__c != '' && oConsole.Display_Name__c != null)
                    mPicklistVal.put(oConsole.Name, oConsole.Display_Name__c);
                else
                    mPicklistVal.put(oConsole.Name, oConsole.Name);
            }
        }

        //populating Graph info
        for (AggregateResult ar : [Select Count(Id) TC, Type_of_Database__c Data from Data_Asset__c GROUP BY Type_of_Database__c]) {
            RWDAssetCount = RWDAssetCount + Integer.valueOf(ar.get('TC'));
            if (String.valueOf(ar.get('Data')) != null && mPicklistVal.containskey(String.valueOf(ar.get('Data')))) {
                   mContent.put(mPicklistVal.get(String.valueOf(ar.get('Data'))), Integer.valueOf(ar.get('TC')));
            } else {
                if (mContent.containskey('Other')) {
                    mContent.put('Other', mContent.get('Other') + Integer.valueOf(ar.get('TC')));
                } else {
                    mContent.put('Other', Integer.valueOf(ar.get('TC')));
                }
            }
        }
        for (string Key : mContent.keyset()) {
            lTypeRWDChart.add(new ChartData(Key, mContent.get(Key)));
        }


        //Count of Studies with one or more data assets associated to it
        for (AggregateResult oStudy : [SELECT count(id) TC FROM Related_Data_Asset__c WHERE  Project__c!=null AND Project__r.Project_Status__c NOT IN ('On Hold', 'Cancelled') GROUP BY Project__c ]) {
            RWDStudyCount++;
        }
        
        //unique no. of data assets that are associated to studies
        for (AggregateResult ar : [Select Count(Project__c) TC, Data_Asset__c RWDID from Related_Data_Asset__c WHERE Project__c != NULL AND Project__r.Project_Status__c NOT IN ('On Hold', 'Cancelled') GROUP BY Data_Asset__c ]) {
            RWDAssetinStudyCount = RWDAssetinStudyCount + 1;
        }

        lTypeRWDChart.sort();
        wrapperRWD oWrap = new wrapperRWD();
        oWrap.RWDAssetCount = RWDAssetCount;
        oWrap.RWDStudyCount = RWDStudyCount;
        oWrap.RWDAssetinStudyCount = RWDAssetinStudyCount;
        oWrap.lChart = lTypeRWDChart;
        return oWrap;
    }

    /******* Remote method to obtain the RWD Access Method Chart Wrapper Structure ******/
    @RemoteAction
    Public static wrapperRWD getwrapperRWD2() {
        list<ChartData> lAccessRWDChart = new list<ChartData>();
        map<string, string> mPicklistVal = new map<string, string>();
        map<string, integer> mContent = new map<string, integer>();

        //Getting Picklist Value Restrictions
        for (Console__c oConsole : [SELECT id, Picklist_Field_Name__c, Name, Display_Name__c FROM Console__c WHERE RecordType.DeveloperName = 'Executive_Dashboard_Setting' AND Active__c = TRUE AND Picklist_Field_Name__c = 'Access Method']) {
            if (oConsole != null) {
                if (oConsole.Display_Name__c != '' && oConsole.Display_Name__c != null)
                    mPicklistVal.put(oConsole.Name, oConsole.Display_Name__c);
                else
                    mPicklistVal.put(oConsole.Name, oConsole.Name);
            }
        }

        //populating Graph info
        for (AggregateResult ar : [Select Count(Id) TC, Access_Method__c Data from Data_Asset__c GROUP BY Access_Method__c]) {
            if (String.valueOf(ar.get('Data')) != null && mPicklistVal.containskey(String.valueOf(ar.get('Data')))) {
                 mContent.put(mPicklistVal.get(String.valueOf(ar.get('Data'))), Integer.valueOf(ar.get('TC')));
            } else {
                if (mContent.containskey('Other')) {
                    mContent.put('Other', mContent.get('Other') + Integer.valueOf(ar.get('TC')));
                } else {
                    mContent.put('Other', Integer.valueOf(ar.get('TC')));
                }
            }
        }
        for (string Key : mContent.keyset()) {
            lAccessRWDChart.add(new ChartData(Key, mContent.get(Key)));
        }

        lAccessRWDChart.sort();
        wrapperRWD oWrap = new wrapperRWD();
        oWrap.lChart = lAccessRWDChart;
        return oWrap;
    }

    /******* Remote method to obtain the RWD Region Chart Wrapper Structure ******/
    @RemoteAction
    Public static wrapperRWD getwrapperRWD3() {
        list<ChartData> lRegionRWDChart = new list<ChartData>();
        map<string, string> mPicklistVal = new map<string, string>();
        map<string, integer> mContent = new map<string, integer>();

        //Getting Picklist Value Restrictions
        for (Console__c oConsole : [SELECT id, Picklist_Field_Name__c, Name, Display_Name__c FROM Console__c WHERE RecordType.DeveloperName = 'Executive_Dashboard_Setting' AND Active__c = TRUE AND Picklist_Field_Name__c = 'Region']) {
            if (oConsole != null) {
                if (oConsole.Display_Name__c != '' && oConsole.Display_Name__c != null)
                    mPicklistVal.put(oConsole.Name, oConsole.Display_Name__c);
                else
                    mPicklistVal.put(oConsole.Name, oConsole.Name);
            }
        }

        //populating Graph info
        for (AggregateResult ar : [Select Count(Id) TC, Region__c Data from Data_Asset__c GROUP BY Region__c]) {
            if (String.valueOf(ar.get('Data')) != null && mPicklistVal.containskey(String.valueOf(ar.get('Data')))) {
                 mContent.put(mPicklistVal.get(String.valueOf(ar.get('Data'))), Integer.valueOf(ar.get('TC')));
            } else {
                if (mContent.containskey('Other')) {
                    mContent.put('Other', mContent.get('Other') + Integer.valueOf(ar.get('TC')));
                } else {
                    mContent.put('Other', Integer.valueOf(ar.get('TC')));
                }
            }
        }
        for (string Key : mContent.keyset()) {
            lRegionRWDChart.add(new ChartData(Key, mContent.get(Key)));
        }

        lRegionRWDChart.sort();

        wrapperRWD oWrap = new wrapperRWD();
        oWrap.lChart = lRegionRWDChart;
        return oWrap;
    }

    /******* Remote method to obtain the Study Type Of Database Chart Wrapper Structure ******/
    @RemoteAction
    Public static wrapperRWD getwrapperRWD4() {
        list<ChartData> lTypeStudiesChart = new list<ChartData>();
        map<string, string> mPicklistVal = new map<string, string>();
        map<string, integer> mContent = new map<string, integer>();

        //Getting Picklist Value Restrictions
        for (Console__c oConsole : [SELECT id, Picklist_Field_Name__c, Name, Display_Name__c FROM Console__c WHERE RecordType.DeveloperName = 'Executive_Dashboard_Setting' AND Active__c = TRUE AND Picklist_Field_Name__c = 'Type of Database']) {
            if (oConsole != null) {
                if (oConsole.Display_Name__c != '' && oConsole.Display_Name__c != null)
                    mPicklistVal.put(oConsole.Name, oConsole.Display_Name__c);
                else
                    mPicklistVal.put(oConsole.Name, oConsole.Name);
            }
        }

        //populating Graph info
        for (AggregateResult ar : [Select Count(Project__c) TC, Data_Asset__r.Type_of_Database__c Data from Related_Data_Asset__c WHERE Project__c != NULL AND Project__r.Project_Status__c NOT IN ('On Hold', 'Cancelled') GROUP BY Data_Asset__r.Type_of_Database__c]) {
            if (String.valueOf(ar.get('Data')) != null && mPicklistVal.containskey(String.valueOf(ar.get('Data')))) {
                    mContent.put(mPicklistVal.get(String.valueOf(ar.get('Data'))), Integer.valueOf(ar.get('TC')));
            } else {
                if (mContent.containskey('Other')) {
                    mContent.put('Other', mContent.get('Other') + Integer.valueOf(ar.get('TC')));
                } else {
                    mContent.put('Other', Integer.valueOf(ar.get('TC')));
                }
            }
        }
        for (string Key : mContent.keyset()) {
            lTypeStudiesChart.add(new ChartData(Key, mContent.get(Key)));
        }

        lTypeStudiesChart.sort();
        wrapperRWD oWrap = new wrapperRWD();
        oWrap.lChart = lTypeStudiesChart;
        return oWrap;
    }

    /******* Remote method to obtain the Study Access Method Chart Wrapper Structure ******/
    @RemoteAction
    Public static wrapperRWD getwrapperRWD5() {
        list<ChartData> lAccessStudiesChart = new list<ChartData>();
        map<string, string> mPicklistVal = new map<string, string>();
        map<string, integer> mContent = new map<string, integer>();

        //Getting Picklist Value Restrictions
        for (Console__c oConsole : [SELECT id, Picklist_Field_Name__c, Name, Display_Name__c FROM Console__c WHERE RecordType.DeveloperName = 'Executive_Dashboard_Setting' AND Active__c = TRUE AND Picklist_Field_Name__c = 'Access Method']) {
            if (oConsole != null) {
                if (oConsole.Display_Name__c != '' && oConsole.Display_Name__c != null)
                    mPicklistVal.put(oConsole.Name, oConsole.Display_Name__c);
                else
                    mPicklistVal.put(oConsole.Name, oConsole.Name);
            }
        }

        //populating Graph info
        for (AggregateResult ar : [Select Count(Project__c) TC, Data_Asset__r.Access_Method__c Data from Related_Data_Asset__c WHERE Project__c != NULL AND Project__r.Project_Status__c NOT IN ('On Hold', 'Cancelled')  GROUP BY Data_Asset__r.Access_Method__c]) {
            if (String.valueOf(ar.get('Data')) != null && mPicklistVal.containskey(String.valueOf(ar.get('Data')))) {
                    mContent.put(mPicklistVal.get(String.valueOf(ar.get('Data'))), Integer.valueOf(ar.get('TC')));
            } else {
                if (mContent.containskey('Other')) {
                    mContent.put('Other', mContent.get('Other') + Integer.valueOf(ar.get('TC')));
                } else {
                    mContent.put('Other', Integer.valueOf(ar.get('TC')));
                }
            }
        }
        for (string Key : mContent.keyset()) {
            lAccessStudiesChart.add(new ChartData(Key, mContent.get(Key)));
        }

        lAccessStudiesChart.sort();
        wrapperRWD oWrap = new wrapperRWD();
        oWrap.lChart = lAccessStudiesChart;
        return oWrap;
    }


    /******** Complete Wrapper RWD Class **********/
    public class wrapperRWD {
        Public integer RWDAssetCount;
        Public integer RWDStudyCount ;
        Public integer RWDAssetinStudyCount ;
        public list<ChartData> lChart;

        public wrapperRWD() {
            this.RWDAssetCount = 0;
            this.RWDStudyCount = 0;
            this.RWDAssetinStudyCount = 0;
            this.lChart = new list<ChartData>();
        }

    }

    /******** Chart Item Wrapper class ********/
    public class ChartData implements Comparable {
        public String name;
        public Integer data;

        public ChartData(String name, Integer data) {
            if (name == null || name == '') {
                this.name = 'N/A';
            } else {this.name = name.abbreviate(27);}

            if (data == null) {
                this.data = 0;
            } else {this.data = data;}
        }

        /****** Method to Sort the ChartData Wrapper Structure ******/
        Public Integer compareTo(Object compareTo) {
            ChartData compareToRec = (ChartData)compareTo;
            if (data < compareToRec.data) {
                return 1;
            } else if (data > compareToRec.data) {
                return -1;
            } else {
                return 0;
            }
        }
    }
}