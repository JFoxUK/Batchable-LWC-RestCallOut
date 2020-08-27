global class RecordBatchCreateContacts implements Database.Batchable<MockarooWrapperClass>, Database.AllowsCallouts{
    public virtual class AmountIntException extends Exception {}

    Integer amount{get;set;}
    global RecordBatchCreateContacts(Integer amountInt){ 
       amount = amountInt;
        System.debug('amount is ' + amount);
    }
    
    global Iterable<MockarooWrapperClass> start(Database.BatchableContext BC) {
        System.debug('Entering start method');

        HttpResponse response = MockarooHTTPRequest.mockarooGetContacts(amount);

        List<MockarooWrapperClass> parsedResponse = (List<MockarooWrapperClass>)System.JSON.deserialize(response.getBody(), List<MockarooWrapperClass>.class);


        //List<Contact> contacts = MockarooWrapperClass.parse(response.getBody());
        // System.debug('contacts are ' + contacts);

        return parsedResponse;
    }
     
    global void execute(Database.BatchableContext BC, List<Object> parsedResponseScope) {

        List<Contact> contacts = new List<Contact>();
        for(MockarooWrapperClass m : (List<MockarooWrapperClass>)parsedResponseScope){

            contacts.add(m.convertToContact());

        }

        System.debug('Entering execute method');
        // process each batch of records default size is 200
        Database.SaveResult[] srList = Database.insert(contacts, false);
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted Contact. Contact IDs: ' + sr.getId());
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