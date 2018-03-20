/**
 * Utility class to iterate over lines
 **/
public class TRAK_StringUtilsLineReader implements Iterator<String>, Iterable<String> {       
    
    private String LINE_SEPARATOR = '\n';
    private String textData;
    
    /**
     * Constructor
     */
    public TRAK_StringUtilsLineReader(String textData) {       
		this.textData = textData;
    }
	
	/**
	 * return <b>true</b> if there are more lines, <b>false</b> otherwise
	 */
	public Boolean hasNext() {
		return textData.length() > 0 ? true : false;
	}
	
	/**
	 * return the next line
	 */
    public String next() {
		String row = null;
		Integer endPos = textData.indexOf(LINE_SEPARATOR);
		
		if(endPos == -1) {
			row = textData;
			textData = '';
		}
		else {
			row = textData.subString(0, endPos);
			textData = textData.subString(endPos + LINE_SEPARATOR.length(), textData.length());             
		}
		
		return row;
	}
	
	
    public Iterator<String> Iterator() {
        return this;   
    }           
}