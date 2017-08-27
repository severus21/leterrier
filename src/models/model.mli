(** Here, we define the generic Model, a model represents the structure of a row of a specific SQL database. Each model will inherit from this one.
    @author severus21
    @verison 0.0.0
*)

(** This is the general model class in order to define generic behaviour of the row, mainly the handling of the inner id.
    @param db - the SQlite3 database used*)                                      
class virtual cModel : int64 option ->object
    (* This is the inner id of the row, this id is unique in a per classes(i.e table) basis. This id is given by the SQL database therefore it is not NONE iff the current model is related to a SQL row*)
    val mutable _rowid : int64 option
    
    (** The getter related to the inner id
       @return the inner id if exists*) 
    method rowid : int64 option
    (** The setter related to the inner id, it is manly used after the first insertion.
        @param rowid - 
    *)
    method set_rowid : int64 option -> unit 
    
    (** Basic formatter of the model
        @return outputs a string representation of the current instance*)
    method virtual str : string                                         
end
