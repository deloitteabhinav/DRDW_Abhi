/* Class Name  : Test_TRAK_StringUtilsLineReader
 * Description : TRAK_StringUtilsLineReader
 * CreatedBY   : Deloitte
 * Created Date: 11-08-2016
*/
@isTest(seealldata=false)
private class Test_TRAK_StringUtilsLineReader {
    
     /* 
* @Method Name                    :  testmeth_TRAK_Sprint_TriggerHelper
* @Description                    :  Test Method 
* @Return Type                    :  void
* @Param                          :  

*/
   static testMethod void testmeth_Test_TRAK_StringUtilsLineReader(){
   
   String str = 'aba\nabc\naaaa';
   TRAK_StringUtilsLineReader oTSULR = new TRAK_StringUtilsLineReader(str);
   oTSULR.hasNext();
   oTSULR.next();
   oTSULR.Iterator();
   
   }

}