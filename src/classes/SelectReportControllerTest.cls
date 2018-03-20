/**
 * Test class for SelectReportController
*/

@isTest
public with sharing class SelectReportControllerTest {
	static User testUser = TestFactory.getTestingUser();
	
	@isTest
	static void test_main(){
		System.runAs(testUser){	
			PageReference selectReportPage = Page.SelectReport;
			Test.setCurrentPage(selectReportPage);
			
			Test.startTest();			
			SelectReportController controller = new SelectReportController();
			List<SelectOption> options = controller.getCustomReports();
			System.assert(options.size() > 0);
			
			controller.SelectedReport = options[0].getValue();
			PageReference pr1 = controller.gotoReport();
			System.assertNotEquals(null,pr1);
			
			PageReference pr2 = controller.cancel();
			System.assertNotEquals(null,pr2);
			Test.stopTest();
		}
	}	
}