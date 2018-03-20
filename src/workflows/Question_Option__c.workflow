<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Question_TF</fullName>
        <field>Question_TF__c</field>
        <formula>Question__r.Question_Text_TF__c</formula>
        <name>Update_Question_TF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update_QuestiononOption</fullName>
        <actions>
            <name>Update_Question_TF</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Question_Option__c.Question_Text__c</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <description>This workflow updates the Question text from question text field on the Questions object</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
