public class AccountProcessor 
{
  @future
  public static void countContacts(Set<id> setId) 
  {
      List<Account> lstAccount = [Select Id, Number_of_Contacts__c , (Select Id From Contacts ) From Account where id in :setId ];
      for( Account acc : lstAccount )
      {
          List<Contact> lstCont = acc.contacts ;
          
          acc.Number_of_Contacts__c = lstCont.size();
      }
      update lstAccount;
  }
}