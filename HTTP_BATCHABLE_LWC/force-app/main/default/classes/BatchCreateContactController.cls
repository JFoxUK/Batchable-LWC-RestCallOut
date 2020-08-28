public with sharing class BatchCreateContactController {

    @AuraEnabled
    public static Id initiateContactBatch(Integer numberOfRecords) {
        System.debug('ENTERED INITIATE AURA ENABLED METHOD');
        Id jobId = Database.executeBatch(new RecordBatchCreateContacts(numberOfRecords));
        System.debug('JOB ID >> ' + jobId);
        return jobId;
        
    }

    @AuraEnabled
    public static AsyncApexJob getBatchJobStatus(Id jobID){
        System.debug('ENTERED GET BATCH JOB STATUS');
        AsyncApexJob jobInfo = [SELECT ID, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems FROM AsyncApexJob WHERE Id = :jobID];
        return jobInfo;
    }
}