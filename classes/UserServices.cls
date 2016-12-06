public with sharing class UserServices{
	 /* -------------------------------------- Begin DAO methods ----------------------------------------------- */

    public static List<User> getUsers() { 
        return new List<User>([SELECT Id, Name
                               FROM User ]);
        
    }
    /* -------------------------------------- End DAO methods ----------------------------------------------- */
}