import 'package:get/get.dart';
import 'package:secure_album/lang/en_US.dart';
import 'package:secure_album/lang/zh_TW.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'zh_TW': zhTW,
      };
}
