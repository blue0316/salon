// ignore_for_file: constant_identifier_names

enum ThemeType {
  Default, // 0
  Glam, // 1
  GlamBarbershop, // 2
  GlamGradient, // 3
  Barbershop, // 4
  GlamLight, // 5
}

ThemeType getThemeTypeEnum(String? themeId) {
  switch (themeId) {
    case '0':
      return ThemeType.Default;
    case '1':
      return ThemeType.Glam;
    case '2':
      return ThemeType.GlamBarbershop;
    case '3':
      return ThemeType.GlamGradient;
    case '4':
      return ThemeType.Barbershop;
    case '5':
      return ThemeType.GlamLight;

    default:
      return ThemeType.Default;
  }
}

// 
// http://localhost:65331/home/salon?id=GnnJxrDooWaGjByaY0WH
