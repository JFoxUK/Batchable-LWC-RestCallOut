import { LightningElement, track, api } from 'lwc';
import getBatchJobStatus from '@salesforce/apex/BatchCreateContactController.getBatchJobStatus';

export default class progressTracker extends LightningElement {

    @api processing;
    @api jobID;
    @track error;
    @track record;
    @track jobPercentage;
    @track totalJobItems;
    @track jobItemsProcessed;
    @track viewProgress; 
    @track status;
    @track complete;
    @track showDebug = false;


    
    viewProgressTracker(){

        console.log("Clicked view progress!")
        this.viewProgress = true;
        
        getBatchJobStatus({ jobID : this.jobID })

        .then(result => {
            //Apex method returns type ID
            console.log(this.record);
            this.record = result;
            
            
        })
        .catch(error => {
            this.error = error;
            console.log('this.error' + this.error);
            
        });

        this.processing = true;
        this.totalJobItems = this.record.TotalJobItems;
        this.jobItemsProcessed = this.record.JobItemsProcessed;
        this.status = this.record.Status;
        
        this.jobPercentage = (this.jobItemsProcessed / this.totalJobItems)*100;

        if(jobPercentage === 100){
            this.processing = false;
        }

        console.log('this.record' + this.record);
        console.log('this.record.totalJobItems' + this.record.TotalJobItems);
        console.log('this.processing' + this.processing);
    }

    
    toggleAccordian(){
        if(this.showDebug != true){
            this.showDebug = true;
        }else{
            this.showDebug = false;
        }
       
        
    }
}