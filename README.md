Uuidm — Universally unique identifiers (UUIDs) for OCaml
========================================================

Uuidm is an OCaml library implementing 128 bits universally unique
identifiers version 3, 5 (named based with MD5, SHA-1 hashing), 4
(random based) and 7 (time and random based) according to [RFC 9562].

Uuidm has no dependency. It is distributed under the ISC license.

[RFC 9562]: https://www.rfc-editor.org/rfc/rfc9562

Homepage: <https://erratique.ch/software/uuidm>  

## Installation

Uuidm can be installed with `opam`:

    opam install uuidm

If you don't use `opam` consult the [`opam`](opam) file for build
instructions.

## Documentation

The documentation can be consulted [online] or via `odig doc uuidm`.

Questions are welcome but better asked on the [OCaml forum][ocaml-forum]
than on the issue tracker.

[online]: https://erratique.ch/software/uuidm/doc/
[ocaml-forum]: https://discuss.ocaml.org/

## Sample programs

The [`uuidtrip`] tool generates UUIDs and outputs them on stdout.

See also code in the [`test`] directory.

[`uuidtrip`]: test/uuidtrip.ml
[`test`]: test/
