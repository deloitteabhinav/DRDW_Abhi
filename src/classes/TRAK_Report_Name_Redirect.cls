public class TRAK_Report_Name_Redirect {

public String reportName {set;get;}
public String releaseName {set;get;}

    public TRAK_Report_Name_Redirect(ApexPages.StandardController controller) {
    if(!Test.isRunningTest()){
    controller.addFields(new List<String> {'Name'});}
    TRAK_Release__c releaseObj = (TRAK_Release__c)controller.getRecord();
    releaseName = releaseObj.Name;
    reportName = ApexPages.currentPage().getParameters().get('reportName');
    }


    public PageReference actionRedirect() {
        List<Report> lReport = [Select Id from Report where DeveloperName = :reportName 
        and FolderName = 'Release Tracker'];
        Pagereference pageRef = null;
        if(lReport.size() > 0) {
        pageRef = new Pagereference('/'+lReport[0].Id+'?pv0='+releaseName);
        pageRef.setRedirect(true);
        return pageRef;
        } else {
        apexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'An Error has occurred while displaying the report. '+
        'Please contact your Senior System Administrator. '+reportName));
        return null;
        }
    }

}