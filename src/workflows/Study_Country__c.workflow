<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UniqueStudyCountry</fullName>
        <field>Unique_StudyConductingCountry_TF__c</field>
        <formula>CASESAFEID(Country__c) &amp;&apos;+&apos;&amp; CASESAFEID(Study__c)</formula>
        <name>UniqueStudyCountry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UniqueStudyCountry</fullName>
        <actions>
            <name>UniqueStudyCountry</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
