public class SQSDeleteBatch {
    private String getCurrentDate() {
        return DateTime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
    }
    
    public void deleteMessageBatch(List<String> delList) {
        AmazonAws__c settings = [SELECT Access_Key__c, Secret_Key__c, Host__c, Queue__c, Max_Number_Of_Messages__c FROM AmazonAws__c];
        
        String accessKey = settings.Access_Key__c;
        String secretKey = settings.Secret_Key__c;
        String host = settings.Host__c;
        String queue = settings.Queue__c;
        
        Map<String,String> params = new Map<String,String>();
        
        params.put('AWSAccessKeyId',encode(accessKey));
        params.put('Action','DeleteMessageBatch');
        
        
        Integer i= 1;      
        for (string id : delList){
            String paramId = 'DeleteMessageBatchRequestEntry.'+i+'.Id';
            String paramRH = 'DeleteMessageBatchRequestEntry.'+i+'.ReceiptHandle';
            System.debug('param '+paramId);
            System.debug('value '+paramRH);
            params.put(paramId, 'Msg'+i);
            params.put(paramRH, encode(id));
            i++;
        }
        params.put('Timestamp',encode(getCurrentDate()));
        params.put('SignatureMethod','HmacSHA1');
        params.put('SignatureVersion','2');
        params.put('Version','2009-02-01');
        
        //The string to sign has to be sorted by keys
        List<String> sortedKeys = new List<String>();
        sortedKeys.addAll(params.keySet());
        sortedKeys.sort();
        
        String toSign = 'GET\n' + host +'\n'+queue+'\n';
        Integer p = 0;
        for (String key : sortedKeys) {
            String value = params.get(key);
            if (p > 0) {
                toSign += '&';
            }
            p++;
            toSign += key+'='+value;
        }
        params.put('Signature',getMac(toSign,secretKey));
        
        String url = 'https://'+ host+queue+'?';
        p = 0;
        for (String key : params.keySet()) {
            if (p > 0) {
                url += '&';
            }
            p++;
            url += key+'='+params.get(key);
        }
        
        HttpRequest req = new HttpRequest();
        req.setEndPoint(url);
        req.setMethod('GET');
        Http http = new Http();
        try {
            System.debug('Signed string: ' + toSign);
            System.debug('Url: ' + url);
            HttpResponse res = http.send(req);
            System.debug('Status: ' + res.getStatus());
            System.debug('Code  : ' + res.getStatusCode());
            System.debug('Body  : ' + res.getBody());
        }
        catch (System.CalloutException e) {
            System.debug('ERROR: ' + e);
        }
    }
    
    private String encode(String message){
        return EncodingUtil.urlEncode(message,'UTF-8').replace('+', '%20').replace('*', '%2A').replace('%7E','~');
    }
    
    private String getMac(String RequestString, String secretkey) {
        String algorithmName = 'hmacSHA1';
        Blob input = Blob.valueOf(RequestString);
        Blob key = Blob.valueOf(secretkey);
        Blob signing =Crypto.generateMac(algorithmName, input, key);
        return EncodingUtil.urlEncode(EncodingUtil.base64Encode(signing), 'UTF-8');
    }
}