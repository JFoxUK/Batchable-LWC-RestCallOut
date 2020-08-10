public with sharing class MockarooWrapperClass {


    // public JSONContact recievedContact;

    public class JSONContact {
        public String Firstname;
        public String Lastname;
        public String Email;
        public String Gender;
        public String Mailing_Street;
        public String Mailing_City;
        public String Mailing_County;
        public String Mailing_Country;
        public String Mailing_Post_Code;
        public String Mobile_Number;
        public String External_ID;
    }

    
    public static List<Contact> parse(String json) {

        System.debug('ENTERING  WRAPPER CLASS');
        System.debug('THE JSON STRING IS >>> ' + json);

        List<JSONContact> results = (List<JSONContact>) System.JSON.deserialize(json, List<JSONContact>.class);
        List<Contact> contactListToInsert = new List<Contact>();

        System.debug('THE JSON STRING HAS BEEN CONVERTED INTO THESE OBJECTS >>> ' + results);

        for(JSONContact r : results){
            System.debug(r.Firstname);
            Contact c = new Contact(

                Firstname = r.Firstname,
                Lastname = r.Lastname,
                Email = r.Email,
                Gender__c = r.Gender,
                MailingStreet = r.Mailing_Street,
                MailingCity = r.Mailing_City,
                MailingState = r.Mailing_County,
                MailingCountry = r.Mailing_Country,
                MailingPostalCode = r.Mailing_Post_Code,
                MobilePhone = r.Mobile_Number,
                External_ID__c = r.External_ID
            );
            System.debug('The ' + r + ' JSON STRING IS NOW ' + c +' CONTACT');
            contactListToInsert.add(c);
        }
        System.debug('LIST OF CONTACTS ARE>>> ' + contactListToInsert);
        return contactListToInsert;
    }
}
//EXAMPLE RESPONSE:
//
// {
//     "Contact":{
//             "Firstname":"Shalne",
//             "Lastname":"Bason",
//             "Email":"sbason0@canalblog.com",
//             "Gender":"Female",
//             "Mailing_Street":"4 Glacier Hill Lane",
//             "Mailing_City":"Kingston",
//             "Mailing_County":"England",
//             "Mailing_Country":"United Kingdom",
//             "Mailing_Post_Code":"DT10",
//             "Mobile_Number":"+44 440 964 4247",
//             "External_ID":"GZPI907POXHC225M39"
//     }
// }

// EXAMPLE OF SERIALISED CONTACT FROM SALESFORCE:
// [{
//     "attributes":{
//         "type":"Contact",
//         "url":"/services/data/v49.0/sobjects/Contact/0034K000002hbVnQAI"
//     },
//     "Id":"0034K000002hbVnQAI",
//     "FirstName":"Rose",
//     "LastName":"Gonzalez"
// },
// {
//     "attributes":{
//         "type":"Contact",
//         "url":"/services/data/v49.0/sobjects/Contact/0034K000002hbVoQAI"
//     },
//     "Id":"0034K000002hbVoQAI",
//     "FirstName":"Sea",
//     "LastName":"Smithalez"
// }