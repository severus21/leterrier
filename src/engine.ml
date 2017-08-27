(*It is the core stone of the logical part of the application, 
    it is designed in order to link every pieces together.
    @author severus21
    @version 0.0.0 
*)

(** The engine is the puppet master of the logical part of our application, 
    mainly it gather the handlers*)
let engine = object(self)
    (*The stock SQlite3 database used by the app*)  
    val db_stock = Sqlite3.db_open "db/stock.db"
    
    (*An instance of the cBrandHandler which is takes care of the logical part of the brand related stuff*)           
    val mutable _brand = None 
    
    initializer(
        _brand <- Some (new Handlers.Brand.cBrandHandler db_stock) 
    )
    
    (**Export the current brand handler*)                        
    method brand = match _brand with
        |None -> failwith "It should never happen"
        |Some c-> c 
    
    (**Must be called before closing the app in order to close everything properly *)                
    method on_destroy =
        (self#brand)#on_destroy   
end 
