trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {
    //---> above handling all states which could see a contact added to or removed from an account
   
    //---> on delete we use Trigger.Old, all else, Trigger.new
    List<Contact> contacts = Trigger.isDelete ? Trigger.old : Trigger.new;

    //---> the Set class rocks for finding the unique values in a list
    Set<Id> acctIds = new Set<Id>();
   
    for (Contact c : contacts) {
     //yes, you can have a contact without an account
        if (c.AccountId != null) {
            acctIds.add(c.AccountId);
        }
    }
   
    List<Account> acctsToRollup = new List<Account>();
    
    //****** Here is the Aggregate query...don't count in loops, let the DB do it for you*****
    for (AggregateResult ar : [SELECT AccountId AcctId, Count(id) ContactCount 
                               FROM Contact 
                               WHERE AccountId in: acctIds 
                               GROUP BY AccountId]){
        Account a = new Account();
        a.Id = (Id) ar.get('AcctId'); //---> handy trick for updates, set the id and update
        a.Contact_Count__c = (Integer) ar.get('ContactCount');
        acctsToRollup.add(a);
    }
    
    //----> probably you'll want to do a little more error handling than this...but this should work. 
    update acctsToRollup;

}