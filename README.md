# renameQobus
rename www.qobuz.com downloaded files to a more appropriate layout.

Qobuz downloaded files are in this format : 
```
[ArtistName]-[AlbumName]\[numDisc]-[noSong]-[ArtistName]-[songName]-LLS.flac
```
And each name composing this path is filled with '_' in place of ' '.

This program converts a freshly downloaded qobuz folder to this kind of path :
```
[ArtistName]\[AlbumName]\[noSong]-[songName].flac
```
Also the 'numDisc' has been taken into account when renaming the 'noSong' to have all song in the right order without the 'numDisc'.
# Example

This downloaded folder :
```
The_xx-I_See_You
|__ 01-01-The_xx-Dangerous-LLS.flac
|__ 01-02-The_xx-Say_Something_Loving-LLS.flac
|__ 01-03-The_xx-Lips-LLS.flac
|__ 01-04-The_xx-A_Violent_Noise-LLS.flac
|__ 01-05-The_xx-Performance-LLS.flac
|__ 01-06-The_xx-Replica-LLS.flac
|__ 01-07-The_xx-Brave_For_You-LLS.flac
|__ 01-08-The_xx-On_Hold-LLS.flac
|__ 01-09-The_xx-I_Dare_You-LLS.flac
|__ 01-10-The_xx-Test_Me-LLS.flac
|__ The_xx-I_See_You.jpg
```
Will be converted to :
```
The xx
|__ I See You
   |__ 01-Dangerous.flac
   |__ 02-Say Something Loving.flac
   |__ 03-Lips.flac
   |__ 04-A Violent Noise.flac
   |__ 05-Performance.flac
   |__ 06-Replica.flac
   |__ 07-Brave For You.flac
   |__ 08-On Hold.flac
   |__ 09-I Dare You.flac
   |__ 10-Test Me.flac
   |__ The_xx-I_See_You.jpg
```
# Usage

The Dart SDK should be installed, you can find it here: https://www.dartlang.org/install

This program is launched from command line, supposing dart is in your PATH:
```
$ dart renameQobuz/bin/main.dart [directory containing qobuz files] 
```
