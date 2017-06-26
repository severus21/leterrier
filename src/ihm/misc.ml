exception Not_implemented of string (*move to misc*)
exception Unknown_action of string
exception To_many_arguments                               



let spec = ref []
let callback_ref = ref (fun () -> Printf.printf "callback\n")             
let annon_fun_ref = ref (fun (x:string)->Printf.printf "%s" x)

let to_many_arguments () = 
    annon_fun_ref := (fun x -> raise To_many_arguments) 

let register_option (opt:(Arg.key * Arg.spec * Arg.doc)) =
    spec := List.rev (opt::!spec)

let register_options (opts:(Arg.key * Arg.spec * Arg.doc) list) =
    spec := List.rev (opts @ !spec)

let register_command f = 
    annon_fun_ref := fun x ->(f x)

let register_callback f =
    callback_ref := f

let callback () = !callback_ref ()                       
