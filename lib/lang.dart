import 'package:get/get.dart';
import 'package:secure_album/lang/en_us.dart';
import 'package:secure_album/lang/zh_tw.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'zh_TW': zhTW,
      };
}
