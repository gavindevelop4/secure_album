import 'dart:io';

import 'package:secure_album/enums.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class RoleController extends GetxController {
  Rx<Role> role = Role.fake.obs;
  Rx<bool> roleFolderInitialized = false.obs;

  void setRole(Role newRole) {
    role.value = newRole;
  }

  Future<void> initAllRoleFolder() async {
    await initRoleFolder(Role.admin);
    await initRoleFolder(Role.decoy);
    await initRoleFolder(Role.fake);
    roleFolderInitialized.value = true;
  }

  Future<void> initRoleFolder(Role role) async {
    final roleString = role.toShortString();
    final _path = await localPath;
    final Directory _folder = Directory('$_path/$roleString/');
    if (await _folder.exists()) {
      return;
    }
    await _folder.create(recursive: true);
  }

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
