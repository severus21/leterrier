(*This the leterrier launcher, for now it is designed in order to be used in a one shot command line manner
    @author severus21
    @version 0.0.0
*)

open Managers.Brand
open Models.Brand
open Engine
open Ihm
(*Il faudra faire le tri entre error critique et erreur non critique pour l'instant tout se propage jusqu'à la fonction main et est considéré comme critique. *)
exception Plg_found   
let () =
    let stdf = Format.std_formatter and errf = Format.err_formatter in
    let cparser = new Parser.cliParser in

    let plg_brand = new Plugins.Brand.cBrandPlugin engine cparser (stdf,errf) in

    let _init action =
        let fcts = [plg_brand#process] in
        try    
          List.iter (fun f ->( if (f action) then raise Plg_found else () )) fcts 
        with
        |Plg_found -> ()
        |a-> raise a  
    in

    cparser#register_command _init;
    try
        cparser#run 
    with e ->(    
        let msg = Printexc.to_string e and 
                    stack = Printexc.get_backtrace () in
        Format.fprintf stdf "A critical error occured for more details see the std_error channel.\n";  
        Format.fprintf errf "Error : %s%s\n" msg stack 
    )
