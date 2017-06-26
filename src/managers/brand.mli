open Sqlite3

open Models.Brand

class cBrandManager : db -> object
    inherit Manager.cManager

    method on_destroy : unit
    
    method get : string -> cBrand option
    method private insert :  cBrand -> unit 
    method private update :  cBrand -> unit 
    method store : cBrand -> unit
    method remove : ?id:int64 option -> ?name:string option-> unit ->bool                           
    method ls : cBrand list
end

val unittests : unit -> OUnit2.test
