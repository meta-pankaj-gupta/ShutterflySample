public class ScheduleAccountInsertion implements schedulable {
	public void execute(SchedulableContext sc)
    {
    	InsertAccountsIntoBatch insertAccount = new InsertAccountsIntoBatch();
		database.executebatch(insertAccount);
    }
}