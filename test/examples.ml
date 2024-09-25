(*---------------------------------------------------------------------------
   Copyright (c) 2024 The uuidm programmers. All rights reserved.
   SPDX-License-Identifier: CC0-1.0
  ---------------------------------------------------------------------------*)

(* Code from the quick start *)

let uuid = Uuidm.v4_gen (Random.State.make_self_init ())
let () = print_endline (Uuidm.to_string (uuid ()))
let () = print_endline (Uuidm.to_string (uuid ()))

let feed_id ~feed_id = "urn:uuid:" ^ (Uuidm.to_string feed_id)
let entry_id ~feed_id ~rfc3339_stamp =
  "urn:uuid:" ^ (Uuidm.to_string @@ Uuidm.v5 feed_id rfc3339_stamp)

let uuid_monotonic =
  let now_ms () = Int64.of_float (Unix.gettimeofday () *. 1000.) in
  Uuidm.v7_monotonic_gen ~now_ms (Random.State.make_self_init ())

let rec uuid () = match uuid_monotonic () with
| None -> (* Too many UUIDs generated in a ms *) Unix.sleepf 1e-3; uuid ()
| Some uuid -> uuid

let () = print_endline (Uuidm.to_string (uuid ()))
let () = print_endline (Uuidm.to_string (uuid ()))
