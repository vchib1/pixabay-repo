extension IntExtension on int {
  String formatToK() {
    if (this >= 1000000) {
      double res = (this / 1000000);
      int fractionNum = this % 1000000 == 0 ? 0 : 1;
      return '${res.toStringAsFixed(fractionNum)}M';
    } else if (this >= 1000) {
      double res = (this / 1000);
      int fractionNum = this % 1000 == 0 ? 0 : 1;
      return '${res.toStringAsFixed(fractionNum)}k'; // Format as 'k' for thousands
    }
    return toString();
  }
}
