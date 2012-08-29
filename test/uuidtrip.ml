(*---------------------------------------------------------------------------
   Copyright %%COPYRIGHT%%. All rights reserved.
   Distributed under a BSD3 license, see license at the end of the file.
   %%NAME%% version %%VERSION%%
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
  Copyright %%COPYRIGHT%%
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:
        
  1. Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

  2. Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the
     distribution.

  3. Neither the name of Daniel C. Bünzli nor the names of
     contributors may be used to endorse or promote products derived
     from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  ---------------------------------------------------------------------------*)
