// Write a trigger that will prevent each user from creating more than 99 cases a month
// The maximum number of cases per user should be configurable without code.
// Each user will have the same maximum
// Users should see the following error message if they break their max:
// Too many cases created this month for user "Name"(UserID):"Maximum"

trigger CaseCreationLimit on Case (before insert) {
    CaseCreationLimit__mdt maxLimit = [Select Limit__c From CaseCreationLimit__mdt];
    // Get max cases
    Integer maxCases = (Integer) maxLimit.Limit__c;
    Map<Id, Integer> userWithCaseCount = new Map<Id,Integer>();
    Set<Id> userId = new Set<Id>();

    for(Case c: Trigger.new){
        userId.add(c.OwnerId);
    }

    if(!userId.isEmpty()){
        for(AggregateResult countResult : [Select OwnerId, Count(Id) recordCount from Case
                                           Where CreatedDate = THIS_MONTH
                                           And CreatedById =: userId
                                           Group By OwnerId])
                                           {
                                               Integer caseCount = (Integer) countResult.get('recordCount');
                                               Id userId = (Id) countResult.get('OwnerId');
                                               userWithCaseCount.put(userId,caseCount);

                                           }
        for(Case c2 : Trigger.new){
            // If the Id is in userWithCaseCount then get that ownerId if not exit.
            Integer caseCount = userWithCaseCount.containsKey(c2.OwnerId) ? userWithCaseCount.get(c2.OwnerId) : 0;
            if(caseCount > maxCases){
                c2.addError('Too many cases created for this user');            }
        }
    }

}