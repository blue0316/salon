// ignore_for_file: constant_identifier_names

enum ThemeType {
  DefaultLight, // 0
  DefaultDark, // 1
  Glam, // 2
  GlamBarbershop, // 3
  GentleTouchDark, // 4
  Barbershop, // 5
  GentleTouch, // 6
  CityMuseLight, // 7
  CityMuseDark, // 8
}

ThemeType getThemeTypeEnum(String? themeId) {
  switch (themeId) {
    case '0':
      return ThemeType.DefaultLight;
    case '1':
      return ThemeType.DefaultDark;
    case '2':
      return ThemeType.Glam;
    case '3':
      return ThemeType.GlamBarbershop;
    case '4':
      return ThemeType.GentleTouchDark;
    case '5':
      return ThemeType.Barbershop;
    case '6':
      return ThemeType.GentleTouch;
    case '7':
      return ThemeType.CityMuseLight;
    case '8':
      return ThemeType.CityMuseDark;

    default:
      return ThemeType.DefaultLight;
  }
}

// 
// http://localhost:65331/home/salon?id=GnnJxrDooWaGjByaY0WH
