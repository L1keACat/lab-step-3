@isTest
private class BirthdayBatchTest {
    @testSetup
    static void setup() {
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(FirstName='Test ', LastName = '1',
                Birthdate = Date.today(), Email='likeacat.jobs@gmail.com'));
        Date birthday = Date.today();
        birthday = birthday.addDays(1);
        contacts.add(new Contact(FirstName='Test ', LastName = '2',
                Birthdate = birthday, Email='likeacat.jobs@gmail.com'));
        insert contacts;
    }
    @isTest static void test() {
        Test.startTest();
        BirthdayBatch uca = new BirthdayBatch();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
    }
}