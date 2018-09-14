public class ScheduleAccountInsertion implements schedulable {
	public void execute(SchedulableContext sc)
    {
        AmazonAws__c settings = [SELECT No_Of_Batch_Process__c FROM AmazonAws__c];
        
        for(Integer i = 1; i <= settings.No_Of_Batch_Process__c; i++) {
            InsertAccountsIntoBatch insertAccount = new InsertAccountsIntoBatch();
			database.executebatch(insertAccount);
        }
    }
}