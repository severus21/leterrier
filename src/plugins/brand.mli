open Ihm.Parser

class cBrandPlugin :<brand:Handlers.Brand.cBrandHandler;..> -> cliParser ->(Format.formatter*Format.formatter) -> object
    method add_brand : string -> unit
    method list_brand : unit -> unit                               
    method remove_brand : unit -> unit 
    method process : string -> bool                               
end
