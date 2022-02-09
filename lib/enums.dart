enum Role {
  admin,
  decoy,
  fake,
}

extension ParseToString on Role {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

enum AlbumMode {
  view,
  edit,
}

enum AlbumAddActionType {
  newAlbum,
  importFromPhotos,
  importFromFiles,
}
