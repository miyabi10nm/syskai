import 
  std.stdio,
  std.algorithm,
  std.array,
  std.string,
  std.conv,
  std.format,
  std.file,
  std.regex;

void main() {

  write("file name?:");
  string fileName = readln.chomp;
  if (!fileName.exists) { write("file not found."); return; }

  string[] lines = readText(fileName).chomp.splitLines; 

  Emp[] emp = lines.toEmp;  
  emp.sort!favSort;
  
  Emp[][string] groups = emp.grouping; 
  foreach (k, g; groups) {
    std.stdio.write(k, ":");
    writeln(g.map!(e=>e.empNo));
  }
}

struct Emp {
  string empNo;
  string[] fav;
}

Emp[] toEmp(string[] lines) {
  Emp[] emp = [];
  foreach (line; lines) emp ~= line.parse;
  return emp;
}

Emp parse(string line) {
  string[] arr = line.split(",");
  return arr.length <= 1 ?  Emp(arr[0]) : Emp(arr[0], arr[1..$]);
}

bool empNoSort(Emp e1, Emp e2) {
  return e1.empNo < e2.empNo;
}

bool favSort(Emp e1, Emp e2) {
  return e1.fav[0] < e2.fav[0];
}

Emp[][string] grouping(Emp[] emps) {
  Emp[][string] groups;
  string key = null;

  foreach (emp ; emps) {
    if (key != emp.fav[0]) key = emp.fav[0];
    groups[key] ~= emp;
  }
  return groups;
}
