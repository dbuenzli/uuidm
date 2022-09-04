open B0_kit.V000

(* OCaml library names *)

let uuidm = B0_ocaml.libname "uuidm"
let cmdliner = B0_ocaml.libname "cmdliner"

(* Libraries *)

let uuidm_lib =
  let srcs = Fpath.[`Dir (v "src")] in
  let requires = [] in
  B0_ocaml.lib uuidm ~doc:"The uuidm library" ~srcs ~requires

(* Tests *)

let test_exe src ~doc =
  let src = Fpath.v src in
  let srcs = Fpath.[`File src] in
  let meta = B0_meta.(empty |> tag test) in
  let requires = [ uuidm ] in
  B0_ocaml.exe (Fpath.basename ~strip_ext:true src) ~srcs ~doc ~meta ~requires

let test = test_exe "test/test.ml" ~doc:"Test suite"
let perf = test_exe "test/perf.ml" ~doc:"Test performance"

let uuidtrip =
  let doc = "Generates universally unique identifiers (UUIDs)" in
  let srcs = Fpath.[`File (v "test/uuidtrip.ml")] in
  let requires = [uuidm; cmdliner] in
  B0_ocaml.exe "uuidtrip" ~public:true ~doc ~srcs ~requires

(* Packs *)

let default =
  let meta =
    B0_meta.empty
    |> B0_meta.(add authors) ["The uuidm programmers"]
    |> B0_meta.(add maintainers)
       ["Daniel Bünzli <daniel.buenzl i@erratique.ch>"]
    |> B0_meta.(add homepage) "https://erratique.ch/software/uuidm"
    |> B0_meta.(add online_doc) "https://erratique.ch/software/uuidm/doc/"
    |> B0_meta.(add licenses) ["ISC"]
    |> B0_meta.(add repo) "git+https://erratique.ch/repos/uuidm.git"
    |> B0_meta.(add issues) "https://github.com/dbuenzli/uuidm/issues"
    |> B0_meta.(add description_tags)
      ["uuid"; "codec"; "org:erratique"]
    |> B0_meta.tag B0_opam.tag
    |> B0_meta.add B0_opam.depopts ["cmdliner", ""]
    |> B0_meta.add B0_opam.conflicts
      [ "cmdliner", {|< "1.1.0"|}]
    |> B0_meta.add B0_opam.depends
      [ "ocaml", {|>= "4.08.0"|};
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
