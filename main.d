import 
  std.stdio,
  std.algorithm,
  std.array,
  std.string,
  std.conv,
  std.format,
  std.file,
  std.regex;

void main(string[] args) {

  if (args.length < 3) { writeln("parameter error."); return; }
  string fileName = args[1].chomp;
  if (!fileName.exists) { writeln("file not found."); return; }

  string[] lines = readText(fileName).chomp.splitLines; 

  Emp[] emp = lines.toEmp;  
  emp.sort!(Emp.favSort);

  size_t minimam = to!size_t(args[2]);
  Emp[][string] groups = emp.grouping(minimam); 

  foreach (k, g; groups) {
    std.stdio.write(k, ":");
    writeln(g.map!(e=>e.empNo));
  }
}

struct Emp {
  string empNo;
  string[] fav;
  static bool empNoSort(Emp e1, Emp e2) {
    return e1.empNo < e2.empNo;
  }
  static bool favSort(Emp e1, Emp e2) {
    return e1.fav[0] < e2.fav[0];
  }
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

Emp[][string] grouping(Emp[] emps, size_t minRequire) {
  Emp[][string] groups;
  Emp[] duckweeds = emps.dup;
  size_t[string][] favCount;

  for (size_t order = 0; !duckweeds.empty; order++) {
    favCount ~= countFavs(duckweeds, order);
    Emp[] lones;
    foreach (i, emp ; duckweeds) {
      if (emp.fav.length <= order) 
        groups["nothing"] ~= emp;
      else if (emp.fav[order] in favCount[order] &&
               favCount[order][emp.fav[order]] >= minRequire ||
               emp.fav[order] in groups &&
               groups[emp.fav[order]].length >= minRequire)
        groups[emp.fav[order]] ~= emp;
      else
        lones ~= emp;
    }
    duckweeds = lones;
  }
  return groups;
}

size_t[string] countFavs(Emp[] emps, size_t order) {
  size_t[string] favCount;
  foreach (emp; emps) {
    if (emp.fav.length > order) favCount[emp.fav[order]]++;
  }
  return favCount;
}
