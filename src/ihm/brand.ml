open Misc
open Engine  

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
   
