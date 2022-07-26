public with sharing class SendBirthdayEmail {
    
    private static EmailTemplate queryEmailTemplate(){
        EmailTemplate emailTemplate = [SELECT Id, Subject, Body, HtmlValue
            FROM EmailTemplate 
            WHERE Name = 'Client Birthday Email'];
        return emailTemplate;
    }
    
    public static List<String> sendEmail(List<Contact> contacts){
        
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();

        for (Contact contact : contacts) {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSenderDisplayName('Success Craft');
            message.setReplyTo('no-reply@success-craft.com');
            message.setTemplateId(queryEmailTemplate().Id);
            //message.setPlainTextBody(emailTemplate.Body);
            message.setTargetObjectId(contact.Id);
            message.setSaveAsActivity(false);
            messages.add(message);
        }

        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        List<String> resultMessages = new List<String>();
        for (Messaging.SendEmailResult result : results) {
            if (!result.success) {
                resultMessages.add('The email failed to send: ' +  result.errors[0].message);
            }
        }
        if (resultMessages.isEmpty()) {
            return new List<String>{'Emails were sent successfully.'};
        }
        return resultMessages;
    }
}
