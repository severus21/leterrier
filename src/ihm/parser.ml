exception Not_implemented of string 
exception Unknown_action of string
exception To_many_arguments                               


class cliParser = object(self)
    val spec:(Arg.key * Arg.spec * Arg.doc) list ref = ref []
    val callback_ref = ref (fun () -> Printf.printf "No callback\n")             
    val annon_fun_ref = ref (fun (x:string)->Printf.printf "%s" x)
     
    method to_many_arguments = 
        annon_fun_ref := (fun x -> raise To_many_arguments) 

    method register_option opt =
        spec := List.rev (opt::!spec)

    method register_options opts =
        spec := List.rev (opts @ !spec)
 
    method register_command f = 
        annon_fun_ref := fun x ->(f x)

    method register_callback f =
        callback_ref := f

    method callback = !callback_ref ()

    method run = 
        Arg.parse_dynamic spec (fun x -> !annon_fun_ref x) "Coucou";
        self#callback

end                    
