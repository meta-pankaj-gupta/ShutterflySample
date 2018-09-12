public class XMLParserForSQSResponse {
    public class Message {
        public string MessageId {get; set;}
        public string ReceiptHandle {get; set;}
        public string MD5OfBody {get; set;}
        public string Body {get; set;}
        public Map<String, String> attributes;
    }
    
    public List<Message> getParsedMessages(String xmlString) {
        List<Message> messages = new List<Message>();
        String url = 'http://queue.amazonaws.com/doc/2009-02-01/';
        String name, value;
        
        HTTPresponse resp = New HttpResponse();
        resp.setBody(xmlString);
        Dom.document doc = resp.getBodyDocument();
        Dom.XMLNode root = doc.getRootElement();
        DOM.XmlNode resultNode = root.getChildElement('ReceiveMessageResult', url);
        
        for(Dom.XMLNode messageNode : resultNode.getChildElements()) {
            Message msg = new Message();
            msg.attributes = new Map<string, String>();
            
            for(Dom.XMLNode attributeNode : messageNode.getChildElements()) {
                if(attributeNode.getName() == 'MessageId') {
                    msg.MessageId = messageNode.getChildElement('MessageId', url).getText();
                }
                else if(attributeNode.getName() == 'ReceiptHandle') {
                    msg.ReceiptHandle = messageNode.getChildElement('ReceiptHandle', url).getText();
                }
                else if(attributeNode.getName() == 'MD5OfBody') {
                    msg.MD5OfBody = messageNode.getChildElement('MD5OfBody', url).getText();
                    msg.Body = messageNode.getChildElement('Body', url).getText();
                }
                else if(attributeNode.getName() == 'Body') {
                    msg.Body = messageNode.getChildElement('Body', url).getText();
                }
                else if(attributeNode.getName() == 'Attribute') {
                    name = attributeNode.getChildElement('Name', url).getText();
                    value = attributeNode.getChildElement('Value', url).getText();
                    msg.attributes.put(name, value);
                }
            }
            messages.add(msg);
        }
        
        return messages;
    }
}