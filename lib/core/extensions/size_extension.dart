import 'package:flutter/material.dart';

extension SizedBoxExt on num {
  SizedBox get w => SizedBox(
        width: toDouble(),
      );
  SizedBox get h => SizedBox(
        height: toDouble(),
      );
}

extension SizeExt on num {
  double ws(BuildContext context) =>
      MediaQuery.of(context).size.width * (this / 100);
  double hs(BuildContext context) =>
      MediaQuery.of(context).size.height * (this / 100);
}
