<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Record_Type_as_RWE_Data_Asset</fullName>
        <field>RecordTypeId</field>
        <lookupValue>RWE_Data_Asset</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set_Record_Type_as_RWE_Data_Asset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateLookUpNames_DataSteward</fullName>
        <field>Data_Steward_TF__c</field>
        <formula>IF(Data_Steward__c &lt;&gt; NULL, Data_Steward__r.LastName , NULL)</formula>
        <name>UpdateLookUpNames_DataSteward</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateNames_OnLillyInternalContact</fullName>
        <field>Lilly_Internal_Contact_TF__c</field>
        <formula>IF(Lilly_Internal_Contact__c &lt;&gt; NULL ,      Lilly_Internal_Contact__r.FirstName &amp;&apos; &apos;&amp;Lilly_Internal_Contact__r.LastName ,NULL)</formula>
        <name>UpdateNames_OnLillyInternalContact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>33_Data Asset Save</fullName>
        <actions>
            <name>Set_Record_Type_as_RWE_Data_Asset</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Data_Asset__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates the Record Type of all Data Asset records created to &quot;Data Asset&quot; regardless if created using the Long Form or the Short Form.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateFieldsWithLookUpNames_OnInventory</fullName>
        <actions>
            <name>UpdateLookUpNames_DataSteward</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateNames_OnLillyInternalContact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule will update Text fields with Look Up Names so that Data assets are globally searchable.</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
