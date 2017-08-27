(**Here we define of the logical part of the brands handling. Moreover, this module hide the (sql)data management done by the cBrandManager module. 
    @author severus21
    @version 0.0.0
*)
open Models.Brand

(**This class will handle all the work related to brands of a specific database. However, the sql part of the job is located in the cBrandManager module.
    @param db - a SQlite3 db correctly opened
*)  
class cBrandHandler : Sqlite3.db -> object

    (**Add a new brand, if not exists
        @param name - the name of the brand added
        @return the related cBrand object if succeed
        @raise TODO otherwith*)   
    method add : string -> cBrand  
    
    (**List all the brands in the database
        @return all the brands in the database*) 
    method ls : cBrand list
    
    (**Remove a brand from the database, it can be designed by its name or by its id
        @param id - optional, the id of the brand
        @param name : optional, the name of the brand
        @return TODO
        @raise TODO
        TODO take care of the force *)                         
    method remove : ?id:int64 option -> ?name:string option-> unit ->bool
    
    (**Must be called when we want to properly get ride of the object*)                                                                   
    method on_destroy : unit                          
end
