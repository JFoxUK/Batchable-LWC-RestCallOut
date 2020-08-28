global class RecordBatchCreateContacts implements Database.Batchable<MockarooWrapperClass>, Database.AllowsCallouts{
    //Create innter class to extend exception allowing to throw custom exception
    //public virtual class AmountIntException extends Exception {}

    //Amount defined 
    Integer amount{get;set;}

    Database.SaveResult[] srList{get;set;}

    //Setter Method to allow input param to set the number of records wanted to create from the API
    global RecordBatchCreateContacts(Integer amountInt){ 
       amount = amountInt;
        System.debug('amount is ' + amount);
    }
    
    //Itterable on the wrapper class as it is not a Salesforce object and rather an apex object
    global Iterable<MockarooWrapperClass> start(Database.BatchableContext BC) {
        System.debug('Entering start method');

        //Make the call out
        HttpResponse response = MockarooHTTPRequest.mockarooGetContacts(amount);

        //Create a list of the apex class, get the response and deserialise it into a Moackeroo object and then cast into a list of that object
        List<MockarooWrapperClass> parsedResponse = (List<MockarooWrapperClass>)System.JSON.deserialize(response.getBody(), List<MockarooWrapperClass>.class);

        System.debug('Contacts are ' + parsedResponse);

        return parsedResponse;
    }
     
    global void execute(Database.BatchableContext BC, List<Object> parsedResponseScope) {

        List<Contact> contacts = new List<Contact>();

        //Accepted a 'non-specified' type of object so need to cast it back to a MockerooWrapperClass apex object
        for(MockarooWrapperClass m : (List<MockarooWrapperClass>)parsedResponseScope){

            //Instance of the Mockaroo class, using this method, convert the apex object into standard sObject
            contacts.add(m.convertToContact());

        }

        System.debug('Entering execute method');
        // process each batch of records default size is 200
        Database.SaveResult[] srsList = Database.insert(contacts, false);
        srList = srsList;
        for (Database.SaveResult sr : srsList) {
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