public class BirthdayEmailScheduler implements Schedulable {

    private String batch_name;

    public BirthdayEmailScheduler(String batchName) {
        batch_name = batchName;
    }

    public void execute(SchedulableContext ctx) {
        Type type = Type.forName(batch_name);
        Object instance = null;
        if (type != null) {
            instance = type.newInstance();
            Id batchId = Database.executeBatch((Database.Batchable<sObject>) instance);
            System.debug('Batch execution started. ID: ' + batchId);
        }
    }
}
