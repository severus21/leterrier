open Managers.Brand
open Models.Brand

class cBrandHandler db = object
    val _manager = new cBrandManager db 

    method add (name:string) =
        let _brand = new cBrand name () in
        _manager#store _brand;
        _brand 
        
    method ls =
        _manager#ls      

    method remove ?(id=None) ?(name=None) ()=
        _manager#remove ~name:name ~id:id ()

    method on_destroy =
        _manager#on_destroy

end
