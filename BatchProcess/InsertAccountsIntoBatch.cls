public class InsertAccountsIntoBatch implements Database.Batchable <SObject>, Database.AllowsCallouts, Database.Stateful {
	public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM Account');
    }
    
    public void execute(Database.BatchableContext bc, List<Account> records) {
        List<String> responseXML = new List<String>();
        List<Account> accountToBeInsert = new List<Account>();
        List<XMLParserForSQSResponse.Message> messageList;
        List<String> messageIdList = new List<String>();
        Set<String> failReceiptHandle = new Set<String>();
        Set<String> failedReceiptHandle = new Set<String>();
        Map<String, String> receiptHandleWithBody = new Map<String, String>();
        
        AmazonAws__c settings = [SELECT No_Of_Receive_Message_Call__c FROM AmazonAws__c];
        RetriveMessageFromAWSQueue awsQueue = new RetriveMessageFromAWSQueue();
        Utility utils = new Utility();
        SQSDeleteBatch sqsDeletebatch = new SQSDeleteBatch();
        
        for(Integer i=1; i<=settings.No_Of_Receive_Message_Call__c; i++) {
            responseXML.add(awsQueue.getResponseFromAWS());
        }
        
        messageList = awsQueue.parseXMLResponse(responseXML);
        
        for(XMLParserForSQSResponse.Message message : messageList) {
            messageIdList.add(message.MessageId);
            receiptHandleWithBody.put(message.ReceiptHandle, message.Body);
        }
        
        Map<String, String> mapOfFailureJsonParsingMessage = new Map<String, String>();
       	accountToBeInsert.addAll(awsQueue.retriveDetailsFromJson(receiptHandleWithBody, mapOfFailureJsonParsingMessage));
        
        List<Database.UpsertResult> result = Database.upsert(accountToBeInsert);
       
        failReceiptHandle = utils.returnFailedReceiptHandle(result);
        
		//Todo To write logic to deduct fail ReceiptHandle from receiptHandleWithBody  
		
        Map<String, List<String>> batchGroupforDelete = utils.prepareSetForDeleteBatch(receiptHandleWithBody);
        system.debug('batchGroupforDelete size :'+ batchGroupforDelete.size());
        for(List<String> ids : batchGroupforDelete.values()) {
            system.debug('ids size :'+ ids.size());
            sqsDeletebatch.deleteMessageBatch(ids); //needs to be improve
        }
        
        //Todo following method
        //utils.addBatchIntoDeadQueue(failedReceiptHandle);
    }
    
    public void finish(Database.BatchableContext bc) {
        AmazonAws__c settings = [SELECT Recursively_Call__c FROM AmazonAws__c];
        
        if(settings.Recursively_Call__c == 'True') {
            Database.executeBatch(new InsertAccountsIntoBatch());
        }
    }
}