public class RetriveMessageFromAWSQueue {
    public String getResponseFromAWS() {
        String str = '<?xml version="1.0"?><ReceiveMessageResponse xmlns="http://queue.amazonaws.com/doc/2009-02-01/"><ReceiveMessageResult><Message><MessageId>6af10875-47b4-4fa5-8c1b-7b50cb29f5e1</MessageId><ReceiptHandle>AQEBzMLh++z0a1cR5hDl4VSJXjwOaiUuAoPk3GQtPS3d/2r+Axqmoawjc7xMlmUXPDrIaEcD9uLHcQsTffq7yUipTQqxVdgwdkhNit50kCPZavaZ2NIve6XWLB5n5aDTsE0V3n+U64TlzN8nWKK3hpOh7HpjCDqduMfAeEhVVPDFD+P+YDBCTnu/7Vm8jpjMkCnSkoAfJ6rxaZUUMlsllvpBZmZ+FY9jC3dINoqNiqLc22qmha/xF1Qzsh1OuSXAj1jo3/P9tg8a3Qj4B2ewW02/VFMUBM81djKSGxlvrm11QuvqjFtKS+fI6/Ksfe4OkDtBour4lF4m2pwNqjB3hHVacAwU/6FdNnmRxK9SEv9L6w8ZUYD7g42dCkTdRSwKMRelax/dz1XEfOxnosrFMqTZqA==</ReceiptHandle><MD5OfBody>2fad41d472d716a7344a11310ba5a206</MD5OfBody><Body>{ "Name" : "Xytrex Co.", "Description" : "Industrial Cleaning Supply Company", "Account Number" : "ABC15797531" }</Body><Attribute><Name>SenderId</Name><Value>AIDAJCLMPUPTZWL2LNJ5W</Value></Attribute><Attribute><Name>ApproximateFirstReceiveTimestamp</Name><Value>1536313709231</Value></Attribute><Attribute><Name>ApproximateReceiveCount</Name><Value>6</Value></Attribute><Attribute><Name>SentTimestamp</Name><Value>1536313709231</Value></Attribute></Message></ReceiveMessageResult><ResponseMetadata><RequestId>550a7654-cc95-5983-9925-2244d06b4518</RequestId></ResponseMetadata></ReceiveMessageResponse>';
        //return new AWSResponseReceiver().receiveMessage();
        return str;
    }
    
    public List<XMLParserForSQSResponse.Message> parseXMLResponse(String responseXML) {
        return new XMLParserForSQSResponse().getParsedMessages(responseXML);
    }
    
    public Account retriveDetailsFromJson(String responseJson) {
        return (Account)JSON.deserialize(responseJson, Account.Class);
    }
}