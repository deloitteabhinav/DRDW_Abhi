/**
 * Controller class for page SelectReport
 * Get available RWE custom reports
*/
public with sharing class SelectReportController {
	public String SelectedReport {get;set;}
	
	public SelectReportController(){
		//
	} 
	
	/**
	 * Get avaliable RWE custom reports
	 * @return RWE custom report list
	*/
	public List<SelectOption> getCustomReports(){
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('','-- Select Report --'));
		options.add(new SelectOption('CRLibraryMetrics','RWE Library Metrics'));
		return options;
	}
	
	/**
	 * jump to custom report page
	 * @return page reference instance of custom report page
	*/
	public PageReference gotoReport(){
		PageReference pr = null;
		if(SelectedReport != null){
			pr = new PageReference('/apex/' + SelectedReport);
		}
		return pr;
	}
	
	/**
	 * back to landing page
	 * @return page reference instance of landing page
	*/
	public PageReference cancel(){
		return new PageReference('/apex/AboutRWE');
	} 
}