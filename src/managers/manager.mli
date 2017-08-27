(** Here, we define the generic Manager, a manager is in charge of handling the interfacing between the SQL db and the Ocaml part. Each manager will inherit 
    from this one.
    @author severus21
    @version 0.0.0
*)

exception Unknow_error
exception Not_a_row  
exception Unknow_column of string * string

(** This is the general manager class in order to define generic sql functionality
    @param db - the SQlite3 database used*)                                      
class virtual cManager : Sqlite3.db -> object
    (*SQlite3 database used*)
    val _db : Sqlite3.db 
    
    (**Must called in order to properly get ride of the object*)  
    method virtual on_destroy : unit

    (**Convenient function to check the return code of the SQlite3 module,
        @return unit if correct
        @raise TODO otherwith*)
    method private check_rc : Sqlite3.Rc.t -> unit
end
