trigger CreateRenewal on Opportunity (before update) {

// Map to store all renewal opps for bulk inserting
Map renewals = new Map();

for(Opportunity opp: Trigger.new){
    //Only create renewal opps for closed won deals
    if(opp.StageName == 'Payment Made'){
        Opportunity renewal = new Opportunity();
        renewal.AccountId = opp.AccountId;
        renewal.Name = 'New Renewal!';
        renewal.CloseDate = Date.today();
        renewal.StageName = 'In Contract';
        renewal.RecordTypeId = '0120N000000dfvtQAA'// Can query for this and store into a variable
        renewal.OwnerId = opp.OwnerId;
        renewals.put(renewal.Id, renewal);
    }
}

}