public with sharing class LeadershipDashboard {
    Public String DashboardSelector {
        get;
        set;
    }
    Public Transient Map < String, String > mDashboardMap {
        get;
        set;
    }
    Public List < SelectOption > lDashboardList {
        get;
        set;
    }
    Public List < Console__c > lConsole;
    Public PageReference dbError;
    Public Blob ErrorBlob;
    public LeadershipDashboard() {
        mDashboardMap = new Map < String, String > ();
        lDashboardList = new List < SelectOption > ();
        DashboardSelector = '';
        lConsole = new List < Console__c > ();
        If(ApexPages.currentPage().getParameters().get('IsError') == null) {
            dbError = new PageReference('/apex/LeadershipDashboard?IsError=TRUE');
            if (Test.IsRunningTest()) {
                ErrorBlob = Blob.valueOf('UNIT.TEST');
            }
            Else{
                ErrorBlob = dbError.getContent();
            }
        }
    }

    /* 
     * @Method Name                    :  Refresh
     * @Description                    :  Action Method called from the Page
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */

    Public PageReference Refresh() {
        mDashboardMap = new Map < String, String > ();
        If(ApexPages.currentPage().getParameters().get('IsError') == null) {
            For(Note oNote: [Select Title, Body from Note where ParentId IN: lConsole Order By CreatedDate]) {
                If(oNote.Body != NULL && oNote.Body != '') {
                    PageReference dbPage = new PageReference(oNote.Body);
                    Blob pageBlob;
                    Try {
                        if (Test.IsRunningTest()) {
                            pageBlob = Blob.valueOf('UNIT.TEST');
                        }
                        else{
                            pageBlob = dbPage.getContent();
                        }
                    }
                    Catch(Exception e) {
                        pageBlob = ErrorBlob;
                    }
                    mDashboardMap.put(oNote.Title, pageBlob.toString());
                }
            }
        }
        return null;
    }

    /* 
     * @Method Name                    :  ExecuteDashboard
     * @Description                    :  Method to Generate Dashboards and to Redirect to Native Dashboards if No Dashboards on the Page Found
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */
    Public PageReference ExecuteDashboard() {
        If(ApexPages.currentPage().getParameters().get('IsError') == null) {
            lConsole = [Select Name, Id from Console__c where Name = 'Leadership Dashboards'
                LIMIT 1
            ];
            If(!lConsole.IsEmpty()) {
                For(Note oNote: [Select Title, Body from Note where ParentId IN: lConsole Order By CreatedDate]) {
                    If(oNote.Body != NULL && oNote.Body != '') {
                        PageReference dbPage = new PageReference(oNote.Body);
                        Blob pageBlob;
                            Try {
                                if (Test.IsRunningTest()) {
                                    pageBlob = Blob.valueOf('UNIT.TEST');
                                }
                                else{
                                    pageBlob = dbPage.getContent();
                                }
                            }
                            Catch(Exception e) {
                                pageBlob = ErrorBlob;
                            }
                        mDashboardMap.put(oNote.Title, pageBlob.toString());
                    }
                }
                For(String sTitles: mDashboardMap.Keyset()) {
                    lDashboardList.add(new SelectOption(sTitles, sTitles));
                }
            }
            If(lDashboardList.size() > 0) {
                DashboardSelector = lDashboardList[0].getValue();
            }
        }
        return null;

    }
}