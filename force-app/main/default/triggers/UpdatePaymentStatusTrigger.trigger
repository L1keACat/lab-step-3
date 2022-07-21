trigger UpdatePaymentStatusTrigger on Payment__c (after insert) {

    Set<Id> opptIds = new Set<Id>();

    for (Payment__c payment : Trigger.New) {
        opptIds.add(payment.Opportunity__c);
    }

    List<Opportunity> oppts = new List<Opportunity>(
        [SELECT Id, Amount, (SELECT Id, Name, Amount__c FROM Payments__r), Payment_Status__c, OwnerId FROM Opportunity WHERE Id IN :opptIds]
    );

    Decimal amount = 0;

    for (Opportunity oppt : oppts) {
        for (Payment__c opptPayment : oppt.Payments__r) {
            amount += opptPayment.Amount__c;
        }
        if (amount < oppt.Amount) {
            oppt.Payment_Status__c = 'Partially Paid';
        }
        else {
            oppt.Payment_Status__c = 'Fully Paid';
            Task newTask = new Task();
            newTask.OwnerId = oppt.OwnerId;
            newTask.Priority = 'High';
            newTask.Status = 'Not Started';
            newTask.Subject = 'Delivery of goods';
            DateTime remDate = System.today();
            remDate = remDate.addDays(1);
            remDate = remDate.addHours(10);
            newTask.ReminderDateTime = remDate;
            newTask.WhatId = oppt.Id;
            insert newTask;
        }
        update oppt;
    }
}