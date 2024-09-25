
- Add `Uuidm.v7`, create time and random based V7 UUIDs using client provided
  random bytes and time. Thanks to Robin Newton for the patch (#14).
- Add `Uuidm.v8` to create V8 custom UUIDs.
- Add `Uuidm.max` the RFC 9569 Max UUID.
- Add `Uuidm.{variant,version,time_ms}` UUID property accessors.
- Change `Uuidm.v4_gen` generation strategy.
- Call `Random.State.make_self_init` lazily rather than during module
  initialisation.
- Documentation: clarified that `Random` based UUID generators are not stable 
  accross OCaml and UUID versions.
- Deprecate `Uuidm.v`, use individual version constructors instead.
- Deprecate type `Uuidm.version`.
- Deprecate `Uuidm.pp_string` to `Uuidm.pp'`.
- Deprecate `Uuidm.{to,of}_[mixed_endian_]bytes` to 
  `Uuidm.{to,of}_[mixed_endian_]binary_string` (follow `Stdlib` terminology).
- Require OCaml 4.14.
- `uuidtrip` set standard output to binary when outputing binary uuids.

v0.9.8 2022-02-09 La Forclaz (VS)
---------------------------------

- Add deprecation warnings on what is already deprecated.
- Require OCaml 4.08 and support 5.00 (Thanks to Kate @ki-ty-kate
  for the patch).


v0.9.7 2019-03-08 La Forclaz (VS)
---------------------------------

- Add `Uuidm.v4`, creates random based V4 UUID using client provided
  random bytes (#8). Thanks to François-René Rideau for suggesting and
  David Kaloper Meršinjak for additional comments.
- Add `Uuidm.{to,of}_mixed_endian_bytes`. Support for UEFI and
  Microsoft's binary serialization of UUIDs.


v0.9.6 2016-08-12 Zagreb
------------------------

- Safe-string support. Thanks to Josh Allmann for the help.
- Deprecate `Uuidm.create` in favor of `Uuidm.v`.
- Deprecate `Uuidm.print` in favor of `Uuidm.pp_string`
- Add `Uuidm.pp`.
- Relicensed from BSD3 to ISC.
- Build depend on topkg.
- `uuidtrip` uses `Cmdliner` which becomes an optional dependency of
  the package. The command line interface is unchanged except for long
  options which have to be written with a double dash. Binary output
  no longer adds an ending newline.


v0.9.5 2012-08-05 Lausanne
--------------------------

- OASIS 0.3.0 support.


v0.9.4 2012-03-15 La Forclaz (VS)
---------------------------------

- OASIS support.
- New functions `Uuidm.v3` and `Uuidm.v5` that generate directly these 
  kinds of UUIDs.
- New function `Uuidm.v4_gen` returns a function that generates
  version 4 UUIDs with a client provided random state. Thanks to Lauri
  Alanko for suggesting that `Random.make_self_init` may be too weak
  for certain usages.


v0.9.3 2008-08-01 Lausanne
--------------------------

- POSIX compliant build shell script.


v0.9.2 2008-07-30 Lausanne 
--------------------------

- Support for debian packaging. Thanks to Sylvain Le Gall.


v0.9.1 2008-06-18 Lausanne
--------------------------

- Minor internal cleanings.


v0.9.0 2008-06-11 Lausanne
--------------------------

- First release.
