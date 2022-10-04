import 'package:bbblient/src/models/cat_sub_service/services_model.dart';

import '../models/cat_sub_service/category_service.dart';

class Translation {
  static String getCatName({required CategoryModel cat, required String langCode}) {
    final String? _tr = translate(map: cat.translations, langCode: langCode);
    if (_tr != null) {
      return _tr;
    } else {
      return cat.categoryName;
    }
  }

  static String getServiceName({required ServiceModel service, required String langCode}) {
    final String? _tr = translate(map: service.translations, langCode: langCode);
    if (_tr != null) return _tr;
    if (service.serviceName != null) return service.serviceName;
    return '';
  }

  //translate into current selected language
  static String? translate({required Map? map, required String langCode}) {
    if (map != null) {
      if (map.containsKey(langCode)) {
        return map[langCode];
      } else {
        return map['en'];
      }
    }
    return null;
  }
}
