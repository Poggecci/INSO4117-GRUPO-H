import 'package:flutter/material.dart';
import 'shelter_create.dart';
import 'volunteer_create.dart';

class AccountTypePicker extends StatefulWidget {
  const AccountTypePicker({Key? key}) : super(key: key);

  @override
  _AccountTypePickerState createState() => _AccountTypePickerState();
}

class _AccountTypePickerState extends State<AccountTypePicker> {
  bool _isShelterSelected = false;
  bool _isVolunteerSelected = false;

  void _selectShelter() {
    setState(() {
      _isShelterSelected = true;
      _isVolunteerSelected = false;
    });
  }

  void _selectVolunteer() {
    setState(() {
      _isShelterSelected = false;
      _isVolunteerSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Account Type Picker'),
            ),
            body: Column(
              children: [
                Text(
                  'Select account type:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _selectShelter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isShelterSelected
                            ? Colors.green
                            : Theme.of(context).colorScheme.background,
                      ),
                      child: const Text('Shelter'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _selectVolunteer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isVolunteerSelected
                            ? Colors.green
                            : Theme.of(context).colorScheme.background,
                      ),
                      child: const Text('Volunteer'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_isShelterSelected)
                  // Display the Shelter account creation screen
                  const ShelterProfileForm()
                else if (_isVolunteerSelected)
                  // Display the Volunteer account creation screen
                  const VolunteerProfileForm()
              ],
            )));
  }
}
