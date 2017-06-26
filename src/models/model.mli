class virtual cModel : int64 option ->object
    val mutable _rowid : int64 option

    method rowid : int64 option
    method set_rowid : int64 option -> unit 

    method virtual str : string                                         
end
