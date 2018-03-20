/*************************************************************************************
Apex Class  : Nugget_AutoCompleteController
Description : Controller class to VF Component:Nugget_AutoCompleteComponent
              This class is used to search for User based on Name.  
**************************************************************************************/
global with sharing class Nugget_AutoCompleteController {



    /*********************************************************
    Method Name: searchObject
    Description: Remote action method called from VF component
             which do search on User based on parameters
    Input Parameters: strings
    Return type: List of sObject
    **********************************************************/
    
    @RemoteAction
    global static list < sObject > searchObject(string objectName, string query, String numberOfResults, String wildCardOption) {

        // check if the object is a valid object to search
        Map < String, Schema.SObjectType > gd = Schema.getGlobalDescribe();
        Schema.SObjectType sot = gd.get(objectName);

        // create the where-clause
        String WhereClause = ' like \'';
        //add wild casd option to where clause
        if (wildCardOption == 'true') {
            Whereclause += '%';
        }

        //create final where clause
        Whereclause += String.escapeSingleQuotes(query) + '%\'';

        //build the dynamic soql query
        String soqlQuery;
        soqlQuery = 'select id,Name from ' + objectName + ' where Name' + Whereclause + 'order by Name limit ' + numberOfResults;

        List < sObject > Results = new List < sObject > ();

        try {
            //Query for results
            Results = Database.query(soqlQuery);
        } catch (QueryException e) {
            return null;
        }

        //return the query results
        return Results;
    }
    

}