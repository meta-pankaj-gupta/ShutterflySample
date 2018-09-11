public class XMLParserForSQSResponse {

    // Create a class Book for processing
    public class Message {
        public String messageId;
        public String ReceiptHandle;
        public String MD5OfBody;
        public String Body;
        public Map<String,String> attributes;
    }
    

    public List<Message> parseMessages(XmlStreamReader reader) {
        List<Message> messages = new List<Message>();
System.debug('Inside parse messages  1');
        while(reader.hasNext()) {
            // Start at the beginning of the book and make sure that it is a book
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                System.debug(reader.getLocalName());
                if (reader.getLocalName() == 'Message') {
                    
					messages.add(parseMessage(reader));
                }
            }
			reader.next();
        }
        System.debug(messages);
        System.debug('Exit messages  1');
        return messages;
    }
    Message parseMessage(XmlStreamReader reader) {
        Message message =new Message();
        System.debug('Inside parse message');
        Integer count =0;
        while(reader.hasNext()) {
            System.debug(reader.getLocalName());
            // Start at the beginning of the book and make sure that it is a book
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                if (reader.getLocalName() == 'MessageId') {
                    message.messageId = getStringValue(reader);
                    count++;
                }
                if (reader.getLocalName() == 'ReceiptHandle') {
                    message.ReceiptHandle = getStringValue(reader);
                    count++;
                }
                if (reader.getLocalName() == 'MD5OfBody') {
                    message.MD5OfBody = getStringValue(reader);
                    count++;
                }
                if (reader.getLocalName() == 'Body') {
                    message.Body = getStringValue(reader);
                    count++;
                }
                if(count == 4){
                    break;
                }
            }
            
			reader.next();
        }
        System.debug('Exit parsemessage');
        System.debug(message);
        return message;
    }
    // Parse through the XML, determine the author and the characters
    String getStringValue(XmlStreamReader reader) {
        System.debug('Inside getStringValue');
        String value;
        while(reader.hasNext()) {
            System.debug(reader.getLocalName());
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                value = reader.getText();
            }
			reader.next();
        }
        System.debug('Exit getStringValue');
        return value;
    }
}