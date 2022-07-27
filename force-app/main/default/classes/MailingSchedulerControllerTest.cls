@isTest
public with sharing class MailingSchedulerControllerTest {

    @isTest static void testRunBatchOncePos() {
        Test.startTest();
        String result = MailingSchedulerController.runBatchOnce('BirthdayBatch');
        Test.stopTest();
        System.assertEquals('Batch execution started.', result.substring(0, 24));
    }

    @isTest static void testRunBatchOnceNeg() {
        Test.startTest();
        String result = MailingSchedulerController.runBatchOnce('Generic');
        Test.stopTest();
        System.assertEquals('Batch execution did not start.', result);
    }

    @isTest static void testScheduleBatch() {
        Test.startTest();
        String result = MailingSchedulerController.scheduleBatch('0 0 0 * * ?', 'BirthdayBatch', 'BirthdayEmailScheduler');
        Test.stopTest();
        System.assertEquals('Job has been scheduled successfully.', result);
    }

    @isTest static void testAbortBatch() {
        MailingSchedulerController.scheduleBatch('0 0 0 * * ?', 'BirthdayBatch', 'BirthdayEmailScheduler');
        Test.startTest();
        String result = MailingSchedulerController.abortBatch('BirthdayEmailScheduler');
        Test.stopTest();
        System.assertEquals('Job has been aborted successfully.', result);
    }

    @isTest static void checkStatusPos() {
        MailingSchedulerController.scheduleBatch('0 0 0 * * ?', 'BirthdayBatch', 'BirthdayEmailScheduler');
        Test.startTest();
        Map<String, Object> result = MailingSchedulerController.checkSchedulerStatus('BirthdayEmailScheduler');
        Test.stopTest();
        System.assertEquals(true, result.get('status'));
    }

    @isTest static void checkStatusNeg() {
        Test.startTest();
        Map<String, Object> result = MailingSchedulerController.checkSchedulerStatus('BirthdayEmailScheduler');
        Test.stopTest();
        System.assertEquals(false, result.get('status'));
    }
}
