(*---------------------------------------------------------------------------
   Copyright (c) 2024 The uuidm programmers. All rights reserved.
   SPDX-License-Identifier: CC0-1.0
  ---------------------------------------------------------------------------*)

let uuid = Uuidm.v4_gen (Random.State.make_self_init ())
let () = print_endline (Uuidm.to_string (uuid ()))
let () = print_endline (Uuidm.to_string (uuid ()))

let feed_id ~feed_id = "urn:uuid:" ^ (Uuidm.to_string feed_id)
let entry_id ~feed_id ~rfc3339_stamp =
  "urn:uuid:" ^ (Uuidm.to_string @@ Uuidm.v5 feed_id rfc3339_stamp)
