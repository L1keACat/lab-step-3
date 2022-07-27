public with sharing class MailingSchedulerController {

    @AuraEnabled(cacheable=true)
    public static String runBatchOnce(String batchName) {
        try {
            Type type = Type.forName(batchName);
            Object instance = null;
            if (type != null) {
                instance = type.newInstance();
                Id batchId = Database.executeBatch((Database.Batchable<sObject>) instance);
                System.debug('Batch execution started. ID: ' + batchId);
                return 'Batch execution started. ID: ' + batchId;
            }
            return 'Batch execution did not start.';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static String scheduleBatch(String cronExp, String batchName, String schedulerName) {
        try {
            BirthdayEmailScheduler scheduler = new BirthdayEmailScheduler(batchName);
            String jobID = System.schedule(schedulerName, cronExp, scheduler);
            return 'Job has been scheduled successfully.';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String abortBatch(String schedulerName) {
        try {
            CronJobDetail job = [SELECT Id FROM CronJobDetail WHERE Name =: schedulerName];
            CronTrigger cronTrigger = [SELECT Id FROM CronTrigger WHERE CronJobDetailId =: job.Id];
            System.abortJob(cronTrigger.Id);
            return 'Job has been aborted successfully.';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> checkSchedulerStatus(String schedulerName) {
        Map<String, Object> result = new Map<String, Object>(); 
        try {
            CronJobDetail job = [SELECT Id FROM CronJobDetail WHERE Name =: schedulerName];
            CronTrigger cronTrigger = [SELECT Id, State, CronExpression FROM CronTrigger WHERE CronJobDetailId =: job.Id];
            if (cronTrigger.State == 'WAITING' || cronTrigger.State == 'ACQUIRED' || cronTrigger.State == 'EXECUTING') {
                result.put('status', true);
                result.put('cronexp', cronTrigger.CronExpression);
            }
            return result;
        } catch (System.QueryException e) {
            result.put('status', false);
            return result;
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
