open Misc
open Engine  
open Ihm.Parser
open Format

class cBrandPlugin (engine:<brand:Handlers.Brand.cBrandHandler;..>) (cli:cliParser) (stdf,errf)= object(self) 
    val _brand_name = ref ""
    val _brand_id = ref None

    val _flag_f = ref false
    val _flag_l = ref false
    
    method add_brand name=
        let _brand = engine#brand#add name in
        match _brand#rowid with
        |None -> fprintf stdf "Insertion failed, please see the log.\n"    
        |Some _id -> fprintf stdf "Brand <%Li>:<%s> has been successfully added.\n" 
                       _id  _brand#name       
    
    method list_brand ()=
        let _brands = engine#brand#ls in
        fprintf stdf "Brands list :\n=============\n@[<hov 4>";
        if !_flag_l then 
            fprintf stdf "\trowid\tname\n"
        else
            fprintf stdf "\tname\n";

        List.iteri (fun i _brand ->
            match _brand#rowid with
            |None -> failwith "TODO internal error"
            |Some _id ->(           
                if !_flag_l then          
                    fprintf stdf "%d.\t%Li\t%s@,\n" i _id _brand#name
                else
                    fprintf stdf "%d.\t%s@,\n" i _brand#name
            )
        ) _brands ; 
        fprintf stdf "@]there is %d brands displayed\n" (List.length _brands); 
    
    method remove_brand ()= 
        match (!_brand_name, !_brand_id) with
        | "",None -> fprintf stdf "Incorrect arguments@[<hov4>\n\
                       remove_brand name_of_brand\n\
                       remove_brand -id  id_of_brand@]\n"
        | _name, None -> 
            if engine#brand#remove ~name:(Some _name) () then
                fprintf stdf "Brand <%s> has been successfully deleted.\n" _name
            else
                fprintf stdf "Brand <%s> can not be deleted.\n" _name
        | "", ((Some x ) as _id) ->
            if  engine#brand#remove ~id: _id () then
                fprintf stdf "Brand <%Li> has been successfully deleted.\n" x
            else
                fprintf stdf "Brand <%Li> can not be deleted.\n" x
        | _name, ((Some x) as _id) ->
            if engine#brand#remove ~name:(Some _name) ~id:_id ()  then
                fprintf stdf "Brand <%Li>:<%s> has been successfully deleted.\n" x _name
            else
                fprintf stdf "Brand <%Li>:<%s> can not be deleted.\n" x _name
 
    method process action =    
        match (String.lowercase_ascii action) with
        |"add_brand"->(
            cli#register_command self#add_brand;
            true
        )
        |"list_brands"->(
            cli#register_option ("-l", Arg.Set _flag_l, "use a long listing format same kind as ls -l") ;
            cli#register_callback self#list_brand;
            true
        )
        |"remove_brand"->(
            cli#register_option ("-f", Arg.Set _flag_f, "force the deletion of the brands even if it is linked to others kinds of objects (ex : stock_entries)");
            cli#register_option ("-id", Arg.Int (fun _id ->_brand_id:=(Some (Int64.of_int _id))), "targeted brand's rowid");
            cli#register_command (fun _name -> _brand_name:=_name);
            cli#register_callback self#remove_brand;
            true
                                                          
        )
        |"update_brand"->(
            cli#register_callback (fun () -> 
                fprintf stdf "Nothing to do with the current data model.\n");
            true
        )
        |_->false 
                
end

let brand_name = ref ""

let flag_force = ref false                   

(* name : name of the brand to add if it does not exist*)      
let add_brand name=
    let _brand = engine#brand#add name in
    match _brand#rowid with
    |None -> Printf.printf "Insertion failed, please see the log.\n"    
    |Some _id -> Printf.printf "Brand <%Li>:<%s> has been successfully added.\n" 
                   _id  _brand#name  

let update_brand x= 
    raise (Not_implemented "update_brand") 

(* callbakc_remove name_of_brand flag_f*)      
let callback_remove ()=
match !flag_force with
|true -> ()(*engine.brand.remove_force name and print output*) 
|false ->  ()(*engine.brand.remove name and print output*)   

(* actions' handler provided by this module*)
let handlers action =    
    match (String.lowercase_ascii action) with
    |"add_brand"->(
       register_command add_brand;
       true
    )     
    |"list_brand"->(
       (*On enregistre rien ici parce qu'on attends pas d'autres paramètres anonymes*)  
       (*engine.list_brand and print it*)
       true
    )
    |"remove_brand"->(
       register_command (fun _name -> brand_name:=_name);
       register_option ("-f",Arg.Set flag_force,"r");
       register_callback callback_remove;
       true
    )
    |"update_brand"->(
       register_command update_brand;
       true
    )

    |_->false 
   
