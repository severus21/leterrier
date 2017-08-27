(** Here, we define the specific representation of a row of the brand table.
    @author severus21
    @version 0.0.0*)

open Model

(** An instance of the brand model represents a specific SQL row of the brand table. This is used in order to interface the SQL part with the Ocaml one.
    @param name - name of the row(i.e the brand)
    @param rowid - inner id of the row if it is already defined.
*)
class cBrand :
  string ->
  ?rowid:int64 option->
  unit -> object
    inherit cModel
    
    (* The name of the brand, represented by the current instance*)   
    val _name : string
    
    (** The name setter
        @param name - name to used*)
    method name : string
    
    (** It defines a structural identity
        @param brand - the other model to compare with
        @return true if they are structurally  equal.
  *)  
    method eq : cBrand -> bool 
    method str:string                        
end
