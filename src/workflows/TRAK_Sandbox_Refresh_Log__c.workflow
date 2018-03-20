<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>TRAK_Sandbox_Refresh_Approved</fullName>
        <description>TRAK Sandbox Refresh Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>TRAK_Tracker_Admin</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_Sandbox_Refresh_Approved</template>
    </alerts>
    <alerts>
        <fullName>TRAK_Sandbox_Refresh_Submission</fullName>
        <description>TRAK Sandbox Refresh Submission</description>
        <protected>false</protected>
        <recipients>
            <field>Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_Sandbox_Refresh_Approval</template>
    </alerts>
    <fieldUpdates>
        <fullName>Sandbox_Refresh_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Sandbox Refresh: Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sandbox_Refresh_Open</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Open</literalValue>
        <name>Sandbox Refresh: Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sandbox_Refresh_Pending</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Sandbox Refresh: Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sandbox_Refresh_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Sandbox Refresh: Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
