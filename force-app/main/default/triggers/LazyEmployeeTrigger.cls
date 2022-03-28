/**
// This lazy dude wrote code to auto-accept and close all cases!
trigger LazyEmployee on Case (after insert) {
  List<Case> newCases = new List<Case>();
  for (Case a : Trigger.new) {
    a.Status = "Closed";
    a.Owner  = "David Liu";
    newCases.add(a)
  }
  update newCases;
}
 */

// “after insert” cannot update the values because the record is still not
// saved to the database and is in ReadOnly Mode. For Updating use Before Trigger//
trigger LazyEmployeeTrigger on Case (before update) {
List newCases = new List();
Users u = [Select Id From User Where Name = 'David Lui'];
for(Case a:Trigger.new)
{
//Assignment variables should be enclosed in single quotes//
a.Status = ‘Closed’;
//There’s no Owner field in Case object – OwnerId is a lookup from User object
a.OwnerId=u.Id;
newCases.add(a);
}
update newCases;
}

