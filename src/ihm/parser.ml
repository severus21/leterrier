(** @author severus21
    @version 0.0.0 
*)

exception Not_implemented of string 
exception Unknown_action of string
exception To_many_arguments                               

class cliParser = object(self)
    (*cf. module Ocaml Arg*)                      
    val spec:(Arg.key * Arg.spec * Arg.doc) list ref = ref []
                                                          
    (*the function that should be called at the end of the parsing*)  
    val callback_ref = ref (fun () -> Printf.printf "No callback\n")

    (*the function that takes care of the anonymous parameters, 
        it can be change (and should be change) at runtime*)                     
    val anon_fun_ref = ref (fun (x:string)->Printf.printf "%s" x)
     
    method register_option opt =
        spec := List.rev (opt::!spec)
    
    method register_options opts =
        spec := List.rev (opts @ !spec)
    
    method register_command f = 
        anon_fun_ref := fun x ->(f x)
    
    method to_many_arguments = 
        anon_fun_ref := (fun x -> raise To_many_arguments) 
                                  
    method register_callback f =
        callback_ref := f

    method callback = !callback_ref ()
    
    method run = 
        Arg.parse_dynamic spec (fun x -> !anon_fun_ref x) "Coucou";
        self#callback

end                    
