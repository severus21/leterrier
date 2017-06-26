let engine = object(self)
    val db = Sqlite3.db_open "db/stock.db"
    val mutable _brand = None 
    
    initializer(
        _brand <- Some (new Handlers.Brand.cBrandHandler db) 
    )
    
    method brand = match _brand with
        |None -> failwith "It should never happen"
        |Some c-> c 

    method on_destroy =
        (self#brand)#on_destroy   
end 
