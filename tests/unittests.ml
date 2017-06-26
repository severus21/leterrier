let () = 
    let tests = OUnit2.test_list [
        Managers.Tests.unittests ();
        Models.Tests.unittests ();
    ] in
    
    OUnit2.run_test_tt_main tests   
