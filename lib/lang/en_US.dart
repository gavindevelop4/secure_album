import 'package:secure_album/enums.dart';

Map<String, String> enUS = {
  // Common
  'Confirm': 'Confirm',
  'Cancel': 'Cancel',
  'TitleText': 'Title',

  // Album Page
  'AlbumTitle': 'Album',
  'SettingsTitle': 'Settings',
  'NewAlbumTitleText': 'New Album Title',
  'NewAlbumTitleDescription': 'Enter a name for this album',

  // AlbumAddActionType
  AlbumAddActionType.newAlbum.toString(): 'New Album',
  AlbumAddActionType.importFromPhotos.toString(): 'Import from Photos',
  AlbumAddActionType.importFromFiles.toString(): 'Import from Files',
};
