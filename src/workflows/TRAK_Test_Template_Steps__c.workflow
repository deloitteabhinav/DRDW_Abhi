<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>TRAK_Update_Parent_Approval_Date</fullName>
        <description>This will blank out the approval date</description>
        <field>Approval_Date__c</field>
        <name>Update Parent Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <targetObject>Test_Script__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_Update_Parent_Approval_Status</fullName>
        <description>This will set the Approval status to Open</description>
        <field>Approval_Status__c</field>
        <literalValue>Open</literalValue>
        <name>Update Parent Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Test_Script__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>TRAK_Re-open Test Script</fullName>
        <actions>
            <name>TRAK_Update_Parent_Approval_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TRAK_Update_Parent_Approval_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>TRAK_Test_Templates__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>TRAK_Test_Templates__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>This rule will reopen the test script and blank out the Approval date if any test steps are changed for an approved/rejected test script</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
