import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const AdaptiveProfileScreen(),
    );
  }
}

class AdaptiveProfileScreen extends StatefulWidget {
  const AdaptiveProfileScreen({super.key});

  @override
  State<AdaptiveProfileScreen> createState() => _AdaptiveProfileScreenState();
}

class _AdaptiveProfileScreenState extends State<AdaptiveProfileScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedRole = 'Developer';
  final List<String> _roles = ['Student', 'Developer', 'Designer', 'Engineer'];

  // 1. Material Date Picker
  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // 2. Cupertino Date Picker
  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (DateTime newDate) {
                  setState(() => _selectedDate = newDate);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Cupertino Wheel Picker
  void _showCupertinoRolePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 32,
                onSelectedItemChanged: (int index) {
                  setState(() => _selectedRole = _roles[index]);
                },
                children: _roles.map((role) => Center(child: Text(role))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      // Exercise 2.2: Adaptive Layout mapping Portrait and Landscape modes
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView()
              : _buildLandscapeView();
        },
      ),
    );
  }

  // Portrait Mode: Stacks vertically
  Widget _buildPortraitView() {
    return ListView(
      children: [
        const StudentDetailsSection(),
        const TitleSection(
          name: 'Big Ben',
          location: 'London, England',
          starCount: 20,
        ),
        const ImageSection(imagePath: 'assets/england.jpeg'),
        _buildPickersSection(),
      ],
    );
  }

  // Landscape Mode: Splits side-by-side
  Widget _buildLandscapeView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: SingleChildScrollView(child: StudentDetailsSection()),
        ),
        Expanded(
          child: ListView(
            children: [
              const TitleSection(
                name: 'Big Ben',
                location: 'London, England',
                starCount: 41,
              ),
              const ImageSection(imagePath: 'assets/england.jpeg'),
              _buildPickersSection(),
            ],
          ),
        ),
      ],
    );
  }

  // Exercise 2.3: Pickers Card Layout
  Widget _buildPickersSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: Colors.grey[100],
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Interactive Pickers (Lab 2.2)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('Selected Date: ${_selectedDate.toLocal().toString().split(' ')[0]}', style: const TextStyle(fontSize: 14)),
              Text('Selected Role: $_selectedRole', style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 20),

              // Row 1: Date Pickers
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: const Text('Material Date'),
                      onPressed: () => _selectMaterialDate(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(CupertinoIcons.calendar, size: 18),
                      label: const Text('Cupertino Date'),
                      onPressed: () => _showCupertinoDatePicker(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 2: Material Dropdown
              Row(
                children: [
                  const Text('Material Dropdown:  '),
                  DropdownButton<String>(
                    value: _selectedRole,
                    items: _roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) setState(() => _selectedRole = newValue);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 3: Cupertino Wheel
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(CupertinoIcons.list_bullet, size: 18),
                  label: const Text('Cupertino Role Wheel Picker'),
                  onPressed: () => _showCupertinoRolePicker(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// Sub-Widgets
// ---------------------------------------------------------

class StudentDetailsSection extends StatelessWidget {
  const StudentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: Colors.indigo[400], // Styled similar to the lab manual example
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/image.jpeg'), // Your profile image
              ),
              const SizedBox(height: 20),
              const Text(
                'Song Jia Ying',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Student ID: BCS24090019',
                style: TextStyle(fontSize: 14, color: Colors.indigo[100]),
              ),
              const Divider(height: 32, thickness: 1, color: Colors.white54),
              const Text(
                'Personal Life Goal / Quote:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                '"You cant stop the storm, but you can dance in the rain."',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Exercise 2.1: Separated Location Details Widget
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(location, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.indigo[300]),
          const SizedBox(width: 4),
          Text('$starCount'),
        ],
      ),
    );
  }
}

// Added specifically to match the image below the location text
class ImageSection extends StatelessWidget {
  final String imagePath;

  const ImageSection({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}