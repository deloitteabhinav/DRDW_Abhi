<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Risk_Issue_Set_Closed_Date</fullName>
        <description>Set Closed Date to today when Status is set to &quot;Approved&quot;</description>
        <field>Closed_Date__c</field>
        <formula>Today()</formula>
        <name>Risk/Issue Set Closed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TRAK_Risk%2FIssue Set Closed Date</fullName>
        <actions>
            <name>Risk_Issue_Set_Closed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TRAK_Risks_Issues__c.Status__c</field>
            <operation>equals</operation>
            <value>Resolved,Duplicate,No Issue</value>
        </criteriaItems>
        <criteriaItems>
            <field>TRAK_Risks_Issues__c.Closed_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Set Closed Date to be equal to the current date, when the State is set to &quot;Closed&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
