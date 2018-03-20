/******************************************************************************************************************************************
 * Trigger Name   : TRAK_createTestsForTester
 * Description  : Creates Tests for Tester based on template
 * Created By   : Deloitte Consulting
 *
 *****************************************************************************************************************************************/
public class TRAK_createTestsForTester {
    /*
     * @Method Name                    :  afterInsert
     * @Description                    :  Once a Tester record is added , this method creates a test execution and test execution step automatically. 
     * @Return Type                    :  void
     */
    public static void afterInsert(List < TRAK_tester__c > lTester) {
        List < TRAK_Test__c > Tst = new List < TRAK_Test__c > ();
        List < TRAK_Test_Templates__c > Templates = new List < TRAK_Test_Templates__c > ();
        Set < Id > TempDetails = new Set < Id > ();
        Map < Id, List < TRAK_Test_Steps__c >> TempSteps = new Map < Id, List < TRAK_Test_Steps__c >> ();
        Map < id, TRAK_Test_Templates__c > template2story = new map < id, TRAK_Test_Templates__c > ();
        for (TRAK_tester__c t: lTester) {
            TempDetails.add(t.Test_Template__c);
        }
        for (TRAK_Test_Templates__c t: [select id, user_story__c, user_story__r.Allocated_Sprint__c from TRAK_Test_Templates__c where id in: TempDetails]) {
            template2story.put(t.id, t);
        }
        for (TRAK_Tester__c t: lTester) {
            Tst.add(new TRAK_Test__c(
                Template__c = t.Test_Template__c,
                user_story__c = template2story.get(t.Test_Template__c).user_story__c,
                sprint__c = template2story.get(t.Test_Template__c).user_story__r.Allocated_Sprint__c,
                Status__c = 'Not Started',
                Test_Phase__c = t.Test_Phase__c,
                Assigned_To__c = t.User__c));
        }
        id ParId = null;
        List < TRAK_Test_Steps__c > toMap = new List < TRAK_Test_Steps__c > ();
        List < TRAK_Test_Steps__c > toMap2 = new List < TRAK_Test_Steps__c > ();
        for (TRAK_Test_Template_Steps__c ts: [select id, Name, Test_Script__c, Test_Script_Step_Number__c, Expected_Result__c, Action__c, Tips__c from TRAK_Test_Template_Steps__c where Test_Script__c in: TempDetails]) {
            if ((ParId == ts.Test_Script__c) || (ParId == null)) {
                toMap.add(new TRAK_Test_Steps__c(Template_Step__c = ts.id, Name = ts.name,
                    Test_Execution_Step_Number__c = ts.Test_Script_Step_Number__c,
                    TRAK_Action__c = ts.Action__c,
                    TRAK_Expected_Results__c = ts.Expected_Result__c,
                    TRAK_Tips__c = ts.Tips__c));
            } else {
                TempSteps.put(ParId, new List < TRAK_Test_Steps__c > (toMap.deepClone()));
                toMap.clear();
                toMap.add(new TRAK_Test_Steps__c(Template_Step__c = ts.id, Name = ts.name, Test_Execution_Step_Number__c = ts.Test_Script_Step_Number__c, TRAK_Action__c = ts.Action__c, TRAK_Expected_Results__c = ts.Expected_Result__c, TRAK_Tips__c = ts.Tips__c));
            }
            ParId = ts.Test_Script__c;
        }
        //  system.debug(toMap);
        // system.debug(ParId);
        TempSteps.put(ParId, new List < TRAK_Test_Steps__c > (toMap.deepClone()));
        //   system.debug(TempSteps);
        toMap.clear();
        try {
            insert tst;
        } catch (Exception excep) {
            TF_ErrorLogUtility.createErrorLog(excep, new TF_ErrorLogWrapper('TRAK_createTestsForTester', 'afterInsert', 'TRAK_createTestsForTester - afterInsert', '1'));
        }
        String st;
        for (TRAK_Test__c ab: tst) {
            st = ab.Template__c;
            //  system.debug(TempSteps.get(st));
            if (TempSteps.containsKey(st)) {
                list < TRAK_Test_Steps__c > zy = TempSteps.get(st);
                for (TRAK_Test_Steps__c x: zy) {
                    tomap2.add(new TRAK_Test_Steps__c(
                        Test__c = ab.Id,
                        Name = x.Name,
                        Template_Step__c = x.Template_Step__c,
                        Test_Execution_Step_Number__c = x.Test_Execution_Step_Number__c,
                        TRAK_Action__c = x.TRAK_Action__c,
                        TRAK_Expected_Results__c = x.TRAK_Expected_Results__c,
                        TRAK_Tips__c = x.TRAK_Tips__c
                    ));
                }
                // system.debug(zy);
            }
        }
        //  system.debug(toMap2);
        try {
            insert toMap2;
        } catch (Exception excep) {
            TF_ErrorLogUtility.createErrorLog(excep, new TF_ErrorLogWrapper('TRAK_createTestsForTester', 'afterInsert', 'TRAK_createTestsForTester - afterInsert', '1'));
        }
    }
}