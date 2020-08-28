import { LightningElement, track, wire, api } from 'lwc';
import initiateContactBatch from '@salesforce/apex/BatchCreateContactController.initiateContactBatch';
export default class BombBurstContacts extends LightningElement {

    @track numberInput = 0;
    @api jobID = null;
    @track createError;
    @api processing = false;
    
  
    //Captures user input for number of records they wish to create
    onChange(event){
        this.numberInput = event.target.value;
        console.log('this.numberInput' + this.numberInput);
    }
    
    //Calls the apex class BatchCreateContactController and method initiateContactBatch - passing in the desired numbr
    createRecords(){
        initiateContactBatch({ numberOfRecords : this.numberInput })

            .then(result => {
                //Apex method returns type ID
                this.jobID = result;
                this.processing = true;

                console.log('this.jobID' + this.jobID);
                console.log('this.processing' + this.processing);

                //Used to initiate teh connectedCallback to refresh the status of the job
                //this.connectedCallback();
                
            })
            .catch(error => {
                this.createError = error;
                console.log('this.createError' + this.createError);
                
            });
    }
}