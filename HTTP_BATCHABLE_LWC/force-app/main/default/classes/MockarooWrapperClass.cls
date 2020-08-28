public with sharing class MockarooWrapperClass {

    //This class is used to 'wrap' ONE contact at a time from the JSON string into a MockarooConactWrapper objected called Contact (Beacuse the JSON defined the objects as 'Contact')

    public MockarooContactWrapper Contact;

    public class MockarooContactWrapper{
    
        //Case sesative exactly how is seen in the JSON string
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
    
    //Method to map the above object into a standard Salesforce Contact Object
    public contact convertToContact(){
        Contact c = new Contact(

            Firstname = this.Contact.Firstname,
            Lastname = this.Contact.Lastname,
            Email = this.Contact.Email,
            Gender__c = this.Contact.Gender,
            MailingStreet = this.Contact.Mailing_Street,
            MailingCity = this.Contact.Mailing_City,
            MailingState = this.Contact.Mailing_County,
            MailingCountry = this.Contact.Mailing_Country,
            MailingPostalCode = this.Contact.Mailing_Post_Code,
            MobilePhone = this.Contact.Mobile_Number,
            External_ID__c = this.Contact.External_ID
        );

            return c;
    }
}