public with sharing class InitiateRecordBatchCreateContact {

    @AuraEnabled
    public static Id initiateContactBatch(Integer numberOfRecords) {

        System.debug('ENTERED INITIATE AURA ENABLED METHOD');

        Id jobId = Database.executeBatch(new RecordBatchCreateAccounts(numberOfRecords));
        System.debug('JOB ID >> ' + jobId);

        return jobId;
        
    }

    @AuraEnabled
    public static AsyncApexJob getBatchJobStatus(Id jobID){
        AsyncApexJob jobInfo = [SELECT Status, NumberOfErrors,JobItemsProcessed,TotalJobItems FROM AsyncApexJob WHERE Id = :jobID];
        return jobInfo;
    }
}