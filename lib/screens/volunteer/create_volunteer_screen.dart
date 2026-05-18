import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/volunteer/volunteer_bloc.dart';
import '../../blocs/volunteer/volunteer_event.dart';
import '../../blocs/volunteer/volunteer_state.dart';
import '../../core/utils/validators.dart';
import '../../models/volunteer.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class CreateVolunteerScreen extends StatefulWidget {
  const CreateVolunteerScreen({super.key});

  @override
  State<CreateVolunteerScreen> createState() => _CreateVolunteerScreenState();
}

class _CreateVolunteerScreenState extends State<CreateVolunteerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _orgController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _volunteersController = TextEditingController();
  String _selectedStatus = 'open';

  @override
  void dispose() {
    _titleController.dispose();
    _orgController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _volunteersController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newVolunteer = Volunteer(
        id: '', // Will be assigned by API
        title: _titleController.text.trim(),
        organization: _orgController.text.trim(),
        description: _descController.text.trim(),
        location: _locationController.text.trim(),
        numberOfVolunteers: int.parse(_volunteersController.text),
        status: _selectedStatus,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      context
          .read<VolunteerBloc>()
          .add(AddVolunteerEvent(volunteer: newVolunteer));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Opportunity'),
      ),
      body: BlocListener<VolunteerBloc, VolunteerState>(
        listener: (context, state) {
          

          if (state is VolunteerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }

          
          if (state is VolunteerLoaded) {
            Navigator.pop(context, true);
          }
        },
        child: BlocBuilder<VolunteerBloc, VolunteerState>(
          builder: (context, state) {
            final isLoading = state is VolunteerActionLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Title',
                      hint: 'e.g., Beach Cleanup',
                      controller: _titleController,
                      validator: Validators.validateTitle,
                      prefixIcon: Icons.title,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Organization',
                      hint: 'e.g., Green Earth Foundation',
                      controller: _orgController,
                      validator: Validators.validateOrganization,
                      prefixIcon: Icons.business,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Description',
                      hint: 'Describe the volunteer opportunity...',
                      controller: _descController,
                      validator: Validators.validateDescription,
                      isMultiline: true,
                      maxLines: 5,
                      prefixIcon: Icons.description,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Location',
                      hint: 'e.g., Main Street Beach',
                      controller: _locationController,
                      validator: Validators.validateLocation,
                      prefixIcon: Icons.location_on,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Number of Volunteers',
                      hint: 'e.g., 10',
                      controller: _volunteersController,
                      validator: Validators.validateVolunteers,
                      isNumber: true,
                      prefixIcon: Icons.people,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.flag, size: 20),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'open', child: Text('Open')),
                        DropdownMenuItem(value: 'closed', child: Text('Closed')),
                        DropdownMenuItem(value: 'filled', child: Text('Filled')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      label: 'Create Opportunity',
                      onPressed: _submitForm,
                      isLoading: isLoading,
                      isPrimary: true,
                      icon: Icons.add,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}