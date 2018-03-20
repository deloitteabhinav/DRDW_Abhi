<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_sent_to_Business_quality_for_User_Story_Approval_if_Criticality_is_h</fullName>
        <description>Email Alert sent to Business quality for User Story Approval if Criticality is high</description>
        <protected>false</protected>
        <recipients>
            <field>Compliance_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_User_Story_Template_Business_Quality</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_sent_to_Computer_Systems_Quality_for_User_Story_Approval_if_Critical</fullName>
        <description>Email Alert sent to Computer Systems Quality for User Story Approval if Criticality is high</description>
        <protected>false</protected>
        <recipients>
            <field>Computer_Systems_Quality__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_User_Story_Template_Computer_Systems_Quality</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_sent_to_System</fullName>
        <description>Email Alert sent to System Owner for User Story Approval</description>
        <protected>false</protected>
        <recipients>
            <field>System_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_User_Story_Template_System_Owner</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_sent_to_System_Custodian_for_User_Story_Approval</fullName>
        <description>Email Alert sent to System Custodian for User Story Approval if Criticality is high</description>
        <protected>false</protected>
        <recipients>
            <field>System_Custodian__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_User_Story_Template_System_Custodian</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_sent_to_System_Owner_for_User_Story_Approval</fullName>
        <description>Email Alert sent to System Owner for User Story Approval if Criticality is high</description>
        <protected>false</protected>
        <recipients>
            <field>System_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_User_Story_Template_System_Owner</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_to_the_Submitter_and_BA_when_the_User_Story_has_been_Rejected</fullName>
        <description>Email Notification to the Submitter and BA when the User Story has been Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>Supporting_BA__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_User_Story_Rejection_Template_to_BA</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_to_the_Submitter_when_the_User_Story_has_been_Rejected</fullName>
        <description>Email Notification to the Submitter when the User Story has been Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_User_Story_Rejection_Template_to_Submitter</template>
    </alerts>
    <alerts>
        <fullName>System_Custodian_Email_Alert_for_Approval_of_User_Story</fullName>
        <description>Email Alert sent to System Custodian for User Story Approval</description>
        <protected>false</protected>
        <recipients>
            <field>System_Custodian__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_User_Story_Template_System_Custodian</template>
    </alerts>
    <alerts>
        <fullName>TRAK_Email_Tester</fullName>
        <description>Email Tester</description>
        <protected>false</protected>
        <recipients>
            <field>Sprint_Tester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_User_Story_Ready_Test_HTM</template>
    </alerts>
    <alerts>
        <fullName>TRAK_USERSTORY_Send_Congratulations</fullName>
        <description>TRAK_USERSTORY_Send_Congratulations</description>
        <protected>false</protected>
        <recipients>
            <field>Compliance_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Computer_Systems_Quality__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Developer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Sprint_Tester__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Supporting_BA__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_User_Story_Passed_HTM</template>
    </alerts>
    <alerts>
        <fullName>TRAK_User_Story_Passed_Send_Email</fullName>
        <ccEmails>prgrover@deloitte.co.uk; smatharu@deloitte.co.uk; stmills@deloitte.co.uk</ccEmails>
        <description>User Story Passed - Send Email</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>TRAK_Templates/TRAK_User_Story_Passed_HTM</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Status_Field_Update</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Rejected_Field_Update</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Status Rejected Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Business_Quality_Approval_Date</fullName>
        <field>TRAK_Business_Quality_Approval_Date__c</field>
        <name>Business Quality Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Business_Quality_Approved_to_False</fullName>
        <field>TRAK_Business_Quality_Approved__c</field>
        <literalValue>0</literalValue>
        <name>Business Quality Approved to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Cancellation_Reason</fullName>
        <field>Cancellation_Reason__c</field>
        <name>Change Cancellation Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Close_Date</fullName>
        <field>Close_Date__c</field>
        <name>Change Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_the_Approval_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Open</literalValue>
        <name>Change the Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Computer_Systems_Quality_Approval_Date</fullName>
        <field>TRAK_Computer_System_Qty_Approval_Date__c</field>
        <name>Computer Systems Quality Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Computer_Systems_Quality_Approved</fullName>
        <field>TRAK_Computer_Systems_Quality_Approved__c</field>
        <literalValue>0</literalValue>
        <name>Computer Systems Quality Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>System_Custodian_Approved_Date</fullName>
        <field>TRAK_System_Custodian_Approval_Date__c</field>
        <name>System Custodian Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>System_Custodian_Approved_To_False</fullName>
        <description>Set System Custodian Approved to False</description>
        <field>TRAK_System_Custodian_Approved__c</field>
        <literalValue>0</literalValue>
        <name>System Custodian Approved To False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>System_Owner_Approved_Date</fullName>
        <field>TRAK_System_Owner_Approval_Date__c</field>
        <name>System Owner Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>System_Owner_Approved_To_False</fullName>
        <field>TRAK_System_Owner_Approved__c</field>
        <literalValue>0</literalValue>
        <name>System Owner Approved To False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_Set_GxP_to_No</fullName>
        <description>Sets GxP Field to NO</description>
        <field>GXP__c</field>
        <literalValue>No</literalValue>
        <name>TRAK Set GxP to No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_Set_User_Story_Quality_Critical_No</fullName>
        <description>Sets the User Story &gt; Quality Critical Field to &quot;No&quot;</description>
        <field>Critical__c</field>
        <literalValue>No</literalValue>
        <name>TRAK Set User Story Quality Critical No</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_User_Story_Passed_Set_Close_Date</fullName>
        <description>Close Date = Today</description>
        <field>Close_Date__c</field>
        <formula>today()</formula>
        <name>User Story Passed - Set Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_User_Story_Release_Comp_Unchec</fullName>
        <field>Release_Completeness__c</field>
        <literalValue>0</literalValue>
        <name>User Story Release Completeness - Unchec</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TRAK_User_Story_Release_Completeness</fullName>
        <field>Release_Completeness__c</field>
        <literalValue>1</literalValue>
        <name>User Story Release Completeness</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Close_Date</fullName>
        <field>Close_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_US_Record_Type_to_Hotfix</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Hotfix_Release</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update US Record Type to Hotfix</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_US_Record_Type_to_Weekly</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Weekly_Release</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update US Record Type to Weekly</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_US_Release_Type_to_Monthly</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Major_Release</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update US Release Type to Monthly</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TRAK Change the Approval Status to Open</fullName>
        <actions>
            <name>Business_Quality_Approval_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Business_Quality_Approved_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Change_the_Approval_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Computer_Systems_Quality_Approval_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Computer_Systems_Quality_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>System_Custodian_Approved_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>System_Custodian_Approved_To_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>System_Owner_Approved_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>System_Owner_Approved_To_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Change the Approval Status to Open when user tries to edit the I Want to</description>
        <formula>ISCHANGED( I_Want_To__c ) || ISCHANGED( As_A_text__c )  || ISCHANGED( So_that__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TRAK Populate Closed Date</fullName>
        <actions>
            <name>Update_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Development_Stage__c), ISPICKVAL(Development_Stage__c,&apos;Cancelled&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TRAK User Story Send Approval Notification</fullName>
        <actions>
            <name>Email_Alert_sent_to_System</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>System_Custodian_Email_Alert_for_Approval_of_User_Story</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>TRAK_User_Story__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Pending Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>TRAK_User_Story__c.GXP__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>TRAK_User_Story__c.Critical__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <description>IF GxP = No AND Critical = No, then approval request email notification to be sent to System Owner and System Custodian.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TRAK User Story Send Approval Notification to All</fullName>
        <actions>
            <name>Email_Alert_sent_to_Business_quality_for_User_Story_Approval_if_Criticality_is_h</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Alert_sent_to_Computer_Systems_Quality_for_User_Story_Approval_if_Critical</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Alert_sent_to_System_Custodian_for_User_Story_Approval</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Alert_sent_to_System_Owner_for_User_Story_Approval</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>TRAK_User_Story__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Pending Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>TRAK_User_Story__c.GXP__c</field>
            <operation>notEqual</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>TRAK_User_Story__c.Critical__c</field>
            <operation>notEqual</operation>
            <value>No</value>
        </criteriaItems>
        <description>The approval request to be sent to System Owner, System Custodian, Business Quality and Computer Systems Quality.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TRAK User Story Send Rejection Notification</fullName>
        <actions>
            <name>Email_Notification_to_the_Submitter_and_BA_when_the_User_Story_has_been_Rejected</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Notification_to_the_Submitter_when_the_User_Story_has_been_Rejected</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>TRAK_User_Story__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>Rule to send the rejection notification to BA and Submitter when the User Story has been rejected</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TRAK_User Story Passed</fullName>
        <actions>
            <name>TRAK_User_Story_Passed_Set_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a User Story is set to status &apos;Done&apos;, send an email and update the close date field</description>
        <formula>ISCHANGED( Development_Stage__c ) &amp;&amp; text(Development_Stage__c)= $Label.TRAK_User_Story_Burn_Status</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TRAK_User Story Release Completeness</fullName>
        <actions>
            <name>TRAK_User_Story_Release_Completeness</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>TRAK_User_Story__c.Validation_steps__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>TRAK_User_Story__c.Release_Steps_Manual__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Verify the release completeness</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TRAK_User Story Release Completeness - Uncheck</fullName>
        <actions>
            <name>TRAK_User_Story_Release_Comp_Unchec</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>TRAK_User_Story__c.Validation_steps__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>TRAK_User_Story__c.Release_Steps_Manual__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Verify the release completeness</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TRAK_User_Story_Ready_For_Testing</fullName>
        <actions>
            <name>TRAK_Email_Tester</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>When a User Story is set to status &apos;Ready for Test&apos; send an email to the assigned tester</description>
        <formula>ISCHANGED( Development_Stage__c ) &amp;&amp; text(Development_Stage__c)= &quot;Ready For Test&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>US_Status</fullName>
        <actions>
            <name>Change_Cancellation_Reason</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Change_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>TRAK_User_Story__c.Development_Stage__c</field>
            <operation>notEqual</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <description>Cancellation Reason and Closed Date should disappear when the Story status is changed from Cancelled to any other status.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update US Record Type to Hotfix</fullName>
        <actions>
            <name>Update_US_Record_Type_to_Hotfix</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update US Record Type to Hotfix</description>
        <formula>AND( ISPICKVAL(Cirrus_Release__r.Release_Type__c , &apos;Hotfix&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update US Record Type to Monthly</fullName>
        <actions>
            <name>Update_US_Release_Type_to_Monthly</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update US Record Type to Monthly</description>
        <formula>AND(ISPICKVAL(Cirrus_Release__r.Release_Type__c , &apos;Monthly&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update US Record Type to Weekly</fullName>
        <actions>
            <name>Update_US_Record_Type_to_Weekly</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update US Record Type to Weekly</description>
        <formula>AND( ISPICKVAL(Cirrus_Release__r.Release_Type__c , &apos;Weekly&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
