String cutString(String text, {int cut = 10, String change = "xxxx"}) {
  if (text.length <= cut) {
    return text;
  } else {
    return text.substring(0, cut) + change;
  }
}
