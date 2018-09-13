public class RetriveMessageFromAWSQueue {
    public String getResponseFromAWS() {
        return new AWSResponseReceiver().receiveMessage();
    }
    
    public List<XMLParserForSQSResponse.Message> parseXMLResponse(List<String> responseXML) {
        return new XMLParserForSQSResponse().getParsedMessages(responseXML);
    }
    
    public List<Account> retriveDetailsFromJson(Map<String, String> receiptHandleWithBody, Map<String, String> mapOfFailureJsonParsingMessage) {
        List<Account> accList = new List<Account>();
        String message;
        
        for(String Id : receiptHandleWithBody.keySet()){
            try{
                message = receiptHandleWithBody.get(Id);
                accList.add((Account)JSON.deserialize(message, Account.Class));
            }
            catch(JSONException e){
                mapOfFailureJsonParsingMessage.put(Id, e.getMessage());
                receiptHandleWithBody.remove(Id);
            }
        }
        
        return accList;
    }
}