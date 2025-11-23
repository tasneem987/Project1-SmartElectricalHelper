import 'package:flutter/material.dart';

void main() {
  runApp(const SmartElectricalHelper());
}

class SmartElectricalHelper extends StatelessWidget {
  const SmartElectricalHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Smart Electrical Helper",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controllers
  final voltageCtrl = TextEditingController();
  final currentCtrl = TextEditingController();
  final resistanceCtrl = TextEditingController();
  final color1Ctrl = TextEditingController();
  final color2Ctrl = TextEditingController();
  final powerVoltageCtrl = TextEditingController();
  final powerCurrentCtrl = TextEditingController();

  String ohmsResult = "";
  String resistorResult = "";
  String powerResult = "";

  final Map<String, int> colorDigit = {
    "black": 0, "brown": 1, "red": 2, "orange": 3, "yellow": 4,
    "green": 5, "blue": 6, "violet": 7, "gray": 8, "white": 9
  };

  // ---------------------- Calculations ----------------------

  void calculateOhmsLaw() {
    double? v = double.tryParse(voltageCtrl.text);
    double? i = double.tryParse(currentCtrl.text);
    double? r = double.tryParse(resistanceCtrl.text);

    if (v != null && i != null) {
      setState(() => ohmsResult = "Resistance = ${(v / i).toStringAsFixed(2)} Ω");
    } else if (v != null && r != null) {
      setState(() => ohmsResult = "Current = ${(v / r).toStringAsFixed(2)} A");
    } else if (i != null && r != null) {
      setState(() => ohmsResult = "Voltage = ${(i * r).toStringAsFixed(2)} V");
    } else {
      setState(() => ohmsResult = "Enter ANY two values!");
    }
  }

  void decodeResistor() {
    String c1 = color1Ctrl.text.toLowerCase();
    String c2 = color2Ctrl.text.toLowerCase();

    if (!colorDigit.containsKey(c1) || !colorDigit.containsKey(c2)) {
      setState(() => resistorResult = "Invalid color name!");
      return;
    }

    int value = colorDigit[c1]! * 10 + colorDigit[c2]!;
    setState(() => resistorResult = "Resistor Value = $value Ω");
  }

  void calculatePower() {
    double? v = double.tryParse(powerVoltageCtrl.text);
    double? i = double.tryParse(powerCurrentCtrl.text);

    if (v != null && i != null) {
      setState(() => powerResult = "Power = ${(v * i).toStringAsFixed(2)} W");
    } else {
      setState(() => powerResult = "Enter both values!");
    }
  }

  // ---------------------- UI Section Builder ----------------------

  Widget buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 28),
                const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget textField(TextEditingController ctrl, String label) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget textFieldNormal(TextEditingController ctrl, String label) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  // ------------------------------ Build UI ------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Electrical Helper"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // -------------------- Ohm’s Law Section --------------------
            buildSection(
              icon: Icons.bolt,
              title: "Ohm’s Law Calculator",
              children: [
                textField(voltageCtrl, "Voltage (V)"),
                const SizedBox(height: 10),
                textField(currentCtrl, "Current (A)"),
                const SizedBox(height: 10),
                textField(resistanceCtrl, "Resistance (Ω)"),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: calculateOhmsLaw,
                  child: const Text("Calculate"),
                ),
                const SizedBox(height: 8),
                Text(ohmsResult,
                    style: const TextStyle(fontSize: 16)),
              ],
            ),

            // -------------------- Resistor Decoder --------------------
            buildSection(
              icon: Icons.color_lens,
              title: "Resistor Color Code",
              children: [
                textFieldNormal(color1Ctrl, "1st Band Color"),
                const SizedBox(height: 10),
                textFieldNormal(color2Ctrl, "2nd Band Color"),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: decodeResistor,
                  child: const Text("Decode"),
                ),
                const SizedBox(height: 8),
                Text(resistorResult,
                    style: const TextStyle(fontSize: 16)),
              ],
            ),

            // -------------------- Power Calculator --------------------
            buildSection(
              icon: Icons.power,
              title: "Power Calculator",
              children: [
                textField(powerVoltageCtrl, "Voltage (V)"),
                const SizedBox(height: 10),
                textField(powerCurrentCtrl, "Current (A)"),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: calculatePower,
                  child: const Text("Calculate Power"),
                ),
                const SizedBox(height: 8),
                Text(powerResult,
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
