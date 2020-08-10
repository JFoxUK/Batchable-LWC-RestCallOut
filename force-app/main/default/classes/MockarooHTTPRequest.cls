public with sharing class MockarooHTTPRequest {
    public static HttpResponse mockarooGetContacts(Integer noRows) {
        System.debug('ENTERING  HTTP REQUEST CLASS');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        mockaroo_REST_API__mdt mockaroo_REST_API = [SELECT API_URL__c, API_Key__c, API_Method_URL_Param__c FROM mockaroo_REST_API__mdt WHERE DeveloperName = 'random_contact'];
        String APIURL = mockaroo_REST_API.API_URL__c;
        String APIKEY = mockaroo_REST_API.API_Key__c;
        String APIMETHODPARAM = mockaroo_REST_API.API_Method_URL_Param__c;
        System.debug(APIKey);
        request.setEndpoint(APIURL + APIMETHODPARAM + noRows + APIKey);
        System.debug(request.getEndpoint());
        request.setMethod('GET');
        System.debug(request);
        HttpResponse response = http.send(request);

       
        if (response.getStatusCode() == 200) {
            System.debug(response.getStatusCode());
            System.debug(response);
           
            return response;
        }else{
            System.debug(response.getStatusCode());
            return null;
        }
    }
}

//API & KEY >> https://my.api.mockaroo.com/random_contact/NUMBER_OF_ROWS/CONTACTS_WANTED.json?key=0d841430