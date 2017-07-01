open Models.Brand

class cBrandHandler : Sqlite3.db -> object
    method add : string -> cBrand  
    method ls : cBrand list 
    method remove : ?id:int64 option -> ?name:string option-> unit ->bool                           
    method on_destroy : unit                          
end
