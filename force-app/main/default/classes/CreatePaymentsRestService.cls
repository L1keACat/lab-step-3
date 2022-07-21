@RestResource(urlMapping='/payments')
global with sharing class CreatePaymentsRestService {

    global class JSONPayload {
        public String Opportunity { get; set; }
        public Decimal Amount { get; set; }
        public String FirstName { get; set; }
        public String LastName { get; set; }

        public JSONPayload(String oppt, Decimal amount, String firstName, String lastName) {
            this.Opportunity = oppt;
            this.Amount = amount;
            this.FirstName = firstName;
            this.LastName = lastName;
        }
    }
    
    @HttpPost
    global static ID[] createPayments(List<JSONPayload> payments) {
        Payment__c[] paymentObjects = new Payment__c[] {};
        ID[] paymentObjectIds = new ID[] {};
        Set<String> opptNames = new Set<String>();

        for (JSONPayload i : payments) {
            opptNames.add(i.Opportunity);
        }

        Map<Id, Opportunity> opptsByName = new Map<Id, Opportunity>(
            [SELECT Name FROM Opportunity WHERE Name IN :opptNames]
        );
        List<Opportunity> oppts = [SELECT Name FROM Opportunity WHERE Name IN :opptNames];

        if (!opptsByName.isEmpty()) {
            for (JSONPayload i : payments) {
                for (Opportunity oppt : oppts) {
                    if (oppt.Name == i.Opportunity) {
                        Payment__c paymentObject = new Payment__c(Opportunity__c = oppt.Id, Amount__c = i.Amount, FirstName__c = i.FirstName, LastName__c = i.LastName);
                        paymentObjects.add(paymentObject);
                    }
                }
            }
            insert paymentObjects;
            for (Payment__c paymentObject : paymentObjects) {
                paymentObjectIds.add(paymentObject.Id);
            }
        }
        return paymentObjectIds;
    }
}
