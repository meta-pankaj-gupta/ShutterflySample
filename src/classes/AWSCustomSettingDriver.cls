public with sharing class AWSCustomSettingDriver {
	public AmazonAws__c awsPersonal;
	
	public AWSCustomSettingDriver() {
		awsPersonal = AmazonAws__c.getValues(UserInfo.getUserId());
		awsPersonal = awsPersonal == null ? (AmazonAws__c.getValues(UserInfo.getProfileId()) != null ? AmazonAws__c.getValues(UserInfo.getProfileId()) : AmazonAws__c.getInstance()) : awsPersonal ;
	}
	
	private Object fetchPersonalCustomSettingValue(String fieldName, Object defVal) {
        Object val = AmazonAws__c.getInstance().get(fieldName);
        return val == null ? defVal : val;
    }
    
    private Integer fetchPersonalCustomSettingIntValue(String fieldName, Integer defVal) {
        Double val = (Double)AmazonAws__c.getInstance().get(fieldName);
        return val == null ? defVal: val.intValue();    
    }
    
    public String getAccessKey() {
        return (String) fetchPersonalCustomSettingValue('Access_Key__c', null);
    }
    
    public String getHost() {
        return (String) fetchPersonalCustomSettingValue('Host__c', null);
    }
    
    public String getQueue() {
        return (String) fetchPersonalCustomSettingValue('Queue__c', null);
    }
    
    public String getSecretKey() {
        return (String) fetchPersonalCustomSettingValue('Secret_Key__c', null);
    }
    
    public String getMaxNumberOfMessages() {
        return (String) fetchPersonalCustomSettingIntValue('Max_Number_Of_Messages__c', null);
    }
    
    public Integer getNumberOfBatchProcess() {
        return fetchPersonalCustomSettingIntValue('No_Of_Batch_Process__c', 5);
    }
    
    public Integer getNumberOfReceiveMessageCall() {
        return fetchPersonalCustomSettingIntValue('No_Of_Receive_Message_Call__c', 5);
    }
    
}