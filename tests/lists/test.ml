module Tweeked = struct
  type 'a lst= {elm : 'a * 'a lst} [@@unboxed]

  let singleton x =
    let rec res = {elm=x,res} in
    res

  let make n =
    let rec aux acc = function
      | 0 -> acc
      | x -> aux {elm=x,acc} (x-1)
    in
    aux (singleton n) (n-1)

  let rec iter f ({elm=x,rest} as cur) =
    f x;
    if rest != cur then iter f rest


  type input = int

  type output = unit

  let name = "tweeked"

  let parse = int_of_string

  let initial = 100000

  let vary x = x + 100000

  let compute n = make n |> ignore

  let compile = string_of_int
end

module Regular = struct
  type 'a linked =
    {truc: 'a; next: 'a linked option}

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

  type input = int

  type output = unit

  let name = "lists"

  let parse = int_of_string

  let initial = 100000

  let vary x = x + 100000

  let compute n = make n |> ignore

  let compile = string_of_int
end

module CMP = Implem.Compare(Tweeked)(Regular)

let _ = CMP.go ()
