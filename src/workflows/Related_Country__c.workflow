<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UnqStudyBenifitCountry</fullName>
        <field>Unique_StudyBenifitCountry_TF__c</field>
        <formula>CASESAFEID(Country__c) &amp;&apos;+&apos;&amp; CASESAFEID(Project__c)</formula>
        <name>UnqStudyBenifitCountry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UnqStudyBenifitCountry</fullName>
        <actions>
            <name>UnqStudyBenifitCountry</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF( Project__c &lt;&gt; NULL,true,false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
