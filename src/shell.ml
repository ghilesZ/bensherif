let build name =
  let oc = open_out "tester.sh" in
  output_string oc "#!/bin/bash\n";
  oc

let send_line sh str =
  output_string sh (str^"\n")
