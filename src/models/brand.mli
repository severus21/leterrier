open Model

class cBrand :
  string ->
  ?rowid:int64 option->
  unit -> object
    inherit cModel
     
    val _name : string

    method name : string

    method eq : cBrand -> bool 
    method str:string                        
end
