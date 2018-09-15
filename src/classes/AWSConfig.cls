public with sharing class AWSConfig {
	/**
     *  The SINGLETON handle to the instance
    */
    private static AWSConfig self;
    
    
    private AWSConfigDriver cfgDriver = null;
            
    public static AWSConfig self() {
        if (self != null) return self;
        
        self = new AWSConfig();
        return self;
    } 
    private TCConfig() { 
    	cfgDriver = new AWSCustomSettingDriver();    
    } 
    
    public String accessKey{
        get{
            if(accessKey == null)
                accessKey = cfgDriver.getAccessKey();
            return accessKey;
        }
        private set;
    }
    
	public String host{
        get{
            if(host == null)
                host = cfgDriver.getHost();
            return host;
        }
        private set;
    }
    
    public String queue{
        get{
            if(queue == null)
                queue = cfgDriver.getQueue();
            return queue;
        }
        private set;
    }
    
    public String secretKey{
        get{
            if(secretKey == null)
                secretKey = cfgDriver.getSecretKey();
            return secretKey;
        }
        private set;
    }
    
    public String maxNumberOfMessages {
        get{
            if(maxNumberOfMessages == null)
                maxNumberOfMessages = cfgDriver.getMaxNumberOfMessages();
            return maxNumberOfMessages;
        }
        private set;
    }
    
    public Integer numberOfBatchProcess {
        get{
            if(numberOfBatchProcess == null)
                numberOfBatchProcess = cfgDriver.getNumberOfBatchProcess();
            return numberOfBatchProcess;
        }
        private set;
    }
    
    public Integer numberOfReceiveMessageCall {
        get{
            if(numberOfReceiveMessageCall == null)
                numberOfReceiveMessageCall = cfgDriver.getNumberOfReceiveMessageCall();
            return numberOfReceiveMessageCall;
        }
        private set;
    }  
}