(** @author severus21
    @version 0.0.0*) 

class virtual cModel rowid =object(self)
    val mutable _rowid:int64 option = rowid

    method rowid = _rowid
    method set_rowid id = 
        _rowid <- id;
         
    method str =  Printf.sprintf "cModel rowid:%s" (match _rowid with
                                                |None -> "<None>"
                                                |Some _id -> Printf.sprintf"%Li" _id         )     
end
