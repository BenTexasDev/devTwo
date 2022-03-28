/**
Can you find whats wrong with this trigger?
// Automatically populate a lookup field to the Rival object
trigger GetRival on Account (after insert, after update) {
  for (Account acc : Trigger.new) {
    // Find the Rival record based on the picklist value
    Rival__c comp = [SELECT Id, Name
                       FROM Rival__c
                      WHERE Name = acc.Rival_Picklist__c];

    // Rival__c is a lookup to the Rival custom object
    acc.Rival__c  = comp.Name; 
  }
}

 */

// Automatically populate a lookup field to the Rival object
// Should be before insert, before update.
// Query should not be in the for loop for gov. limit purposes.
//
trigger GetRival on Account (before update, before insert) {

Rival__c riv = [SELECT Id, Name
                 FROM Rival__c];

  for (Account acc : Trigger.new) {
      if(riv.Name == acc.Rival_Picklist__c){
          acc.Rival__c = riv.Id;
      }
  }
}