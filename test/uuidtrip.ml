(*---------------------------------------------------------------------------
   Copyright (c) 2008 The uuidm programmers. All rights reserved.
   SPDX-License-Identifier: ISC
  ---------------------------------------------------------------------------*)

let strf = Printf.sprintf

let gen version ns name upper binary =
  let u = match version with
  | `V3 -> Uuidm.v3 ns name
  | `V4 -> Uuidm.v4_gen (Random.State.make_self_init ()) ()
  | `V5 -> Uuidm.v5 ns name
  in
  let s = match binary with
  | true -> Uuidm.to_bytes u
  | false -> strf "%s\n" (Uuidm.to_string ~upper u)
  in
  let () = Out_channel.set_binary_mode stdout binary in
  print_string s; flush stdout

(* Command line interface *)

open Cmdliner

let version =
  let v3 =
    let doc =
      "Generate a MD5 name based UUID version 3, see option $(b,--name)." in
    `V3, Arg.info ["md5"] ~doc
  in
  let v4 =
    let doc = "Generate a random based UUID version 4 (default)." in
    `V4, Arg.info ["r"; "random"] ~doc
  in
  let v5 =
    let doc =
      "Generate a SHA-1 name based UUID version 5, see option $(b,--name)." in
    `V5, Arg.info ["sha1"] ~doc
  in
  Arg.(value & vflag `V4 [v3; v4; v5])

let ns =
  let ns_arg =
    let parse s = match Uuidm.of_string s with
    | None -> `Error (strf "%S: could not parse namespace UUID" s)
    | Some ns -> `Ok ns
    in
    parse, Uuidm.pp
  in
  let doc = "Namespace UUID for name based UUIDs (version 4 or 5).
             Defaults to the DNS namespace UUID."
  in
  Arg.(value & opt ns_arg Uuidm.ns_dns & info ["ns"; "namespace"] ~doc)

let name_ =
  let doc = "Name for name based UUIDs (version 4 or 5)." in
  Arg.(value & opt string "www.example.org" & info ["name"] ~doc)

let upper =
  let doc = "Output hexadecimal letters in uppercase" in
  Arg.(value & flag & info ["u"; "uppercase"] ~doc)

let binary =
  let doc = "Output the UUID as its 16 bytes binary representation."
  in
  Arg.(value & flag & info ["b"; "binary"] ~doc)

let cmd =
  let doc = "Generates universally unique identifiers (UUIDs)" in
  let man = [
    `S "DESCRIPTION";
    `P "$(tname) generates 128 bits universally unique identifiers version
        3, 5 (name based with MD5, SHA-1 hashing) and 4 (random based)
        according to RFC 4122.";
    `P "Invoked without any option, a random based version 4 UUID is
        generated and written on stdout.";
    `S "SEE ALSO";
    `P "P. Leach et al. A universally unique identifier (UUID) URN Namespace,
        2005. $(i, http://tools.ietf.org/html/rfc4122)";
    `S "BUGS";
    `P "This program is distributed with the Uuidm OCaml library.
        See %%PKG_HOMEPAGE%% for contact information."; ]
  in
  Cmd.v (Cmd.info "uuidtrip" ~version:"%%VERSION%%" ~doc ~man) @@
  Term.(const gen $ version $ ns $ name_ $ upper $ binary)

let main () = Cmd.eval cmd

let () = if !Sys.interactive then () else exit (main ())
