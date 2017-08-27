(** Here, we define the specific behaviour of the sql management of the brand 
    structure
    @author severus21
    @version 0.0.0
    *)

open Sqlite3

open Models.Brand

(** The brand manager is dedicated to interface the Ocaml structure with the sql one
    @param db - the SQlite3.db used*)  
class cBrandManager : db -> object
    inherit Manager.cManager
    
      
    method on_destroy : unit
   
    (**Given the name of a brand, "get" will outputs the
        related cBrand object.
        @param name - name of the brand 
        @return the related cBrand object if exists 
        @raise TODO
        
    *)  
    method get : string -> cBrand option
    
    (* Given a cBrand object, this function will insert it into the SQL database db if it does not already exist.
        @param brand - the cBrand object to insert
        @raise TODO
    *) 
    method private insert :  cBrand -> unit

    (* Given a cBrand object, this function will update the related row in the SQL 
        if it already exists, hence the rowid of the object is set to some number.
        @param brand - the cBrand object to update
        @raise TODO
    *)                                     
    method private update :  cBrand -> unit

    (** Given a cBrand object, this function will store this, insert or update according the situation, into the SQL database db
        @param brand - the cBrand object to store
        @raise TODO
    *)                                     
    method store : cBrand -> unit

    (** Removes row, inside the SQL database db, related to id - a rowid - or to name - a row name. N.B : if both id and  name are provided then the function will check that they match the same cBrand in order to remove it. 
        @param id - optional, the rowid of the cBrand to delete
        @param name - optional, the name of the cBrand to delete
        @param - in order to mark the end of the optional arguments
        @return true if the deletion have been successfully done, false otherwise
        @raise TODO
    *)
    method remove : ?id:int64 option -> ?name:string option-> unit ->bool              
    (** As its name suggest, this function looks like the Unix command. It is used to output the list of cBrand object in the SQL database db.
        @return all the brand in the SQL database db. 
        @raise TODO    
      *)
    method ls : cBrand list
end

(** Gathers and exports every unittests of this module*)
val unittests : unit -> OUnit2.test
