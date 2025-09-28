import 'dart:async';

class AiApiService {
  static const Map<String, String> _keywordDefinitions = {
    'Voltage': 'Voltage is the electrical potential difference between two points in a circuit.',
    'Current': 'Current is the rate at which electric charge flows past a point in a circuit.',
    'Resistance': 'Resistance is an electrical quantity that measures how the device or material reduces the electric current flow through it.',
    'Capacitor': 'A capacitor is a device that stores electrical energy in an electric field.',
    'Entropy': 'Entropy is a measure of disorder or randomness in a system, often used in thermodynamics.',
    'Heat Transfer': 'Heat transfer is the movement of heat from one substance or material to another.',
    'Algorithm': 'An algorithm is a step-by-step procedure to solve a specific problem.',
    'Data Structure': 'A data structure is a particular way of organizing and storing data in a computer.',

  };

 
  Future<List<String>> getKeywords(String text) async {

    final lowerText = text.toLowerCase();
    final List<String> found = [];

    for (final keyword in _keywordDefinitions.keys) {
      if (lowerText.contains(keyword.toLowerCase())) {
        found.add(keyword);
      }
    }


    await Future.delayed(Duration(seconds: 1));
    return found;
  }

  
  Future<String> getDefinition(String keyword) async {

    await Future.delayed(Duration(milliseconds: 400));
    return _keywordDefinitions[keyword] ?? 'Definition not found.';
  }
}
