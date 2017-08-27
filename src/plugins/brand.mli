(** This the ihm plugin dedicated to cli processing of the brand part. 
    @authors severus21
    @version 0.0.0
  *)

open Ihm.Parser

(**  This the ihm plugin dedicated to cli processing of the brand part. It parse the command line after the action part. And trigger the correct processing and eventually output the results.
    @param engine - an engine (see the engine module) that at least include brand handler getter.
    @param cli - the cliparser (set just after the action, already used to trigger the usage of this specific plugin
    @param (stdf, errf) - the std output and the std error output*)
class cBrandPlugin :<brand:Handlers.Brand.cBrandHandler;..> -> cliParser ->(Format.formatter*Format.formatter) -> object

    (** Processes the add_brand action, it expects the name -a non optional but anonymous cli parameter.
        @param name - name of the brand to add*)
    method add_brand : string -> unit

    (** Processes the list_brand action*)                               
    method list_brand : unit -> unit     
    
    (** Processes the remove_brand action, the inner id or the name - of the brand to delete - will be passed as optional named parameters.*)
    method remove_brand : unit -> unit 
                                    
    (** This function takes as input the action of the cli, and if this action match ones of the internal one it calls the related methods(ex : the add_brand one
        @param action - the cli action part*)                                
    method process : string -> bool                               
end
