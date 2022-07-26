@isTest
public with sharing class SendBirthdayEmailTest {
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
    @isTest static void testSendMessagePos() {
        Date todaysDate = Date.today();
        Contact c = [SELECT Id, Name, Birthdate, Email FROM Contact WHERE Birthdate =: todaysDate LIMIT 1];
        List<String> result = new List<String>();
        //System.runAs([select Id from User where Id = :Userinfo.getUserId() limit 1][0]) {
            Test.startTest();
            result = SendBirthdayEmail.sendEmail(new List<Contact> {c});
            Test.stopTest();
        //}
        System.assertEquals(1, result.size());
        System.assertEquals('Emails were sent successfully.', result[0]);
    }
}
