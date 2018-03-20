/******************************************************************************************************************************************
* Class Name   : PartnershipDashboard
* Description  : Controller class for RWE Research Partnership Dashboard
* Created By   : Waseem Sabeel
*
*****************************************************************************************************************************************/
Public without sharing class PartnershipDashboard {
    //empty Constructor
    Public PartnershipDashboard() {}

    /******* Remote method to obtain the PartnershipStudyWrapper Structure ******/
    @RemoteAction
    Public static wrapperPartnership GeneratePartnershipStudyWrapper() {
        
        //populating Graph info
        wrapperPartnership oWrap = new wrapperPartnership();
        integer StudyCount = 0;
        integer PartnershipCount = 0;
        List<ChartData> lChartDataAll = new List<ChartData>();
        For (AggregateResult oPartnership : [SELECT count(id) RecordTotal FROM Request__c WHERE RecordType.DeveloperName = 'RWE_Partnership_Exploration' AND Partnership_Status__c = 'Approved and Active' GROUP BY Partnership_Sponsor__c ]) {
            PartnershipCount = PartnershipCount + integer.valueof(oPartnership.get('RecordTotal'));
        }
        
        For(AggregateResult ar: [Select Count(Id) TC, DRDW_Partner__r.Name PN from Project__c WHERE Project_Status__c != 'On Hold' AND Project_Status__c != 'Cancelled' AND Conducted_with_an_Partner__c = 'Yes' AND DRDW_Partner__c!= null  AND  DRDW_Partner__r.Partnership_Status__c = 'Approved and Active' GROUP BY  DRDW_Partner__r.Name ORDER BY Count(Id) DESC]) {
            StudyCount = StudyCount + integer.valueof(ar.get('TC'));
            lChartDataAll.add(new ChartData(String.valueOf(ar.get('PN')), Integer.valueOf(ar.get('TC'))));
        }
        
        if(PartnershipCount<10) oWrap.PartnershipCount = '0'+string.valueof(PartnershipCount);
        else oWrap.PartnershipCount = string.valueof(PartnershipCount);
        if(StudyCount<10) oWrap.StudyCount = '0'+string.valueof(StudyCount);
        else oWrap.StudyCount = string.valueof(StudyCount);
        
        //Displaying only Top 10 Partnership Names associated to Studies
        if(lChartDataAll.size()>10) {
            List<ChartData> lChartDataTop10 = new List<ChartData>();
            for(integer i=0;i<10;i++){
                lChartDataTop10.add(lChartDataAll[i]);
            }
            lChartDataTop10.sort();
            oWrap.lStudyPartnership = lChartDataTop10;
        }
        else {
            lChartDataAll.sort();
            oWrap.lStudyPartnership = lChartDataAll;
        }
        
        return oWrap;
    }

    /******* Remote method to obtain the ApprovedPartnershipWrapper Structure ******/
    @RemoteAction
    Public static wrapperPartnership GenerateApprovedPartnershipWrapper() {
        map<string, string> mPicklistVal = new map<string, string>();
        map<string, integer> mContent = new map<string, integer>();
        //Getting Picklist Value Restrictions
        for(Console__c oConsole : [SELECT id,Picklist_Field_Name__c, Name, Display_Name__c FROM Console__c WHERE RecordType.DeveloperName = 'Executive_Dashboard_Setting' AND Active__c=TRUE AND Picklist_Field_Name__c = 'RWE Partnership Sponsor']){
            if(oConsole !=null){
                if(oConsole.Display_Name__c!='' && oConsole.Display_Name__c!=null)
                    mPicklistVal.put(oConsole.Name,oConsole.Display_Name__c);
                else
                    mPicklistVal.put(oConsole.Name,oConsole.Name);
            }    
        }
        
        //populating Graph info
        wrapperPartnership oWrap = new wrapperPartnership();
        List<ChartData> lChartData = new List<ChartData>();
        For(AggregateResult ar: [Select Count(Id) TC, Partnership_Sponsor__c Sponsor from Request__c WHERE RecordType.DeveloperName = 'RWE_Partnership_Exploration' AND Partnership_Status__c = 'Approved and Active' GROUP BY Partnership_Sponsor__c]) {
            if (String.valueOf(ar.get('Sponsor'))!=null && mPicklistVal.containskey(String.valueOf(ar.get('Sponsor')))) {
                    mContent.put(mPicklistVal.get(String.valueOf(ar.get('Sponsor'))), Integer.valueOf(ar.get('TC')));
            } else {
                if(mContent.containskey('Other')) {
                    mContent.put('Other', mContent.get('Other') + Integer.valueOf(ar.get('TC')));
                } else {
                    mContent.put('Other', Integer.valueOf(ar.get('TC')));
                }
            }
        }
        for(string Key : mContent.keyset()){
            lChartData.add(new ChartData(Key,mContent.get(Key)));
        }
        lChartData.sort();
        oWrap.lApprovedPartnership = lChartData;
        return oWrap;
    }


    /******** Complete Wrapper PVA Class **********/
    Public Class wrapperPartnership {
        Public string StudyCount;
        Public string PartnershipCount;
        Public List<ChartData> lApprovedPartnership;
        Public List<ChartData> lStudyPartnership;

    }

    /******** Chart Item Wrapper class ********/
    Public class ChartData implements Comparable {
        Public String Name;
        Public Integer Data;

        public ChartData(String name, Integer data) {
            if (name == null || name == '') {
                this.Name = 'N/A';
            } else {
            this.Name = name.abbreviate(23);
            }

            if (data == null) {
                this.Data = 0;
            } else {this.Data = data;}

        }

        /****** Method to Sort the ChartData Wrapper Structure ******/
        Public Integer compareTo(Object compareTo) {
            ChartData compareToRec = (ChartData)compareTo;
            if (Data < compareToRec.Data) {
                return 1;
            } else if (Data > compareToRec.Data) {
                return -1;
            } else {
                return 0;
            }
        }
    }
}