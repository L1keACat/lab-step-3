@IsTest
private class CreatePaymentsRestServiceTest {
    @isTest static void createPaymentsTest() {

        Opportunity o = new Opportunity(Name='Test Oppt',
                                        StageName ='Prospecting',
                                        CloseDate = Date.newInstance(2022, 6, 30));
       	insert o;
        
        List<CreatePaymentsRestService.JSONPayload> jsonList = new List<CreatePaymentsRestService.JSONPayload>();
        jsonList.add(new CreatePaymentsRestService.JSONPayload('Test Oppt', 190.0, 'Test', 'Test'));
        jsonList.add(new CreatePaymentsRestService.JSONPayload('Test Oppt', 210.0, 'Test', 'Test'));

        ID[] thisPaymentIds = CreatePaymentsRestService.createPayments(jsonList);
        // Verify results
        System.assert(thisPaymentIds != null);
        List<Payment__c> payments = [SELECT Id, FirstName__c, Amount__c FROM Payment__c WHERE Id IN :thisPaymentIds];
        System.assert(payments.get(0) != null);
        System.assertEquals(payments.get(0).FirstName__c, 'Test');
    }
}
