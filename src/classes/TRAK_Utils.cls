public with sharing class TRAK_Utils {

    // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    public static string getCreatableFieldsSOQL(String objectName, String whereClause) {

        String selects = '';

        //   if (whereClause == null || whereClause == ''){ return null; }

        // Get a map of field name and field token
        Map < String, Schema.SObjectField > fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list < string > selectFields = new list < string > ();

        if (fMap != null) {
            Schema.DescribeFieldResult fd;
            for (Schema.SObjectField ft: fMap.values()) { // loop through all field tokens (ft)
                fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()) { // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }

        if (!selectFields.isEmpty()) {
            for (string s: selectFields) {
                selects += s + ',';
            }
            if (selects.endsWith(',')) {
                selects = selects.substring(0, selects.lastIndexOf(','));
            }

        }
        //    system.debug(selects); 
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;

    }

    public static boolean checkEditAccess(Id userIdInst, Id recordIdInst) {
        List < UserRecordAccess > lstUserRecordAccess = [Select hasEditAccess, recordId from UserRecordAccess where recordId =: recordIdInst
            AND userId =: userIdInst
        ];
        if (lstUserRecordAccess != null && lstUserRecordAccess.size() > 0) {
            boolean returnVal = true;
            for (UserRecordAccess usrRecAccess: lstUserRecordAccess) {
                if (usrRecAccess.hasEditAccess == false) {
                    returnVal = false;
                }
            }
            return returnVal;
        }
        return false;
    }
}