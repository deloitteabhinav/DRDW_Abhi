<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Record_Type_to_Scoping_Approval</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Scoping_Approval</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type to Scoping Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Release_Tracker_Approval_to_Deploy</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Deployment Approval</literalValue>
        <name>Release Tracker: Approval to Deploy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Release_Tracker_Approved_to_Deploy</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Deployment Approved</literalValue>
        <name>Release Tracker: Approved to Deploy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Release_Tracker_Deployment_Recall</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Ready for Deployment</literalValue>
        <name>Release Tracker: Deployment Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Release_Tracker_Deployment_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Deployment Rejected</literalValue>
        <name>Release Tracker: Deployment Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Release_Tracker_Scoping_Submitted</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>Release Tracker: Scoping Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_Update_Status_on_Approval</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Development Approved</literalValue>
        <name>TRAK Update Status on Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_Update_Status_on_Rejection</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>TRAK Update Status on Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_Update_Status_on_Submission</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>TRAK Update Status on Submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Deployment</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Deployment_Approval</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Deployment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Development</fullName>
        <field>RecordTypeId</field>
        <lookupValue>In_Development</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Development</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Draft</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Creation_of_Release</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Release_Name_to_Rejected</fullName>
        <description>Update Release Name to Rejected</description>
        <field>Name</field>
        <formula>&quot;Rejected&quot;</formula>
        <name>Update Release Name to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Record Type to Development</fullName>
        <actions>
            <name>Update_Record_Type_to_Development</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TRAK_Release__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>In Development</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
