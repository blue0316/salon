extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

extension InitialsExtension on String {
  String get initials {
    // Split the full name into individual words
    List<String> words = this.split(' ');

    // Initialize an empty string to store the initials
    String initials = '';

    // Iterate through the words and append the first character of each word to the initials
    for (String word in words) {
      if (word.isNotEmpty) {
        initials += word[0].toUpperCase();
      }
    }

    return initials;
  }
}

extension DateHelper on DateTime {
  String formatDate() {
    DateTime today = DateTime.now();
    // final formatter = DateFormat(dateFormatter);

    if (month == today.month && year == today.year && day == today.day) {
      return "Today";
    }
    return "$month.$day.$year";
  }

  bool isSameDate(DateTime other) {
    // debugPrint(other.toString())

    return month == other.month && year == other.year && day == other.day;
  }

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }
}
