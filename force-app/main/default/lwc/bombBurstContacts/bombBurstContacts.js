import { LightningElement, track } from 'lwc';
import initiateContactBatch from '@salesforce/apex/BatchCreateContactController.initiateContactBatch';

export default class BombBurstContacts extends LightningElement {

    @track numberInput;
    @track jobId;
    @track error;
   

    
    createRecords(){
        
        initiateContactBatch(numberInput)
            .then(result => {
                this.jobId = result;
                
            })
            .catch(error => {
                this.error = error;
                
            });
    }
    
}