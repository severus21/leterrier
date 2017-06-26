open Model

class cBrand  (name:string) ?rowid:(rowid=None) ()= object(self)
    inherit cModel rowid
     
    val mutable _name = name
    
    method name = _name 
                    
    method eq (brand:cBrand)=
        _name = brand#name && _rowid = brand#rowid

    method str = 
        Printf.sprintf "cBrand rowid:%s name:%s" (match _rowid with
                                                |None -> "<None>"
                                                |Some _id -> Printf.sprintf"%Li" _id         )  _name
end
