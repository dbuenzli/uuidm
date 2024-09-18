open B0_kit.V000

(* OCaml library names *)

let b0_std = B0_ocaml.libname "b0.std"
let cmdliner = B0_ocaml.libname "cmdliner"
let uuidm = B0_ocaml.libname "uuidm"

(* Libraries *)

let uuidm_lib = B0_ocaml.lib uuidm ~srcs:[`Dir ~/"src"]

(* Tests *)

let test ?(requires = []) = B0_ocaml.test ~requires:(uuidm :: requires)
let perf = test ~/"test/perf.ml" ~run:false ~doc:"Test Uuidm performance"
let examples = test ~/"test/examples.ml" ~run:false ~doc:"Sample code"
let test_uuidm =
  test ~/"test/test_uuidm.ml" ~requires:[b0_std] ~doc:"Test Uuidm"


(* Tools *)

let uuidtrip =
  let doc = "Generates universally unique identifiers (UUIDs)" in
  let srcs = [`File ~/"test/uuidtrip.ml"] in
  let requires = [uuidm; cmdliner] in
  B0_ocaml.exe "uuidtrip" ~public:true ~doc ~srcs ~requires

(* Packs *)

let default =
  let meta =
    B0_meta.empty
    |> ~~ B0_meta.authors ["The uuidm programmers"]
    |> ~~ B0_meta.maintainers ["Daniel Bünzli <daniel.buenzl i@erratique.ch>"]
    |> ~~ B0_meta.homepage "https://erratique.ch/software/uuidm"
    |> ~~ B0_meta.online_doc "https://erratique.ch/software/uuidm/doc/"
    |> ~~ B0_meta.licenses ["ISC"]
    |> ~~ B0_meta.repo "git+https://erratique.ch/repos/uuidm.git"
    |> ~~ B0_meta.issues "https://github.com/dbuenzli/uuidm/issues"
    |> ~~ B0_meta.description_tags ["uuid"; "codec"; "org:erratique"]
    |> B0_meta.tag B0_opam.tag
    |> ~~ B0_opam.depopts ["cmdliner", ""]
    |> ~~ B0_opam.conflicts [ "cmdliner", {|< "1.3.0"|}]
    |> ~~ B0_opam.depends
      [ "ocaml", {|>= "4.14.0"|};
        "ocamlfind", {|build|};
        "ocamlbuild", {|build|};
        "topkg", {|build & >= "1.0.3"|};
      ]
    |> B0_meta.add B0_opam.build
      {|[["ocaml" "pkg/pkg.ml" "build" "--dev-pkg" "%{dev}%"
          "--with-cmdliner" "%{cmdliner:installed}%"]]|}
  in
  B0_pack.make "default" ~doc:"uuidm package" ~meta ~locked:true @@
  B0_unit.list ()
