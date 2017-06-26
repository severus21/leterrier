exception Unknow_error
exception Not_a_row  
exception Unknow_column of string * string

class virtual cManager : Sqlite3.db -> object
    val _db : Sqlite3.db 

    method virtual on_destroy : unit
    method private check_rc : Sqlite3.Rc.t -> unit
end
