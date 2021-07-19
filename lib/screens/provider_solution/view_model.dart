import 'package:flutter/material.dart';

class ProviderSolutionViewModel extends ChangeNotifier {
  // Generate on start  lists of TextEditingController and FocusNode
  void init(int pinCount) {
    pins = List.generate(
      pinCount,
      (counter) => PinModel(
        index: counter,
        textController: TextEditingController(),
        focusNode: FocusNode(),
      ),
    );

    for (final pin in pins) {
      pin.focusNode.addListener(() => selectionOnFocus(pin.index));
    }
  }

  late List<PinModel> pins;

  final formKey = GlobalKey<FormState>();

  void onTextChange(int index, String value) {
    if (value.isNotEmpty) {
      if (index + 1 < pins.length) {
        pins[index + 1].focusNode.requestFocus();
        pins[index].textController.text = value.substring(
          pins[index].textController.text.length - 1,
          pins[index].textController.text.length,
        );
      }
      if (index + 1 == pins.length) {
        pins[index].textController.text = value.substring(0, 1);
        selectionOnFocus(index, isLast: true);
      }
    } else {
      if (index - 1 >= 0) {
        pins[index - 1].focusNode.requestFocus();
      }
    }
    notifyListeners();
  }

  void selectionOnFocus(int index, {bool isLast = false}) {
    pins[index].textController.selection =
        const TextSelection.collapsed(offset: 1);
  }

  String getOtp() {
    var otp = '';
    for (final pin in pins) {
      otp = otp + pin.textController.text;
    }
    return otp;
  }
}

class PinModel {
  final int index;
  final TextEditingController textController;
  final FocusNode focusNode;

  PinModel({
    required this.index,
    required this.textController,
    required this.focusNode,
  });
}
