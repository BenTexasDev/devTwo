@IsTest

public class AccountProcessorTest {

Account a = new Account();
a.Name = 'Benzino Business';
insert a;

Contact c = new Contact();

c.FirstName = 'John';
c.LastName = 'Gibson';
c.AccountId = a.Id;
insert c;

Set<Id> accountId = new Set<Id>();
accountId.add(a.Id);

Test.startTest();
    AccountProcessor.countContacts(setAccId);
Test.stopTest();

Account countA = [Select Number_of_Contacts__c From Account Where Id =:a.id LIMIT 1];

System.assertEquals(Integer.valueOf(countA.Number_of_Contacts__c)), 1);

}