
import 'dart:io';

main(List<String> args) {
  print(args);
  Directory d = new Directory.fromUri(new Uri.directory(args[0], windows: true));
  d.listSync().forEach((FileSystemEntity f){
    if (f.path.endsWith(".flac")){
      String filename = "" + f.uri.pathSegments.last;
      print("renaming $filename");
      filename = filename.substring(3, filename.length-("-LLS.flac".length));
      filename = filename.substring(0, 3) + filename.substring(filename.indexOf("-", 4)+1, filename.length);
      filename = filename.replaceAll("_", " ");
      print("to $filename");
      f.renameSync(f.uri.pathSegments.getRange(0, f.uri.pathSegments.length-1).join("\\") + "\\$filename" + ".flac");
    }
  });
}
