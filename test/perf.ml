(* This code is in the public domain *)

let str = Printf.sprintf
let exec = Filename.basename Sys.executable_name

let main () =
  let usage =
    str "Usage: %s [OPTION]...\n\
         \ UUID performance tests.\n\
         Options:" exec
  in
  let n = ref 10_000_000 in
  let v = ref `V4 in
  let cstr = ref false in
  let options = [
    "-n", Arg.Set_int n,
    "<int> Number of ids to generate";
    "-str", Arg.Set cstr,
    " Also convert UUIDs to strings";
    "-r", Arg.Unit (fun () -> v := `V4),
    " Random based UUID version 4 (default)";
    "-md5", Arg.Unit (fun () -> v := `V3 (Uuidm.ns_dns,"www.example.org")),
    " MD5 name based UUID version 3";
    "-sha1", Arg.Unit (fun () -> v := `V5 (Uuidm.ns_dns,"www.example.org")),
    " SHA-1 name based UUID version 5"; ]
  in
  Arg.parse (Arg.align options) (fun _ -> ()) usage;
  let uuid = match !v with
  | `V4 -> Uuidm.v4_gen (Random.State.make_self_init ())
  | `V3 (ns, n) -> fun () -> Uuidm.v3 ns n
  | `V5 (ns, n) -> fun () -> Uuidm.v5 ns n
  in
  let f = match !cstr with
  | true -> fun version -> ignore (Uuidm.to_string (uuid ()))
  | false -> fun version -> ignore (uuid ())
  in
  for i = 1 to !n do f v done

let () = main ()
