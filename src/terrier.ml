open Managers.Brand
open Models.Brand
open Engine


let () =
    Printf.printf "*********************** Terrier is up  ***********************\n";
    let db = Sqlite3.db_open "db/stock.db" in
    let brandManager = new cBrandManager db in
    let brand = new cBrand "coucou2" () in
    let brand2 = new cBrand "coucou" () in
    let brand3 = new cBrand "coucou" () in
    
    brandManager#store brand;  
    brandManager#store brand;  
    brandManager#store brand2;  
    brandManager#store brand3;
    let brands =brandManager#ls in
    (match brand3#rowid with
      |Some(e) -> Printf.printf "id store 3 %Li\n" e
      |None->());              
    List.iter (fun x -> Printf.printf "%s\n" x#name) brands ;
     
    brandManager#on_destroy;

    if not (Sqlite3.db_close db) then 
        Printf.printf "The DB is busy :\n \
        \t* There is maybe some undestroied/unclosed managers\n";
    ignore (engine#brand#add "arg");
    
    Format.fprintf Format.std_formatter "@[<hov 10>Hello@ %s@,%a @]" "dezfjfffffffffffffffffffff" (fun ppf name -> Format.fprintf ppf "%s@fuck" name) "HELLLO";    
