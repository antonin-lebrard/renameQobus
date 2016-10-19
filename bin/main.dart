import 'dart:io';

main(List<String> args) {
  print(args);
  if (args[0] == "-h" || args[0] == "--help"){
	showHelp();
	return;
  }
  // [ArtistName]-[AlbumName]
  Directory d = new Directory.fromUri(new Uri.directory(args[0], windows: true));
  if (!d.existsSync()){
     print("${args[0]} does not exist");
     return;
  }
  String dirName = d.uri.pathSegments[d.uri.pathSegments.length-2];
  String artistName = dirName.substring(0, dirName.indexOf('-')).replaceAll('_', ' ');
  String albumName = dirName.substring(dirName.indexOf('-') + 1, dirName.length).replaceAll('_', ' ');
  String ArtistPath = d.uri.pathSegments.getRange(0, d.uri.pathSegments.length-2).join("\\") + "\\" + artistName + "\\";
  String AlbumPath = ArtistPath + albumName + "\\";
  d.renameSync(ArtistPath);
  Directory album = new Directory.fromUri(new Uri.directory(AlbumPath, windows: true));
  album.createSync();
  List<FileSystemEntity> filesToMove = new List();
  d = new Directory.fromUri(new Uri.directory(ArtistPath, windows: true));
  d.listSync().forEach((FileSystemEntity f) {
    if (FileSystemEntity.isFileSync(f.path)) {
      String filename = "" + f.uri.pathSegments.last;
      if (f.path.endsWith(".flac")) {
        // 0[noDisc]-[noSong][noSong]-[Artist]-[SongName]-LLS.flac
        print("renaming $filename");
        // [noSong][noSong]-[Artist]-[SongName]
        filename = filename.substring(3, filename.length - ("-LLS.flac".length));
        // [noSong][noSong]-[SongName]
        filename = filename.substring(0, 3) + filename.substring(filename.indexOf("-", 4) + 1, filename.length);
        filename = filename.replaceAll("_", " ");
        filename += ".flac";
        print("to $filename");
      }
      f.renameSync(f.uri.pathSegments.getRange(0, f.uri.pathSegments.length - 1).join("\\") + "\\$albumName\\$filename");
      filesToMove.add(f);
    }
  });
}

void showHelp(){
  print("usage : dart main.dart [path to folder containing flac files]");
}
