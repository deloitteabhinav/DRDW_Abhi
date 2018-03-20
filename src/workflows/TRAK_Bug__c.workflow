<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>TRAK_Send_Defect_Dev_Notification</fullName>
        <description>TRAK_ Send Defect Dev Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Defect_Developer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_Send_DefectDev_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>TRAK_Defect_Release_Completeness</fullName>
        <field>Release_Completeness__c</field>
        <literalValue>1</literalValue>
        <name>Defect Release Completeness</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_Defect_Release_Completeness_Uncheck</fullName>
        <field>Release_Completeness__c</field>
        <literalValue>0</literalValue>
        <name>Defect Release Completeness - Uncheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_Populate_Log_Time</fullName>
        <field>Log_Time__c</field>
        <formula>CreatedDate</formula>
        <name>TRAK Populate Log Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_increment_reopened_count</fullName>
        <description>Increment the Reopened count field</description>
        <field>Reopened_Count__c</field>
        <formula>Reopened_Count__c + 1</formula>
        <name>TRAK increment reopened count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Defect_Record_Type_to_Hotfix</fullName>
        <description>Update Defect Record Type to Hotfix</description>
        <field>RecordTypeId</field>
        <lookupValue>Hotfix_Release</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Defect Record Type to Hotfix</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Defect_Record_Type_to_Monthly</fullName>
        <description>Update Defect Record Type to Monthly</description>
        <field>RecordTypeId</field>
        <lookupValue>Major_Release</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Defect Record Type to Monthly</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Defect_Record_Type_to_Weekly</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Weekly_Release</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Defect Record Type to Weekly</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TRAK Populate Log Time</fullName>
        <actions>
            <name>TRAK_Populate_Log_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TRAK_Bug__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TRAK increment reopened count</fullName>
        <actions>
            <name>TRAK_increment_reopened_count</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Increments the Reopened Count field each time a defect gets re-opened</description>
        <formula>AND(   OR(     ISPICKVAL(Status__c, &apos;Raised&apos;),     ISPICKVAL(Status__c, &apos;Ready for Development&apos;),     ISPICKVAL(Status__c, &apos;In Development&apos;)   ),   OR(     ISPICKVAL(PRIORVALUE(Status__c), &apos;Ready for Testing&apos;),     ISPICKVAL(PRIORVALUE(Status__c), &apos;Ready for Test Release&apos;),     ISPICKVAL(PRIORVALUE(Status__c), &apos;In Test&apos;),     CONTAINS(TEXT(PRIORVALUE(Status__c)), &apos;Closed&apos;),     ISPICKVAL(PRIORVALUE(Status__c), &apos;Ready for Release&apos;)   ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TRAK_Defect Release Completeness</fullName>
        <actions>
            <name>TRAK_Defect_Release_Completeness</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>TRAK_Bug__c.Release_Steps_Automated__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>TRAK_Bug__c.Release_Comment__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>TRAK_Bug__c.Fix_in_Environment__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>TRAK_Bug__c.Version__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>TRAK_Bug__c.Validation_Steps__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Verify the release completeness</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TRAK_Defect Release Completeness - Uncheck</fullName>
        <actions>
            <name>TRAK_Defect_Release_Completeness_Uncheck</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5</booleanFilter>
        <criteriaItems>
            <field>TRAK_Bug__c.Release_Steps_Automated__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>TRAK_Bug__c.Release_Comment__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>TRAK_Bug__c.Fix_in_Environment__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>TRAK_Bug__c.Version__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>TRAK_Bug__c.Validation_Steps__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Verify the release completeness</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TRAK_Send_DefectDev_Notification</fullName>
        <actions>
            <name>TRAK_Send_Defect_Dev_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( Defect_Developer__c &lt;&gt; NULL , OR(ISCHANGED(Defect_Developer__c), ISNEW()))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Defect Record Type to Hotfix</fullName>
        <actions>
            <name>Update_Defect_Record_Type_to_Hotfix</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Defect Record Type to Hotfix</description>
        <formula>AND(ISPICKVAL(Production_Release__r.Release_Type__c , &apos;Hotfix&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Defect Record Type to Monthly</fullName>
        <actions>
            <name>Update_Defect_Record_Type_to_Monthly</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Defect Record Type to Monthly</description>
        <formula>AND(ISPICKVAL(Production_Release__r.Release_Type__c , &apos;Monthly&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Defect Record Type to Weekly</fullName>
        <actions>
            <name>Update_Defect_Record_Type_to_Weekly</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Defect Record Type to Weekly</description>
        <formula>AND( ISPICKVAL(Production_Release__r.Release_Type__c , &apos;Weekly&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
