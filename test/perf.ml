(* This code is in the public domain *)

let str = Printf.sprintf
let exec = Filename.basename Sys.executable_name

let main () = 
  let usage = 
    str "Usage: %s <options>\n\
         UUID performance tests.\n\
         Options:" exec
  in
  let n = ref 10_000_000 in       
  let v = ref `V4 in
  let cstr = ref false in
  let options = [ 
    "-n", Arg.Set_int n,
    "number of ids to generate.";
    "-str", Arg.Set cstr,
    "convert UUIDs to strings (defaults to false).";
    "-r", Arg.Unit (fun () -> v := `V4),
    "random based UUID version 4 (default).";
    "-md5", Arg.Unit (fun () -> v := `V3 (Uuidm.ns_dns,"www.example.org")),
    "MD5 name based UUID version 3.";    
    "-sha1", Arg.Unit (fun () -> v := `V5 (Uuidm.ns_dns,"www.example.org")),
    "SHA-1 name based UUID version 5."; ]
  in
  Arg.parse options (fun _ -> ()) usage;
  let v = !v in
  let f = 
    if !cstr then fun v -> ignore (Uuidm.to_string (Uuidm.create v)) else 
    fun v -> ignore (Uuidm.create v)
  in
  for i = 1 to !n do f v done

let () = main ()
