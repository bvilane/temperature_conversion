class TemperatureConverter {
  /// Converts Fahrenheit to Celsius
  /// Returns the result rounded to 2 decimal places
  static double fahrenheitToCelsius(double fahrenheit) {
    return double.parse(((fahrenheit - 32) * 5 / 9).toStringAsFixed(2));
  }

  /// Converts Celsius to Fahrenheit
  /// Returns the result rounded to 2 decimal places
  static double celsiusToFahrenheit(double celsius) {
    return double.parse((celsius * 9 / 5 + 32).toStringAsFixed(2));
  }

  /// Validates if the input string is a valid temperature
  /// Returns true if the input can be parsed to a number
  static bool isValidTemperature(String input) {
    try {
      double.parse(input);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Formats the temperature value with the appropriate symbol
  /// Example: "23.45°C" or "73.40°F"
  static String formatTemperature(double value, bool isCelsius) {
    return '${value.toStringAsFixed(2)}°${isCelsius ? 'C' : 'F'}';
  }

  /// Returns the absolute zero limit for the given scale
  /// Celsius: -273.15°C
  /// Fahrenheit: -459.67°F
  static double getAbsoluteZero(bool isCelsius) {
    return isCelsius ? -273.15 : -459.67;
  }

  /// Validates if the temperature is above absolute zero
  static bool isAboveAbsoluteZero(double temperature, bool isCelsius) {
    return temperature >= getAbsoluteZero(isCelsius);
  }
}