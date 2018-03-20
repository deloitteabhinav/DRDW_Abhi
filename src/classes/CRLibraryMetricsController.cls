/**
 * Controller class for page CRLibraryMetrics
 * Filter content and files by library id
*/
public with sharing class CRLibraryMetricsController {
	public CRLibraryMetricsController(){
		//		
	} 
	
	/**
	 * Get available library list
	 * @return library select option list
	*/
	public List<SelectOption> getLibraries(){
		List<SelectOption> options = new List<SelectOption>();
		
		options.add(new SelectOption('','-- Select Library --'));
		for(ContentWorkspace cw : [select Id,Name from ContentWorkspace]){
			options.add(new SelectOption(cw.Id,cw.Name));	
		}
		
		return options;
	}
	
	/**
	 * filter content files by library
	 * @param libraryId library to filter
	 * @return file id list filtered by specified library
	*/	
	@RemoteAction
	public static List<String> getContentDocIds(String libraryId){
		List<String> Ids = new List<String>();
		for(ContentDocument d : [select Id from ContentDocument where ParentId = :libraryId]){
			Ids.add(d.Id);
		}
		
		return Ids;
	}
}