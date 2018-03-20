public class TRAK_New_Release_Override {

public String releaseKeyPrefix = TRAK_Release__c.getSobjectType().getDescribe().getKeyPrefix();
public String releaseCreationRecordTypeId = TRAK_Release__c.getSobjectType().getDescribe().getRecordTypeInfosByName().get('Creation of Release').getRecordTypeId();

    public TRAK_New_Release_Override(ApexPages.StandardController controller) { }
    
    public PageReference actionRedirect() {
        PageReference pageRef = new PageReference('/'+releaseKeyPrefix+'/e');
        pageRef.getParameters().put('Name','DO NOT ENTER');
        pageRef.getParameters().put('nooverride','1');
        pageRef.getParameters().put('retURL',ApexPages.currentPage().getParameters().get('retURL'));
        pageRef.getParameters().put('RecordType',releaseCreationRecordTypeId);
        pageRef.setRedirect(true);
        return pageRef;
    }

}