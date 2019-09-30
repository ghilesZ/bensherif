type 'a lol =
  {truc: 'a; next: 'a lol option}

let make n =
  let rec aux acc = function
  | 0 -> acc
  | x -> aux {truc=x; next = Some acc} (x-1)
  in aux {truc=n; next = None} (n-1)

let rec iter f {truc; next} =
  f truc;
  match next with
  | None -> ()
  | Some n -> iter f n

let _ =
  make (Sys.argv.(1) |> int_of_string)
  |> iter (fun _ -> ())
