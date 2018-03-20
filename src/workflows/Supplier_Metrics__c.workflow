<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateZero_NetSpend_Current_Year</fullName>
        <description>Updates Net Spend LastYearTF when Year = Current Year</description>
        <field>Net_Spend_LastYear_TF__c</field>
        <formula>0</formula>
        <name>UpdateZero_NetSpend_Current_Year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateZero_NetSpend_Last_Year</fullName>
        <description>Updates Net Spend CurrentYear TF when Year = LastYear</description>
        <field>Net_Spend_CurrentYear_TF__c</field>
        <formula>0</formula>
        <name>UpdateZero_NetSpend_Last_Year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FiscalYear_TF</fullName>
        <description>Updates Fiscal_Year_TF__c based on value in Fiscal_Year__c</description>
        <field>Fiscal_Year_TF__c</field>
        <formula>DATE(VALUE(Fiscal_Year__c),11,11)</formula>
        <name>Update_FiscalYear_TF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_NetSpend_Current_Year</fullName>
        <description>Updates Net Spend CurrentYear TF when Year = Current Year</description>
        <field>Net_Spend_CurrentYear_TF__c</field>
        <formula>Net_Spend_in_USD__c</formula>
        <name>Update_NetSpend_Current_Year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_NetSpend_Last_Year</fullName>
        <description>Updates Net Spend LastYearTF when Year = LastYear</description>
        <field>Net_Spend_LastYear_TF__c</field>
        <formula>Net_Spend_in_USD__c</formula>
        <name>Update_NetSpend_Last_Year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FiscalYear_Update</fullName>
        <actions>
            <name>Update_FiscalYear_TF</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Supplier_Metrics__c.Fiscal_Year__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates the Date in Fiscal_Year_TF__c field based on Fiscal_Year__c</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Net_Spend_CurrentYear_Update</fullName>
        <actions>
            <name>UpdateZero_NetSpend_Current_Year</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_NetSpend_Current_Year</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(VALUE(Fiscal_Year__c) == YEAR(TODAY()), NOT(ISNULL(Net_Spend_in_USD__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Net_Spend_LastYear_Update</fullName>
        <actions>
            <name>UpdateZero_NetSpend_Last_Year</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_NetSpend_Last_Year</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(VALUE(Fiscal_Year__c) == YEAR(TODAY())-1,   NOT(ISNULL(Net_Spend_in_USD__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
