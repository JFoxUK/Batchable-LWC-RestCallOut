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
  
    onChange(event){
        this.numberInput = event.target.value;
        console.log('this.numberInput' + this.numberInput);
    }
    
    createRecords(){
        
        initiateContactBatch({ numberOfRecords : this.numberInput })
            .then(result => {
                this.jobID = result;
                this.processing = true;
                console.log('this.jobID' + this.jobID);
                console.log('this.processing' + this.processing);

                this.connectedCallback();
                
            })
            .catch(error => {
                this.createError = error;
                console.log('this.createError' + this.createError);
                
            });
    }

    connectedCallback() {  
        if(this.jobID != null){
            this._interval = setInterval(() => {  
                
                
               //this.getStatus();

               this.getBatchJobStatus({ jobID : this.jobID})
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
            }, this.progress);  
        }
  
    }  

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