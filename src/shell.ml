(* FileSystem stuff *)
(********************)

(* tests if the file/directory 'name' is available or already exists *)
(* return 'name' or a computed name that is available *)
let is_available name ext =
  let rec loop name cpt =
    let namext = name^(string_of_int cpt)^ext in
    if Sys.file_exists namext then loop name (cpt+1)
    else namext
  in
  let namext = name^ext in
  if Sys.file_exists namext then loop (name^"_bshf") 0
  else namext

(* Printing utilities *)
(**********************)

(* indent increments or decrements the current level of indentation *)
(* send_line prints a strint and a '\n' wrt the current level of identation *)
let indent,send_line =
  let current_level = ref 0 in
  (fun i -> current_level := !current_level + i),
  (fun oc str ->
     let indent = String.make (4* (!current_level)) ' ' in
     output_string oc (indent^str^"\n")
  )

(* empty line for pretty output *)
let newline oc = send_line oc ""

(* bash function printing utility *)
let send_function oc name body =
  send_line oc ("function "^name^"(){");
  indent 1;
  List.iter (send_line oc) body;
  indent (-1);
  send_line oc "}"

(* Script generation *)
(*********************)

let header oc nameA nameB datafile =
  send_line oc "#!/bin/bash";
  send_line oc "# This script was generated using bensherif";
  newline oc;
  send_function oc "measure"
    ["res=$((/usr/bin/time -f \"%M %e\" "^Sys.executable_name^" $1 $2) 2>&1)";
     "res=$(echo \"$res\" | tr ',' '.')";
     "echo \"$res\""];
  newline oc;
  send_function oc "plot"
    ["gnuplot -e \"set terminal png size 800,600; set output '$1';\\";
     "set autoscale x; set autoscale y; set logscale x; set logscale y;\\";
     "plot \\\""^datafile^"\\\" using 1:$2 title '"^nameA^"' with lines,\\";
     "\\\""^datafile^"\\\" using 1:$3 title '"^nameB^"' with lines\"";
    ]

let mainloop oc nameA nameB data time memory inputs shellname=
  send_line oc "TIMEFORMAT='%3R'";
  send_line oc "cpt=1";
  let (nb,arr) = List.fold_left (fun (n,s) i -> n+1,s^"\""^i^"\" ") (0,"") inputs in
  send_line oc ("declare -a arr=("^arr^")");
  send_line oc ("for i in ${arr[@]}");
  send_line oc "do";
  indent 1;
  send_line oc ("varA=$(measure "^nameA^" $i)");
  send_line oc ("varB=$(measure "^nameB^" $i)");
  send_line oc ("echo \"$i $varA $varB\" >> "^data);
  send_line oc ("echo \"$cpt/"^(string_of_int nb)^": input $i processed. \"");
  send_line oc "cpt=$((cpt + 1))";
  indent (-1);
  send_line oc "done";
  newline oc;
  send_line oc ("plot "^memory^" 2 4");
  send_line oc ("plot "^time^" 3 5");
  newline oc;
  send_line oc ("rm "^shellname) (* self destructing script *)

let build nameA nameB inputs =
  let shellname = is_available "tester" ".sh" in
  let oc = open_out shellname in
  let datafilename = is_available "results" ".data" in
  let png_time = is_available "time" ".png" in
  let png_memory = is_available "memory" ".png" in
  header oc nameA nameB datafilename;
  mainloop oc nameA nameB datafilename png_time png_memory inputs shellname;
  close_out oc;
  shellname
