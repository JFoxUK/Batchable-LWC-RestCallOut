global class RecordBatchCreateAccounts implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public virtual class AmountIntException extends Exception {}

    Integer amount{get;set;}
    global RecordBatchCreateAccounts(Integer amountInt){ 
       amount = amountInt;
        System.debug('amount is ' + amount);
    }
    
    global List<Contact> start(Database.BatchableContext BC) {
        System.debug('Entering start method');

        HttpResponse response = MockarooHTTPRequest.mockarooGetContacts(amount);
        List<Contact> contacts = MockarooWrapperClass.parse(response.getBody());
        System.debug('contacts is ' + contacts);

        return contacts;
    }
     
    global void execute(Database.BatchableContext BC, List<Contact> contacts) {
        System.debug('Entering execute method');
        // process each batch of records default size is 200
        Database.SaveResult[] srList = Database.insert(contacts, false);
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted Contact. Contact ID: ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Contact fields that affected this error: ' + err.getFields());
                }
            }
        }
    }   
     
    global void finish(Database.BatchableContext BC) {
        System.debug('Entering finish method');
        // execute any post-processing operations like sending email
    }
}