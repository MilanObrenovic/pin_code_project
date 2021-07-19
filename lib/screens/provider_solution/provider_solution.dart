import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_project/screens/provider_solution/view_model.dart';
import 'package:provider/provider.dart';

class ProviderSolution extends StatelessWidget {
  const ProviderSolution({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Solution'),
      ),
      body: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: _PinCode(pinCount: 3),
    );
  }
}

class _PinCode extends StatelessWidget {
  final int pinCount;
  const _PinCode({Key? key, required this.pinCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProviderSolutionViewModel()..init(pinCount),
      child: Consumer<ProviderSolutionViewModel>(
        builder: (context, theme, _) {
          final vm = context.read<ProviderSolutionViewModel>();
          return SizedBox(
            height: 70,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final pin in vm.pins)
                  _Pin(
                    pin: pin,
                    key: ValueKey(pin.index),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Pin extends StatelessWidget {
  final PinModel pin;
  const _Pin({
    Key? key,
    required this.pin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ProviderSolutionViewModel>();
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      width: 40,
      decoration: BoxDecoration(
        border: Border.all(
          width: pin.focusNode.hasFocus ? 3 : 1,
          color: pin.textController.text.isNotEmpty
              ? Colors.red
              : Colors.blueAccent,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextFormField(
          controller: pin.textController,
          focusNode: pin.focusNode,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(2),
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          keyboardType: TextInputType.number,
          onChanged: (value) => vm.onTextChange(pin.index, value),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
