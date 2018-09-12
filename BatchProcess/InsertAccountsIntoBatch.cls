public class InsertAccountsIntoBatch implements Database.Batchable <SObject>, Database.AllowsCallouts, Database.Stateful {
	public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM Account');
    }
    
    public void execute(Database.BatchableContext bc, List<Account> records) {
        String responseXML;
        List<Account> accountToBeInsert;
        List<XMLParserForSQSResponse.Message> messageList;
        List<String> messageIdList = new List<String>();
        Set<String> successReceiptHandle = new Set<String>();
        Set<String> failedReceiptHandle = new Set<String>();
        Map<String, String> receiptHandleWithBody = new Map<String, String>();
        
        
        RetriveMessageFromAWSQueue awsQueue = new RetriveMessageFromAWSQueue();
        Utility utils = new Utility();
        SQSDeleteBatch sqsDeletebatch = new SQSDeleteBatch();
        
        responseXML = awsQueue.getResponseFromAWS();
        messageList = awsQueue.parseXMLResponse(responseXML);
        
        for(XMLParserForSQSResponse.Message message : messageList) {
            messageIdList.add(message.MessageId);
            receiptHandleWithBody.put(message.ReceiptHandle, message.Body);
        }
        
        for(String body : receiptHandleWithBody.values()) {
            accountToBeInsert.add(awsQueue.retriveDetailsFromJson(body));
        }
        
        List<Database.UpsertResult> result = Database.upsert(accountToBeInsert);
        
        successReceiptHandle = utils.returnSuccessReceiptHandle(result);
        
        Map<String, List<String>> batchGroupforDelete = utils.prepareSetForDeleteBatch(successReceiptHandle);
        for(List<String> ids : batchGroupforDelete.values()) {
            sqsDeletebatch.deleteMessage(ids);
        }
        
        failedReceiptHandle = receiptHandleWithBody.keySet();
        failedReceiptHandle.removeAll(successReceiptHandle);
        utils.addBatchIntoDeadQueue(failedReceiptHandle);
    }
    
    public void finish(Database.BatchableContext bc) {
        AmazonAws__c settings = [SELECT Recursively_Call__c FROM AmazonAws__c];
        
        if(settings.Recursively_Call__c == 'True') {
            Database.executeBatch(new InsertAccountsIntoBatch());
        }
    }
}