(*---------------------------------------------------------------------------
   Copyright (c) 2024 The uuidm programmers. All rights reserved.
   SPDX-License-Identifier: ISC
  ---------------------------------------------------------------------------*)

open B0_testing

let test_uuid ?__POS__:pos version ?time_ms u us =
  Test.block ?__POS__:pos @@ fun () ->
  let us = Uuidm.of_string us |> Test.get_some ~__POS__ in
  let trip = Uuidm.to_string u |> Uuidm.of_string |> Test.get_some ~__POS__ in
  let variant = Uuidm.variant u in
  Test.eq (module Uuidm) u trip ~__POS__;
  Test.eq (module Uuidm) u us ~__POS__ ;
  if Uuidm.equal u Uuidm.nil then Test.int variant 0x0 ~__POS__ else
  if Uuidm.equal u Uuidm.max then Test.int variant 0xF ~__POS__ else
  Test.holds (8 <= variant && variant <= 0xB) ~__POS__;
  Test.int (Uuidm.version u) version ~__POS__;
  Test.option ~some:Test.Eq.int64 (Uuidm.time_ms u) time_ms ~__POS__;
  ()

let test_constructors () =
  Test.test "Uuid.v* constructors" @@ fun () ->
  test_uuid ~__POS__ 3
    (Uuidm.v3 Uuidm.ns_dns "www.widgets.com")
    "3D813CBB-47FB-32BA-91DF-831E1593AC29";
  test_uuid ~__POS__ 3
    (Uuidm.v3 Uuidm.ns_dns "www.example.org")
	  "0012416f-9eec-3ed4-a8b0-3bceecde1cd9";
  test_uuid ~__POS__ 3
    (Uuidm.v3 Uuidm.ns_dns "www.example.com")
	  "5df41881-3aed-3515-88a7-2f4a814cf09e";
  test_uuid ~__POS__ 4
    (Uuidm.v4
       (Bytes.of_string
          "\x91\x91\x08\xF7\x52\xD1\x33\x20\x5B\xAC\xF8\x47\xDB\x41\x48\xA8"))
    "919108f7-52d1-4320-9bac-f847db4148a8";
  test_uuid ~__POS__ 5
    (Uuidm.v5 Uuidm.ns_dns "www.widgets.com")
	  "21F7F8DE-8051-5B89-8680-0195EF798B6A";
  test_uuid ~__POS__ 5
    (Uuidm.v5 Uuidm.ns_dns "www.example.org")
	  "74738ff5-5367-5958-9aee-98fffdcd1876";
  test_uuid ~__POS__ 5
    (Uuidm.v5 Uuidm.ns_dns "www.example.com")
	  "2ed6657d-e927-568b-95e1-2665a8aea6a2";
  test_uuid ~__POS__ 7 ~time_ms:0x1020_3040_5060L
    (Uuidm.v7_ns ~t_ns:Int64.(add (mul 1_000_000L 0x1020_3040_5060L) 213135L)
       ~rand_b:0x123456789abcdef0L)
    "10203040-5060-7369-9234-56789abcdef0";
  test_uuid ~__POS__ 7 ~time_ms:0x017F22E279B0L
    (Uuidm.v7
       ~t_ms:0x017F22E279B0L ~rand_a:0xCC3 ~rand_b:0x18C4DC0C0C07398FL)
    "017F22E2-79B0-7CC3-98C4-DC0C0C07398F";
  test_uuid ~__POS__ 8
    (Uuidm.v8
       "\x24\x89\xE9\xAD\x2E\xE2\x0E\x00\x0E\xC9\x32\xD5\xF6\x91\x81\xC0")
    "2489E9AD-2EE2-8E00-8EC9-32D5F69181C0";
  ()

let test_constants () =
  Test.test "Uuidm UUID constants" @@ fun () ->
  test_uuid ~__POS__ 0 Uuidm.nil     "00000000-0000-0000-0000-000000000000";
  test_uuid ~__POS__ 0xF Uuidm.max   "ffffffff-ffff-ffff-ffff-ffffffffffff";
  test_uuid ~__POS__ 1 Uuidm.ns_dns  "6ba7b810-9dad-11d1-80b4-00c04fd430c8";
  test_uuid ~__POS__ 1 Uuidm.ns_url  "6ba7b811-9dad-11d1-80b4-00c04fd430c8";
  test_uuid ~__POS__ 1 Uuidm.ns_oid  "6ba7b812-9dad-11d1-80b4-00c04fd430c8";
  test_uuid ~__POS__ 1 Uuidm.ns_X500 "6ba7b814-9dad-11d1-80b4-00c04fd430c8";
  ()

let test_mixed_endian () =
  Test.test "Uuidm.{of,to}_mixed_endian_binary_string" @@ fun () ->
  test_uuid ~__POS__ 13
    (Uuidm.unsafe_of_binary_string
       (Uuidm.to_mixed_endian_binary_string Uuidm.ns_X500))
    "14B8a76b-ad9d-d111-80b4-00c04fd430c8";
  test_uuid ~__POS__ 13
    (Uuidm.of_mixed_endian_binary_string (Uuidm.to_binary_string Uuidm.ns_X500)
     |> Test.get_some ~__POS__)
    "14B8a76b-ad9d-d111-80b4-00c04fd430c8";
  ()

let main () =
  Test.main @@ fun () ->
  test_constructors ();
  test_constants ();
  test_mixed_endian ();
  ()

let () = if !Sys.interactive then () else exit (main ())
