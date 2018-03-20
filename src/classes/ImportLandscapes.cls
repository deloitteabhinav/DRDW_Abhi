public with sharing class ImportLandscapes
{
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    String[] filelines = new String[]{};
    List<Information_Landscape__c> Landscapeupload;
    Public List < List < String >> lData;
    
    public Pagereference ReadFile()
    {
        try{
                lData = new List < List < String > > ();
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType leadSchema = schemaMap.get('Information_Landscape__c');
                Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                Map<String,String> mLabelApi = new Map<String,String>();
                for (String fieldName: fieldMap.keySet()) {
                    mLabelApi.put(fieldMap.get(fieldName).getDescribe().getLabel(),fieldName);            
                }
                //Convert the uploaded file which is in BLOB format into a string
                nameFile =blobToString( contentFile,'ISO-8859-1');
                
                //Now sepatate every row of the excel file
                filelines = nameFile.split('\n');
                
                //Iterate through every line and create a record for each row
                Landscapeupload = new List<Information_Landscape__c>();
                for (Integer i=0;i<filelines.size();i++)
                {
                    String[] inputvalues = new String[]{};
                    inputvalues = filelines[i].split(',');
                    lData.add(inputvalues);
                }
                

                List < String > lHeaders = new List < String > ();
        
                For(List < String > row: lData) {
                    for (string col: row) {
                        lHeaders.add(col);
                    }
                    break;
                }
        
        
                integer rowNumber = 0;
                for (list < string > row: lData) {
                    if (rowNumber == 0) {
                        rowNumber++;
                        continue;
                    } else {
                        Information_Landscape__c oLandscape = new Information_Landscape__c();
                        integer colIndex = 0;
                        for (string col: row) {
                            string headerName = lheaders[colIndex].trim();
                            For(String s : mLabelApi.keySet()){
                                If(headerName == s && col != null && col != ''){
                                    oLandscape.put(mLabelApi.get(s),col.trim());
                                }
                            }
                            colIndex++;
                        }
                        Landscapeupload.add(oLandscape);
                        rowNumber = rowNumber++;
                    }
                }

         }
         catch(Exception e){
                 ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured reading the CSV file'+e.getMessage());
                ApexPages.addMessage(errormsg);
         }       
        //Finally, insert the collected records
        try{
            insert Landscapeupload;
        }
        catch (Exception e)
        {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured inserting the records'+e.getMessage());
            ApexPages.addMessage(errormsg);
        }    
        return null;
    }
   
   /**** This function sends back to the visualforce page the list of records that were inserted ****/ 
    public List<Information_Landscape__c> getuploadedLandscapes()
    {
        if (Landscapeupload!= NULL)
            if (Landscapeupload.size() > 0)
                return Landscapeupload;
            else
                return null;                    
        else
            return null;
    }  
        /**
         This function convers the input CSV file in BLOB format into a string
        @param input    Blob data representing correct string in @inCharset encoding
        @param inCharset    encoding of the Blob data (for example 'ISO 8859-1')
     */
    public static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }         
}