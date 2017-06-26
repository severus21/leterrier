open Managers.Brand
open Models.Brand

class cBrandHandler db = object
    val _manager = new cBrandManager db 

    method add (name:string) =
        let _brand = new cBrand name () in
        try 
            _manager#store _brand;
            _brand 
        with
        |e->(
            (*output the correct error message, said to the engine if it is a critical error or not and log it*)
            failwith "TODO"
        )
        
              
    method on_destroy =
        _manager#on_destroy

end
