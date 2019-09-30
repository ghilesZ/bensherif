type 'a lol = {elm : 'a * 'a lol} [@@unboxed]

let singleton x =
  let rec res = {elm=x,res} in
  res

let make n =
  let rec aux acc = function
  | 0 -> acc
  | x -> aux {elm=x,acc} (x-1)
  in
  let rec res = {elm=n,res} in
  aux res (n-1)

let rec iter f ({elm=x,rest} as cur) =
  f x;
  if rest != cur then iter f rest

let _ =
  make (Sys.argv.(1) |> int_of_string)
  (* |> iter (fun x -> Format.printf "%i\n" x) *)
