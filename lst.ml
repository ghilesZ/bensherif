let make n =
  let rec aux acc = function
  | 0 -> acc
  | x -> aux (x::acc) (x-1)
  in
  let rec res = [n] in
  aux res (n-1)

let _ =
  make (Sys.argv.(1) |> int_of_string)
  |> List.iter (fun _ -> ())
