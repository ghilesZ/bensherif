module type I = sig
  type input
  type output
  val name    : string
  val initial : input
  val vary    : input -> input
  val compute : input -> output
  val compile_input : input -> string
end

module Compare(A:I)(B:I with type input = A.input
                         and type output = A.output) = struct

  let build_input_list n =
    let rec aux (last_a,last_b) = function
      | 1 -> [last_a,last_b]
      | n ->
        let next_a = A.vary last_a in
        let next_b = B.vary last_b in
        (next_a,next_b)::(aux (next_a,next_b) (n-1))
    in aux (A.initial,B.initial)


  let compile_inputs shell l =
    List.iter (fun i -> ) l

end
