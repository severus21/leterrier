open Misc

let entry_name = ref ""  
let entry_ref = ref ""
let entry_brand = ref ""

let spec=[
    ("-ref", Arg.Set_string entry_ref, "t") ;
    ("-brand", Arg.Set_string entry_brand, "t")
]

let handlers action =   
    match (String.lowercase_ascii action) with
    |"add_entry"->(
        register_command (fun _name -> entry_name:=_name);
        register_options spec;
        register_callback (fun () -> 
            match !entry_name with
            |"" ->Arg.usage spec "add_entry name_of_the_entry and maybe a subset of the following optional parameters"
            |_name ->(
                (*let entry = engin.entry_manager.add ...
                    entry.print
                *)
                 Printf.printf "entry is name:%s\n
            ref:%s\nbrand:%s\n" _name !entry_ref !entry_brand
             )
        );
        true
    )     
    |_->false 
   
