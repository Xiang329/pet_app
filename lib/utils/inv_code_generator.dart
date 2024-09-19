import 'dart:math';

String generateInvCode() {
  Random random = Random();
  int randomNumber = random.nextInt(1000000);
  // 六位數字串
  return randomNumber.toString().padLeft(6, '0');
}
