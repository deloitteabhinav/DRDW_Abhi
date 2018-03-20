@isTest
public class Test_TRAK_Test_ScriptTriggerClass {

public static testmethod void testScriptMethod() {

List<TRAK_Test_Templates__c> lTestScript = TRAK_Test_Utility.createTestScript(1);
insert lTestScript;
Map<Id,TRAK_Test_Templates__c> mTestScript = new Map<Id,TRAK_Test_Templates__c>();
for(TRAK_Test_Templates__c oTestScript : lTestScript) {
mTestScript.put(oTestScript.Id,oTestScript);
}

TRAK_Test_ScriptTriggerClass controller = new TRAK_Test_ScriptTriggerClass();
TRAK_Test_ScriptTriggerClass.createNewTestScriptHistoryRecord(mTestScript);
TRAK_Test_ScriptTriggerClass.updateApprovalDate(mTestScript , Datetime.now());
TRAK_Test_ScriptTriggerClass.updateRejectionStatus(mTestScript);
TRAK_Test_ScriptTriggerClass.updateSubmitterInfo(mTestScript, mTestScript);

}

}