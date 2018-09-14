public class Utility {
    public Set<String> returnFailedReceiptHandle(List<Database.UpsertResult> result) {
        Set<String> failedResultList = new Set<String>();
        for(Database.UpsertResult res : result) {
            if(!res.isSuccess()) {
                failedResultList.add(res.getId());
            }
        }
        return failedResultList;
    }
    
    public Map<String, List<String>> prepareSetForDeleteBatch(Map<String, String> successResultMap) {
        Integer i=0;
        Map<String, List<String>> batchGroup = new Map<String, List<String>>();
        String key;
        List<String> value;
        
        for (String id : successResultMap.keySet()) {
            if(Math.Mod(i, 10) == 0) {
                key = 'Key'+i;
                value = new List<String>();
                batchGroup.put(key, value);
                i=0;
            }
            i++;
            value.add(id);
        }
        return batchGroup;
    }
    
    public void addBatchIntoDeadQueue(Set<String> batchIds) {
        
    }
}