open Arg
open Misc

exception Found
let rec command action =
    let handlers = [Brand.handlers] in
    

    try    
      List.iter (fun f ->( if (f action) then raise Found else () )) handlers
    with
    |Found -> ()
    |a-> raise a          
       
(**
    Commande line structure :
        action arguments
*)
let () =
    let stdf = Format.std_formatter and errf = Format.err_formatter in
    annon_fun_ref := command; 
    parse_dynamic spec (fun x -> !annon_fun_ref x) "Coucou";
    callback ()


