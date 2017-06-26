open Models.Brand

class cBrandHandler : Sqlite3.db -> object
    method add : string -> cBrand  

    method on_destroy : unit                          
end
