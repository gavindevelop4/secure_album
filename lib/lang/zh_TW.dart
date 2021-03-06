import 'package:secure_album/enums.dart';

Map<String, String> zhTW = {
  // Common
  'Confirm': '確定',
  'Cancel': '取消',
  'TitleText': '名稱',
  'Delete': '刪除',
  'Edit': '編輯',
  'QuestionMark': '？',

  // Album Page
  'AlbumTitle': '相薄',
  'SettingsTitle': '設定',
  'NewAlbumTitleText': '新增相簿名稱',
  'NewAlbumTitleDescription': '輸入新相簿的名字',
  'AlbumNameRepeatWarning': '相簿名稱不能重複',
  'DeleteAlbum': '刪除相簿',
  'ConfirmToDeleteAlbum': '確認刪除相簿',

  // Gallery Screen
  'ChoosePhoto': '選擇相片',

  // AlbumAddActionType
  AlbumAddActionType.newAlbum.toString(): '新增相簿',
  AlbumAddActionType.importFromPhotos.toString(): '從相片庫導入',
  AlbumAddActionType.importFromFiles.toString(): '從文件導入',
};
