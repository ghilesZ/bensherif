module type I = sig
  type input
  type output
  val name    : string
  val parse   : string -> input
  val initial : input
  val vary    : input -> input
  val compute : input -> output
  val compile : input -> string
end

module Compare(A:I)(B:I with type input = A.input
                         and type output = A.output) = struct

  (* supposing that both compute function work with the same input*)
  let build_input_list n =
    let rec aux last_a = function
      | 1 -> [A.compile last_a]
      | n ->
        let next_a = A.vary last_a in
        ((A.compile last_a))::(aux next_a (n-1))
    in aux A.initial n

  let buildNrun n =
    let l = build_input_list n in
    let name = Shell.build A.name B.name l in
    Sys.command ("chmod +x "^name) |> ignore;
    Sys.command ("./"^name) |> ignore

  let is_integer i =
    try int_of_string i |> ignore; true
    with Failure _ -> false

  let go =
    fun () ->
    try
      match Sys.argv with
      | [| _ ; opt; i|] when is_integer i ->
        if opt = A.name then A.compute (A.parse i) |> ignore
        else if opt = B.name then B.compute (B.parse i) |> ignore
        else failwith ("input unrecognized: "^opt^" "^i)
      | [| _ ; n |] when is_integer n ->
        int_of_string n |> buildNrun
      | _ -> failwith "please enter the number of inputs for the script generation"
    with Failure s ->
      Format.fprintf Format.err_formatter "internal error on%s\nerror:%s"
        (Array.fold_left (fun acc i -> acc^" "^i) "" Sys.argv) s
end
