open OUnit2

exception Unknow_error
exception Not_a_row  
exception Unknow_column of string * string

class virtual cManager (db:Sqlite3.db) = object(self)
    val _db = db

    initializer
        Gc.finalise (fun obj -> obj#on_destroy) self
  
    method private check_rc =function
        |Sqlite3.Rc.DONE | Sqlite3.Rc.OK-> ()        
        |c->failwith (Printf.sprintf "%s %s" 
                        (Sqlite3.Rc.to_string c) (Sqlite3.errmsg _db)
         )
end
