(*---------------------------------------------------------------------------
   Copyright (c) 2024 The uuidm programmers. All rights reserved.
   SPDX-License-Identifier: ISC
  ---------------------------------------------------------------------------*)

open B0_testing

let test_id ?__POS__ u us =
  let us = Uuidm.of_string us |> Test.get_some ?__POS__ in
  let trip = Uuidm.to_string u |> Uuidm.of_string |> Test.get_some ?__POS__ in
  Test.eq ?__POS__ (module Uuidm) u trip;
  Test.eq ?__POS__ (module Uuidm) u us;
  ()

let test_constants () =
  Test.test "Uuidm UUID constants" @@ fun () ->
  test_id ~__POS__ Uuidm.nil     "00000000-0000-0000-0000-000000000000";
  test_id ~__POS__ Uuidm.max     "ffffffff-ffff-ffff-ffff-ffffffffffff";
  test_id ~__POS__ Uuidm.ns_dns  "6ba7b810-9dad-11d1-80b4-00c04fd430c8";
  test_id ~__POS__ Uuidm.ns_url  "6ba7b811-9dad-11d1-80b4-00c04fd430c8";
  test_id ~__POS__ Uuidm.ns_oid  "6ba7b812-9dad-11d1-80b4-00c04fd430c8";
  test_id ~__POS__ Uuidm.ns_X500 "6ba7b814-9dad-11d1-80b4-00c04fd430c8";
  ()

let test_mixed_endian () =
  Test.test "Uuidm.{of,to}_mixed_endian_bytes" @@ fun () ->
  test_id ~__POS__
    (Uuidm.unsafe_of_bytes (Uuidm.to_mixed_endian_bytes Uuidm.ns_X500))
    "14B8a76b-ad9d-d111-80b4-00c04fd430c8";
  test_id ~__POS__
    (Uuidm.of_mixed_endian_bytes (Uuidm.to_bytes Uuidm.ns_X500)
     |> Test.get_some ~__POS__)
    "14B8a76b-ad9d-d111-80b4-00c04fd430c8";
  ()

let test_gen () =
  Test.test "Uuid.v* constructors" @@ fun () ->
  test_id ~__POS__
    (Uuidm.v3 Uuidm.ns_dns "www.widgets.com")
    "3D813CBB-47FB-32BA-91DF-831E1593AC29";
  test_id ~__POS__
    (Uuidm.v3 Uuidm.ns_dns "www.example.org")
	  "0012416f-9eec-3ed4-a8b0-3bceecde1cd9";
  test_id ~__POS__
    (Uuidm.v3 Uuidm.ns_dns "www.example.com")
	  "5df41881-3aed-3515-88a7-2f4a814cf09e";
  test_id ~__POS__
    (Uuidm.v4
       (Bytes.of_string
          "\x91\x91\x08\xF7\x52\xD1\x33\x20\x5B\xAC\xF8\x47\xDB\x41\x48\xA8"))
    "919108f7-52d1-4320-9bac-f847db4148a8";
  test_id ~__POS__
    (Uuidm.v5 Uuidm.ns_dns "www.widgets.com")
	  "21F7F8DE-8051-5B89-8680-0195EF798B6A";
  test_id ~__POS__
    (Uuidm.v5 Uuidm.ns_dns "www.example.org")
	  "74738ff5-5367-5958-9aee-98fffdcd1876";
  test_id ~__POS__
    (Uuidm.v5 Uuidm.ns_dns "www.example.com")
	  "2ed6657d-e927-568b-95e1-2665a8aea6a2";
  test_id ~__POS__
    (Uuidm.v7_ns ~t_ns:Int64.(add (mul 1_000_000L 0x1020_3040_5060L) 213135L)
       ~rand_b:(Bytes.of_string "\x12\x34\x56\x78\x9a\xbc\xde\xf0"))
    "10203040-5060-7369-9234-56789abcdef0";
  test_id ~__POS__
    (Uuidm.v7
       ~t_ms:0x017F22E279B0L ~rand_a:0xCC3 ~rand_b:0x18C4DC0C0C07398FL)
    "017F22E2-79B0-7CC3-98C4-DC0C0C07398F";
  ()

let main () =
  Test.main @@ fun () ->
  test_constants ();
  test_mixed_endian ();
  test_gen ();
  ()

let () = if !Sys.interactive then () else exit (main ())
