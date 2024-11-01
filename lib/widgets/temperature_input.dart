import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TemperatureInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isFahrenheitToCelsius;
  final ValueChanged<String>? onChanged;

  const TemperatureInput({
    super.key,
    required this.controller,
    required this.isFahrenheitToCelsius,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
      ],
      decoration: InputDecoration(
        labelText: 'Enter temperature',
        suffixText: isFahrenheitToCelsius ? '°F' : '°C',
        hintText: 'Enter a number',
        prefixIcon: const Icon(Icons.thermostat),
      ),
    );
  }
}