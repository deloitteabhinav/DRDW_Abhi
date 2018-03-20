<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Checklist_Version_DuplicateCheck</fullName>
        <field>Sequence_Unique_Check__c</field>
        <formula>IF( Active__c , &quot;True&quot; + TEXT(Study_Type__c), &quot;&quot;)</formula>
        <name>PANG Checklist Version DuplicateCheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
