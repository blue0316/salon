void main() {
double a=5;
print(a.toString());
}

output(String message, k) {
  List<String> arr = message.split(" ");
  String result = "";
  int length = 0;

  for (String word in arr) {
    length = length + word.length;
    if (result != "") {
      length++;
    }
    if (length >= k) return result;

    if (result == "") {
      result = word;
    } else {
      result = result + " " + word;
    }



  }

  return result;
}
