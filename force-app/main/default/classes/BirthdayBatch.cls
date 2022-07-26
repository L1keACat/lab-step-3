public class BirthdayBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, Name, Birthdate FROM Contact'
        );
    }
    public void execute(Database.BatchableContext bc, List<Contact> scope){
        List<Contact> contacts = new List<Contact>();
        for (Contact contact : scope) {
            if (contact.Birthdate == Date.today()) {
                contacts.add(contact);
            }
        }
        SendBirthdayEmail.sendEmail(contacts);
    }
    public void finish(Database.BatchableContext bc){
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        System.debug('Batch finished. Errors: ' + job.NumberOfErrors + '. Total processed: ' + job.JobItemsProcessed + '. Total items: ' + job.TotalJobItems);
    }
}
