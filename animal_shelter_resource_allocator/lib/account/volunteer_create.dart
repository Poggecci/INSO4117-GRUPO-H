import 'package:animal_shelter_resource_allocator/location_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/globals.dart';
import '../models/volunteer.dart';

class VolunteerProfileForm extends StatefulWidget {
  const VolunteerProfileForm({Key? key}) : super(key: key);

  @override
  _VolunteerProfileFormState createState() => _VolunteerProfileFormState();
}

class _VolunteerProfileFormState extends State<VolunteerProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();
  final TextEditingController _servicesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _radiusController.dispose();
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
                return 'Please enter your name';
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
            controller: _radiusController,
            decoration:
                const InputDecoration(labelText: 'Acceptable Radius (km)'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your acceptable radius';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _servicesController,
            decoration: const InputDecoration(labelText: 'Services Offered'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter the services you offer';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const LocationInputWidget(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState != null &&
                  _formKey.currentState!.validate()) {
                // Save data
                final name = _nameController.text;
                final email = _emailController.text;
                final phone = _phoneController.text;
                final radius = double.parse(_radiusController.text);
                final services = _servicesController.text.split(',');
                // Do something with the data, e.g. store it in a database
                var trimmedServices =
                    services.map((e) => e.trim().toLowerCase()).toList();
                final address = Globals.userInformation['address'];
                final latitude = Globals.userInformation['latitude'];
                final longitude = Globals.userInformation['longitude'];
                // Do something with the data, e.g. store it in a database
                Volunteer newVolunteer = Volunteer(
                  id: Globals.userID,
                  name: name,
                  email: email,
                  phone: phone,
                  address: address,
                  latitude: latitude,
                  longitude: longitude,
                  radius: radius,
                  resources: trimmedServices,
                );
                final db = FirebaseFirestore.instance;
                db
                    .collection("users")
                    .doc(newVolunteer.id)
                    .set(newVolunteer.toFirestore())
                    .then((value) {
                  Globals.hasProfile = true;
                  Navigator.pushNamed(context, '/volunteer_home');
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
