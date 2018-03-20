<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>TPTO_Auto_Approved</fullName>
        <description>Auto Approved</description>
        <protected>false</protected>
        <recipients>
            <field>BA__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TPTO_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>TPTO_Reminder_Email_to_BA_to_approve_the_leave</fullName>
        <description>Reminder Email to BA to approve the leave</description>
        <protected>false</protected>
        <recipients>
            <field>BA__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TPTO_Reminder_Email</template>
    </alerts>
    <alerts>
        <fullName>TPTO_Request</fullName>
        <description>PTO Request</description>
        <protected>false</protected>
        <recipients>
            <field>Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TPTO_Requested</template>
    </alerts>
    <alerts>
        <fullName>TPTO_Request_Approved</fullName>
        <ccEmails>ashivaraj@drdpv1.com;</ccEmails>
        <description>PTO Request Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>BA__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TPTO_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>TPTO_Request_Rejected</fullName>
        <description>PTO Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>BA__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TPTO_Request_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>TPTO_Auto_Approve</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Auto Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TPTO_Status_updated_to_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Status updated to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TPTO_Status_updated_to_Needs_discussion</fullName>
        <field>Status__c</field>
        <literalValue>Needs discussion</literalValue>
        <name>Status updated to Needs discussion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TPTO_Status_updated_to_Submitted</fullName>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Status updated to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TPTO Auto Approval</fullName>
        <actions>
            <name>TPTO_Auto_Approved</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>TPTO_Auto_Approve</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To auto approve the pto request if the start date is less than or equal to 3 days.</description>
        <formula>(Start_Date__c &lt;= Today() + 3) &amp;&amp; ISPICKVAL( Status__c , &apos;Submitted&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TPTO_Reminder to Approve PTO</fullName>
        <active>true</active>
        <formula>OR((Today() + 3 ==  Start_Date__c - 11), (Today() + 3 ==  Start_Date__c - 8), (Today() + 3 ==  Start_Date__c - 5))   &amp;&amp; ( ISPICKVAL( Status__c , &apos;Submitted&apos;) &amp;&amp;  RecordType.DeveloperName == &apos;Planned&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TPTO_Reminder_Email_to_BA_to_approve_the_leave</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>TPTO_PTO_Request__c.Start_Date__c</offsetFromField>
            <timeLength>-6</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>TPTO_Reminder_Email_to_BA_to_approve_the_leave</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>TPTO_PTO_Request__c.Start_Date__c</offsetFromField>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>TPTO_Reminder_Email_to_BA_to_approve_the_leave</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>TPTO_PTO_Request__c.Start_Date__c</offsetFromField>
            <timeLength>12</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>TPTO_Plan_PTO_request_BA1</fullName>
        <assignedTo>karkannan@drdpv1.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Update Name and comments before closing Task</description>
        <dueDateOffset>-5</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>TPTO_PTO_Request__c.Start_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Plan PTO request for Practioner</subject>
    </tasks>
    <tasks>
        <fullName>TPTO_Plan_PTO_request_BA2</fullName>
        <assignedTo>ashivaraj@drdpv1.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Update Name and comments before closing Task</description>
        <dueDateOffset>-5</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>TPTO_PTO_Request__c.Start_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Plan PTO request for Practioner</subject>
    </tasks>
</Workflow>
