public class AWSResponseReceiver {
    private String getCurrentDate() {
        return DateTime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
    }
    
    public String receiveMessage() {
        //List<AmazonAws__c> customeSettings = AmazonAws__c.getall().values();
        AmazonAws__c settings = [SELECT Access_Key__c, Secret_Key__c, Host__c, Queue__c, Max_Number_Of_Messages__c FROM AmazonAws__c];
        
        String accessKey = settings.Access_Key__c;
        String secretKey = settings.Secret_Key__c;
        String host = settings.Host__c;
        String queue = settings.Queue__c;
        
        Map<String, String> params = new Map<String, String>();
        
        params.put('AWSAccessKeyId', encode(accessKey));
        params.put('Action', 'ReceiveMessage');
        params.put('MaxNumberOfMessages', settings.Max_Number_Of_Messages__c);
        params.put('AttributeName', 'All');
        params.put('SignatureMethod', 'HmacSHA1');
        params.put('Expires', '2020-04-18T22%3A52%3A43PST');
        params.put('SignatureVersion', '2');
        params.put('Version', '2009-02-01');
        
        List<String> sortedKeys = new List<String>();
        sortedKeys.addAll(params.keySet());
        sortedKeys.sort();
        
        String toSign = 'GET\n' + host + '\n' + queue + '\n';
        Integer p = 0;
        for (String key : sortedKeys) {
            String value = params.get(key);
            if (p > 0) {
                toSign += '&';
            }
            p++;
            toSign += key + '=' + value;
        }
        params.put('Signature', getMac(toSign, secretKey));
        
        String url = 'https://'+ host + queue + '?';
        p = 0;
        for (String key : params.keySet()) {
            if (p > 0) {
                url += '&';
            }
            p++;
            url += key + '=' + params.get(key);
        }
        
        HttpRequest req = new HttpRequest();
        req.setEndPoint(url);
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        try {
            System.debug('Url: ' + url);
            System.debug('Status: ' + res.getStatus());
            System.debug('Code  : ' + res.getStatusCode());
            System.debug('Body  : ' + res.getBody());
            return res.getBody();
        }
        catch (System.CalloutException e) {
            System.debug('ERROR: ' + e);
        }
        return null;
    }
    
    private String encode(String message){
        return EncodingUtil.urlEncode(message, 'UTF-8').replace('+', '%20').replace('*', '%2A').replace('%7E', '~');
    }
    
    private String getMac(String RequestString, String secretkey) {
        String algorithmName = 'hmacSHA1';
        Blob input = Blob.valueOf(RequestString);
        Blob key = Blob.valueOf(secretkey);
        Blob signing =Crypto.generateMac(algorithmName, input, key);
        return EncodingUtil.urlEncode(EncodingUtil.base64Encode(signing), 'UTF-8');
    }
}