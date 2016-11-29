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
  // support for multiple disc
  bool hasOtherDisc = false;
  int currentMaxNoSong = 0;
  do {
	hasOtherDisc = false;
	d.listSync().forEach((FileSystemEntity f) {
		String filename = "" + f.uri.pathSegments.last;
		if (f.path.endsWith(".flac")) {
			String noDisc = filename.substring(0, 2);
			String noSong = filename.substring(3, 5);
			if (noDisc == "01")
				currentMaxNoSong++;
			if (noDisc == "02")
				hasOtherDisc = true;
		}
	});
	d.listSync().forEach((FileSystemEntity f) {
		String filename = "" + f.uri.pathSegments.last;
		if (f.path.endsWith(".flac")) {
			String noDisc = filename.substring(0, 2);
			String noSong = filename.substring(3, 5);
			String restOfName = filename.substring(5);
			int numDisc = int.parse(noDisc);
			int numSong = int.parse(noSong);
			if (noDisc == "02") {
				numSong += currentMaxNoSong;
				noSong = numSong < 10 ? "0$numSong" : "$numSong";
				f.renameSync(f.uri.pathSegments.getRange(0, f.uri.pathSegments.length - 1).join("\\") + "\\01-$noSong-$restOfName");
			}
			if (numDisc > 2){
				numDisc--;
				noDisc = numDisc < 10 ? "0$numDisc" : "$numDisc";
				f.renameSync(f.uri.pathSegments.getRange(0, f.uri.pathSegments.length - 1).join("\\") + "\\$noDisc-$noSong-$restOfName");
			}
		}
	});
  } while(hasOtherDisc);

  String dirName = d.uri.pathSegments[d.uri.pathSegments.length-2];
  String artistName = dirName.substring(0, dirName.indexOf('-')).replaceAll('_', ' ');
  String albumName = dirName.substring(dirName.indexOf('-') + 1, dirName.length).replaceAll('_', ' ');
  String ArtistPath = d.uri.pathSegments.getRange(0, d.uri.pathSegments.length-2).join("\\") + "\\" + artistName + "\\";
  String AlbumPath = ArtistPath + albumName + "\\";

  // Move already present files in artist folder to a temp folder
  Directory previousArtist = new Directory.fromUri(new Uri.directory(ArtistPath, windows: true));
  String tempArtistPath = null;
  if (previousArtist.existsSync()){
    // path from .../[ArtistName] to .../____temp____
    tempArtistPath =
        previousArtist.uri.pathSegments.getRange(0, previousArtist.uri.pathSegments.length-2).join("\\")
            + "\\" + "____temp____" + "\\";
    previousArtist.renameSync(tempArtistPath);
  }

  d.renameSync(ArtistPath);
  Directory album = new Directory.fromUri(new Uri.directory(AlbumPath, windows: true));
  album.createSync();
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
    }
  });

  // Move back previous files into the artist folder
  if (tempArtistPath != null) {
    previousArtist = new Directory.fromUri(new Uri.directory(tempArtistPath, windows: true));
    previousArtist.listSync().forEach((FileSystemEntity f) {
      int pathLen = f.uri.pathSegments.length;
      if (FileSystemEntity.isDirectorySync(f.path)){
        String correctedPath = f.uri.pathSegments.getRange(0, pathLen - 3).join("\\")
            + "\\$artistName\\"
            + f.uri.pathSegments.getRange(pathLen - 2, pathLen - 1).join()
            + "\\";
        //print(correctedPath);
        f.renameSync(correctedPath);
      }
      else if (FileSystemEntity.isFileSync(f.path)){
        String correctedPath = f.uri.pathSegments.getRange(0, pathLen - 2).join("\\")
            + "\\$artistName\\"
            + f.uri.pathSegments.getRange(pathLen - 1, pathLen).join()
            + "\\";
        //print(correctedPath);
        f.renameSync(correctedPath);
      }
    });
    previousArtist.deleteSync();
  }
}

void showHelp(){
  print("usage : dart main.dart [path to folder containing flac files]");
}
