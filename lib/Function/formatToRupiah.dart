String formatToRupiah(int balance, {int? type}) {
  String formattedBalance = balance.toString();
  List<String> parts = [];

  while (formattedBalance.length > 3) {
    parts.add(formattedBalance.substring(formattedBalance.length - 3));
    formattedBalance =
        formattedBalance.substring(0, formattedBalance.length - 3);
  }
  parts.add(formattedBalance);

  String text = type == 0
      ? "-Rp. "
      : type == 1
          ? "+Rp. "
          : type == 2
              ? "-Rp. "
              : "Rp. ";

  return "${text}${parts.reversed.join('.')}";
}
