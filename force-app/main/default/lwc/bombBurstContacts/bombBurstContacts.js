import { LightningElement, track, wire } from 'lwc';
import initiateContactBatch from '@salesforce/apex/BatchCreateContactController.initiateContactBatch';
import getBatchJobStatus from '@salesforce/apex/BatchCreateContactController.getBatchJobStatus';
export default class BombBurstContacts extends LightningElement {

    

    @track numberInput = 0;
    @track jobID = null;
    @track createError;
    @track error;
    @track record;
    @track processing = false;
    @track jobPercentage;
    @track totalJobItems;
    @track jobItemsProcessed;
    @track status;
    @track progress = 500;  
  
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
                this.connectedCallback();
                
            })
            .catch(error => {
                this.createError = error;
                console.log('this.createError' + this.createError);
                
            });
    }

    //connectedCallback to repeadedly call the Apex method IOT SOQL the batch job status
    connectedCallback() {  
        if(this.jobID != null){

            this._interval = setInterval(() => {  
                
                
               //this.getStatus();


               getBatchJobStatus({ jobID : this.jobID})
                .then(result => {
                    this.record = result;
                    console.log('this.record' + this.record);
                })
                .catch(error => {
                    this.error = error;
                    console.log('this.error' + this.error);
                });
                

                this.progress = this.progress + 25000;
                console.log('this.progress' + this.progress);
                

                if ( this.progress === 200000 ) {  
                    clearInterval(this._interval);  
                }  

            }, 
            
            this.progress);  
        }
  
    }  

    //* Moved to within the callback method */
    // getStatus(){
    //     getBatchJobStatus({ jobID : jobID})
    //     .then(result => {
    //         this.record = result;
    //         console.log('this.record' + this.record);
    //     })
    //     .catch(error => {
    //         this.error = error;
    //         console.log('this.error' + this.error);
    //     });
    // }


    
    
}