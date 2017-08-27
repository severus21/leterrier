(** In this file we define the basic command line parser with some inner state. This is based on top of Arg
    @author severus21
    @version 0.0.0 
*)

exception Not_implemented of string 
exception Unknown_action of string
exception To_many_arguments                               

(** Handle the parsing of the command line with inner states,
  the command line format follows the following patterns where
  anonymous parameter are denoted by anon_i and named parameter are denoted by param_i :
  "action --name_1 param_1 anon_1... --name_n param_n anon_k"
*)
class cliParser : object
    
    (** Add an anonymous argument specification to the parser list spec. 
        @param opt (see Arg)      
      *)
    method register_option :(Arg.key* Arg.spec * Arg.doc) -> unit

    (** Add an order list of anonymous argument specifications to the parser list
        @param opts - list of specification (see Arg)
    *)
    method register_options :(Arg.key * Arg.spec * Arg.doc) list -> unit

    (** Register the handler for the next anonymous arguments.
    N.B : the first anonymous argument is action
    
      @param f - string -> unit the handler of the anonymous argument
      *)
     method register_command : (string -> unit) -> unit 

    (** A convenient function in order to stop parsing if there is to many anonymous parameter. It is the only way to limit anonymous parameter for now*)
    method to_many_arguments : unit 

    (** Register the callback function i.e the function that should be called at the end of the parsing
        @param f - unit -> unit it is the callback function*)
    method register_callback : (unit -> unit) -> unit

    (** Execute the callback function*)    
    method callback : unit

    (** Process the command line and at the end execute the callback function*)                    
    method run : unit                                                
end                    
