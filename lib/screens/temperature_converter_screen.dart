import 'package:flutter/material.dart';
import '../widgets/conversion_history.dart';
import '../widgets/temperature_input.dart';
import '../models/conversion_record.dart';
import '../utils/temperature_converter.dart';

class TemperatureConverterScreen extends StatefulWidget {
  const TemperatureConverterScreen({super.key});

  @override
  State<TemperatureConverterScreen> createState() => _TemperatureConverterScreenState();
}

class _TemperatureConverterScreenState extends State<TemperatureConverterScreen> {
  final List<ConversionRecord> _history = [];
  bool _isFahrenheitToCelsius = true;
  final TextEditingController _temperatureController = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
  }

  void _convertTemperature() {
    // First validate if input is a valid number
    if (!TemperatureConverter.isValidTemperature(_temperatureController.text)) {
      _showErrorMessage('Please enter a valid number');
      return;
    }

    final double input = double.parse(_temperatureController.text);

    // Check if temperature is above absolute zero
    if (!TemperatureConverter.isAboveAbsoluteZero(input, !_isFahrenheitToCelsius)) {
      _showErrorMessage(
          'Temperature cannot be below ${TemperatureConverter.formatTemperature(
              TemperatureConverter.getAbsoluteZero(!_isFahrenheitToCelsius),
              !_isFahrenheitToCelsius
          )}'
      );
      return;
    }

    try {
      double converted;
      String operation;

      if (_isFahrenheitToCelsius) {
        converted = TemperatureConverter.fahrenheitToCelsius(input);
        operation = 'F to C';
      } else {
        converted = TemperatureConverter.celsiusToFahrenheit(input);
        operation = 'C to F';
      }

      setState(() {
        _result = converted.toStringAsFixed(2);
        _history.insert(
          0,
          ConversionRecord(
            operation: operation,
            inputValue: double.parse(input.toStringAsFixed(1)),
            result: converted,
          ),
        );
      });

      // Clear the input field after successful conversion
      _temperatureController.clear();
    } catch (e) {
      _showErrorMessage('An error occurred during conversion');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        elevation: 2,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              tooltip: 'Clear History',
              onPressed: _clearHistory,
            ),
        ],
      ),
      body: isPortrait
          ? _buildPortraitLayout()
          : _buildLandscapeLayout(),
    );
  }

  Widget _buildPortraitLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildConverterSection(),
          const SizedBox(height: 24),
          ConversionHistory(history: _history),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildConverterSection(),
          ),
        ),
        Expanded(
          child: ConversionHistory(history: _history),
        ),
      ],
    );
  }

  Widget _buildConverterSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Conversion type selector with updated styling
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: true,
                  label: Text('°F to °C'),
                  icon: Icon(Icons.arrow_forward),
                ),
                ButtonSegment(
                  value: false,
                  label: Text('°C to °F'),
                  icon: Icon(Icons.arrow_back),
                ),
              ],
              selected: {_isFahrenheitToCelsius},
              onSelectionChanged: (Set<bool> selection) {
                setState(() {
                  _isFahrenheitToCelsius = selection.first;
                  _result = '';
                });
              },
            ),
            const SizedBox(height: 16),
            // Temperature input
            TemperatureInput(
              controller: _temperatureController,
              isFahrenheitToCelsius: _isFahrenheitToCelsius,
              // Passing the convert function directly
              onChanged: (value) {
                // Optional: You can handle changes here if needed
              },
            ),
            const SizedBox(height: 16),
            // Convert button
            ElevatedButton.icon(
              onPressed: _convertTemperature,
              icon: const Icon(Icons.calculate),
              label: const Text('Convert'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 16),
            // Result display
            if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_isFahrenheitToCelsius ? "°C" : "°F"}: $_result',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}