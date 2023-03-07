import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../location_picker.dart';
import '../models/globals.dart';
import '../models/shelter.dart';

class ShelterProfileForm extends StatefulWidget {
  const ShelterProfileForm({Key? key}) : super(key: key);

  @override
  _ShelterProfileFormState createState() => _ShelterProfileFormState();
}

class _ShelterProfileFormState extends State<ShelterProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _servicesController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _servicesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter the shelter\'s name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Phone'),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _servicesController,
            decoration: const InputDecoration(labelText: 'Services Needed'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter the services you need';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const LocationInputWidget(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final hasLocation =
                  Globals.userInformation.containsKey('latitude') &&
                      Globals.userInformation.containsKey('longitude');
              if (_formKey.currentState != null &&
                  _formKey.currentState!.validate() &&
                  hasLocation) {
                // Save data
                final name = _nameController.text;
                final email = _emailController.text;
                final phone = _phoneController.text;
                var services = _servicesController.text.split(',');
                var trimmedServices =
                    services.map((e) => e.trim().toLowerCase()).toList();
                final address = Globals.userInformation['address'];
                final latitude = Globals.userInformation['latitude'];
                final longitude = Globals.userInformation['longitude'];
                // Do something with the data, e.g. store it in a database
                Shelter newShelter = Shelter(
                  id: Globals.userID,
                  name: name,
                  email: email,
                  phone: phone,
                  address: address,
                  latitude: latitude,
                  longitude: longitude,
                  needs: trimmedServices,
                );
                final db = FirebaseFirestore.instance;
                db
                    .collection("users")
                    .doc(newShelter.id)
                    .set(newShelter.toFirestore())
                    .then((value) {
                  Globals.hasProfile = true;
                  Navigator.pushNamed(context, '/shelter_home');
                });
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
