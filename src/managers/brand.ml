(*  @author severus21
    @version 0.0.0*) 

open Sqlite3
open OUnit2

open Models.Brand
open Manager

class cBrandManager db = object(self)
    inherit cManager db       
    
    val _stmt_store = prepare db "INSERT OR IGNORE INTO brands (name) VALUES (?);" 
    val _stmt_get = prepare db "SELECT rowid FROM brands WHERE name=?;"  
    val _stmt_ls = prepare db "SELECT rowid, name FROM brands;"

    val _stmt_remove_id = prepare db "DELETE FROM brands WHERE rowid=?;"
    val _stmt_remove_name = prepare db "DELETE FROM brands WHERE name=?;"
    val _stmt_remove_id_name = prepare db "DELETE FROM brands WHERE rowid=? 
                                 AND name=?;"
    method on_destroy =
        try
            ignore (finalize _stmt_store);
            ignore (finalize _stmt_get);
            ignore (finalize _stmt_ls);
            ignore (finalize _stmt_remove_id);
            ignore (finalize _stmt_remove_name);
            ignore (finalize _stmt_remove_id_name);
        with|_->()

    method get (name:string) =
        self#check_rc (bind _stmt_get 1 
                         (Data.TEXT name)) ;        
        
        let _brand = (match step _stmt_get with
        |Rc.ROW ->(
            if (data_count _stmt_get) = 0 then None
            else(
                match column _stmt_get 0 with 
                |Data.INT(_rowid) -> Some (new cBrand name ~rowid:(Some _rowid) ())
                |_ -> raise (Unknow_column ("brands",(column_name _stmt_get 0)))
            ) 
        )
        |_->None) in

        self#check_rc(reset _stmt_get);
        _brand

    method private insert (brand:cBrand) =
        self#check_rc (bind _stmt_store 1 
                         (Data.TEXT (brand#name))) ;        
        
        self#check_rc (step _stmt_store);   
        
        self#check_rc(reset _stmt_store);
        if changes _db = 0 then( (*it means this is an update of an existing row*)
            match self#get brand#name with
              |None -> raise Unknow_error 
              |Some(_brand) -> brand#set_rowid _brand#rowid  
        )else  
            brand#set_rowid (Some(last_insert_rowid _db));
         
()
    method private update (brand:Models.Brand.cBrand) =
        match brand#rowid with
        |None -> raise Not_a_row 
        |Some(rowid) ->(
            (*We do nothing because the only colum (except "rowid") 
            is "name" and it is the primary key hence in this case the update do 
            nothing*)
         )

    method store brand = 
        match brand#rowid with
        |None -> self#insert brand
        |Some(rowid) -> self#update brand

    method ls = 
        let _brands = ref [] in 
        while step _stmt_ls = Rc.ROW do
            let _data = row_data _stmt_ls in
            let _names = row_names _stmt_ls in
                let rowid = (match _data.(0) with 
                |Data.INT(_rowid) ->  _rowid
                |_ -> raise (Unknow_column ("brands",(_names.(0))))
                ) in
                   
                let name = (match _data.(1) with 
                |Data.TEXT(_name) -> _name 
                |_ -> raise (Unknow_column ("brands",(_names.(1))))
                ) in  
              
            _brands := (new cBrand name ~rowid:(Some rowid) ()) :: !_brands; 
        done;

        self#check_rc(reset _stmt_ls);

        List.rev !_brands
    
    (*WARNING it is a -f remove, TODO do both kind of remove*)      
    method remove ?id:(id=None) ?name:(name=None) ()= 
    match id,name with
    |None, None -> false    
    |Some _id, None ->(
        self#check_rc (bind _stmt_remove_id 1 
                         (Data.INT _id)) ;        
        
        self#check_rc (step _stmt_remove_id);   
        
        self#check_rc(reset _stmt_remove_id);
        (changes _db) <>0
    )
    |None, Some _name ->(
        self#check_rc (bind _stmt_remove_name 1 
                         (Data.TEXT _name)) ;        
        
        self#check_rc (step _stmt_remove_name);   
        
        self#check_rc(reset _stmt_remove_name);
        (changes _db) <>0
    )
    |Some _id, Some _name ->(
        self#check_rc (bind _stmt_remove_id_name 1 
                         (Data.INT _id)) ;   
        self#check_rc (bind _stmt_remove_id_name 2 
                         (Data.TEXT _name)) ;        
        
     
        
        self#check_rc (step _stmt_remove_id_name);   
        
        self#check_rc(reset _stmt_remove_id_name);
        (changes _db) <>0
    )    
end

let unittests () =
    let _brands = [|new cBrand "Salomon" (); new cBrand "Oldo" (); 
                     new cBrand "Mamut" (); new cBrand "Millet" (); 
                     new cBrand "Asic" () |] in
    let _names = Array.map (fun brand -> brand#name) _brands in 
    let reset () = Array.iter (fun x -> x#set_rowid None) _brands in

    "cBrand">:::[
        "test_store">::(function _->(  
            let db = Sqlite3.db_open "db/test1.db" in
            let brandManager = new cBrandManager db in
            reset (); 


            Array.iter (fun brand -> assert_equal brand#rowid None) _brands;       
            Array.iter (fun brand -> brandManager#store brand) _brands;
            Array.iter (fun brand -> assert (brand#rowid != None) ) _brands;

            Array.iter (fun brand -> let _id=brand#rowid in 
                            brandManager#store brand;
                            assert_equal _id brand#rowid) _brands;
            
            let _brand = new cBrand "Salomon" () in
            brandManager#store _brand;
            assert (_brand#eq _brands.(0));  
            
            brandManager#on_destroy;
            assert (Sqlite3.db_close db)
        ));
        "test_get">::(function _->(
            let db = Sqlite3.db_open "db/test2.db" in
            let brandManager = new cBrandManager db in
            reset ();

            Array.iter (fun brand -> brandManager#store brand) _brands;
            
            let _tmp = Array.map (fun name -> brandManager#get name) _names in
            Array.iteri (fun i ->function
                           |None -> assert false 
                           |Some _brand-> assert (_brand#eq _brands.(i))
            ) _tmp;  
            
            brandManager#on_destroy;
            assert (Sqlite3.db_close db)
        ));
        "test_ls">::(function _->(
            let db = Sqlite3.db_open "db/test3.db" in
            let brandManager = new cBrandManager db in
            reset(); 

            Array.iter (fun brand -> brandManager#store brand) _brands;
            
            let _tmp = brandManager#ls in
            List.iteri (fun i _brand ->assert (_brand#eq _brands.(i)) )_tmp;  
            
            brandManager#on_destroy;
            assert (Sqlite3.db_close db)
        ));
        "test_remove">::(function _->(
            let db = Sqlite3.db_open "db/test4.db" in
            let brandManager = new cBrandManager db in
            reset ();

            Array.iter (fun brand -> brandManager#store brand) _brands;
            Array.iter (fun name -> assert_equal ((brandManager#remove  
                                               ~name:(Some (name^"R")) ())) false) _names;
            Array.iter (fun brand -> assert (brandManager#remove 
                                               ~name:(Some brand#name) ())) _brands;

            assert_equal (brandManager#ls) [];
            Array.iter (fun x -> x#set_rowid None) _brands;

            Array.iter (fun brand -> brandManager#store brand) _brands;
            Array.iter (fun brand -> assert_equal ((brandManager#remove  
                                               ~id:None ())) false) _brands;
            Array.iter (fun brand -> assert (brandManager#remove 
                                               ~id:brand#rowid ())) _brands;
            assert_equal (brandManager#ls) [];
            Array.iter (fun x -> x#set_rowid None) _brands;

            Array.iter (fun brand -> brandManager#store brand) _brands;
            Array.iter (fun brand -> assert_equal (brandManager#remove  
                                               ~name:(Some (brand#name^"R")) 
                                               ~id:brand#rowid ()) false) _brands;
            Array.iter (fun brand -> assert (brandManager#remove  
                                               ~name:(Some brand#name) 
                                               ~id:brand#rowid ())) _brands;
            assert_equal (brandManager#ls) [];

            
            brandManager#on_destroy;
            assert (Sqlite3.db_close db)
        ));

    ]    

