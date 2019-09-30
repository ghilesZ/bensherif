type 'a t = Cons of ('a * 'a t) [@@unboxed]

let init x =
  let rec res = Cons(x, res) in
  res

let add elm cy =
  Cons(elm,cy)

let rec iter f (Cons(cur,next) as cy) =
  f cur;
  if next != cy then iter f next

let make n =
  let rec aux acc = function
  | 0 -> acc
  | x -> aux (Cons(x,acc)) (x-1)
  in
  let rec res = (Cons(n,res)) in
  aux res (n-1)

let _ =
  make (Sys.argv.(1) |> int_of_string)
  |> iter (fun _ -> ())
