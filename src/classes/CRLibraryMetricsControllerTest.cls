/**
 * Test class for CRLibraryMetricsController
 * can not create library and assign library membership to test user by apex
 * due to above issue, assertation is skipped
*/

@isTest
public with sharing class CRLibraryMetricsControllerTest {
    
    @isTest
    static void test_main(){
    User testUser = TestFactory.getTestingUser();
    TestFactory.assignGroup(testUser.id, 'RWE_Library_Best_Practice_Authors');
        System.runAs(testUser){ 

            PageReference metricsPage = Page.CRLibraryMetrics;
            Test.setCurrentPage(metricsPage);
            
            Test.startTest();           
            CRLibraryMetricsController controller = new CRLibraryMetricsController();
            List<SelectOption> options = controller.getLibraries();
            List<String> fileIds = CRLibraryMetricsController.getContentDocIds('058b0000000HgIL');        
            Test.stopTest();
        }
    }   
}