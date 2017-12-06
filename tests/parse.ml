module T = Yaml_types.M
open Rresult

let pp_event e pos =
  print_endline (Sexplib.Sexp.to_string_hum (Yaml.Stream.Event.sexp_of_t e)) 

let test () =
  let open R.Infix in
  Bos.OS.File.read (Fpath.v "anchor.yml") >>= fun buf ->
  Yaml.Stream.parser () >>= fun t ->
  let rec iter_until_done fn =
    Yaml.Stream.do_parse t >>= fun (e, pos) ->
    match e with 
    | Yaml.Stream.Event.Nothing -> R.ok ()
    | event -> fn event pos; iter_until_done fn in
  Yaml.Stream.set_input_string t buf;
  iter_until_done pp_event

let _ =
  match test () with
  | Ok _ -> ()
  | Error (`Msg m) ->
      prerr_endline m;
      exit 1
