public class Utility {
    public Set<String> returnSuccessReceiptHandle(List<Database.UpsertResult> result) {
        return null;
    }
    
    public Map<String, List<String>> prepareSetForDeleteBatch(Set<String> batchIds) {
        Integer i=0;
        Map<String, List<String>> batchGroup = new Map<String, List<String>>();
        String key;
        List<String> value;
        
        for (String id : batchIds) {
            if(Math.Mod(i, 10) == 0) {
                key = 'Key'+i;
                value = new List<String>();
                i=0;
            }
            i++;
            value.add(id);
            
            if(i == 10) {
                batchGroup.put(key, value);
            }
        }
        return batchGroup;
    }
    
    public void addBatchIntoDeadQueue(Set<String> batchIds) {
        
    }
}
