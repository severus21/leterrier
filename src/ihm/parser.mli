exception Not_implemented of string 
exception Unknown_action of string
exception To_many_arguments                               


class cliParser : object
    method to_many_arguments : unit 

    method register_option :(Arg.key* Arg.spec * Arg.doc) -> unit

    method register_options :(Arg.key * Arg.spec * Arg.doc) list -> unit
    method register_command : (string -> unit) -> unit 

    method register_callback : (unit -> unit) -> unit

    method callback : unit
    method run : unit                                                
end                    
