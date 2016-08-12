(*---------------------------------------------------------------------------
   Copyright (c) 2008 Daniel C. Bünzli. All rights reserved.
   Distributed under the ISC license, see terms at the end of the file.
   %%NAME%% %%VERSION%%
  ---------------------------------------------------------------------------*)

let str = Printf.sprintf
let exec = Filename.basename Sys.executable_name
let pr_err s = Printf.eprintf "%s:%s\n" exec s
let err_ns_parse = " failed to parse namespace uuid"

let main () =
  let usage =
    str "Usage: %s [OPTION]...\n\
         \ Outputs an UUID.\n\
         Options:" exec
  in
  let bin = ref false in
  let up = ref false in
  let v = ref `V4 in
  let ns = ref (Uuidm.to_string Uuidm.ns_dns) in
  let name = ref "www.example.org" in
  let options = [
    "-r", Arg.Unit (fun () -> v := `V4),
    " Output a random based UUID version 4 (default)";
    "-md5", Arg.Unit (fun () -> v := `V3),
    " Output a MD5 name based UUID version 3";
    "-sha1", Arg.Unit (fun () -> v:= `V5),
    " Output a SHA-1 name based UUID version 5";
    "-ns", Arg.Set_string ns,
    "<uuid> Namespace UUID for name based UUIDs (defaults to DNS namespace)";
    "-name", Arg.Set_string name,
    "<name> Name for name based UUIDs (defaults to www.example.org)";
    "-b", Arg.Set bin,
    " Output result in binary";
    "-u", Arg.Set up,
    " Output hexadecimal letters in uppercase" ]
  in
  try
    Arg.parse (Arg.align options) (fun _ -> ()) usage;
    let version = match !v with
    | `V4 -> `V4
    | v ->
	match Uuidm.of_string !ns with
	| None -> failwith err_ns_parse
	| Some u -> if v = `V3 then `V3 (u, !name) else `V5 (u, !name)
    in
    let u = Uuidm.create version in
    let s = if !bin then Uuidm.to_bytes u else Uuidm.to_string ~upper:!up u in
    print_endline s
  with
  | Failure e -> (pr_err e; exit 1)

let () = main ()

(*---------------------------------------------------------------------------
   Copyright (c) 2008 Daniel C. Bünzli

   Permission to use, copy, modify, and/or distribute this software for any
   purpose with or without fee is hereby granted, provided that the above
   copyright notice and this permission notice appear in all copies.

   THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
   WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
   MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
   ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
   WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
   ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
   OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  ---------------------------------------------------------------------------*)
