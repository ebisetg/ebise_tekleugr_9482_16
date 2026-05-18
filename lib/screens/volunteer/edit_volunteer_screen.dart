import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/volunteer/volunteer_bloc.dart';
import '../../blocs/volunteer/volunteer_event.dart';
import '../../blocs/volunteer/volunteer_state.dart';
import '../../core/utils/validators.dart';
import '../../models/volunteer.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class EditVolunteerScreen extends StatefulWidget {
  const EditVolunteerScreen({super.key});

  @override
  State<EditVolunteerScreen> createState() => _EditVolunteerScreenState();
}

class _EditVolunteerScreenState extends State<EditVolunteerScreen> {
  final _formKey = GlobalKey<FormState>();
  late Volunteer _volunteer;
  late TextEditingController _titleController;
  late TextEditingController _orgController;
  late TextEditingController _descController;
  late TextEditingController _locationController;
  late TextEditingController _volunteersController;
  late String _selectedStatus;
  bool _didInit = false;

  @override
  void initState() {
    super.initState();
    // Defer accessing ModalRoute.of(context) to didChangeDependencies
    _titleController = TextEditingController();
    _orgController = TextEditingController();
    _descController = TextEditingController();
    _locationController = TextEditingController();
    _volunteersController = TextEditingController();
    _selectedStatus = 'open';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is Volunteer) {
        _volunteer = args;
        _titleController.text = _volunteer.title;
        _orgController.text = _volunteer.organization;
        _descController.text = _volunteer.description;
        _locationController.text = _volunteer.location;
        _volunteersController.text = _volunteer.numberOfVolunteers.toString();
        _selectedStatus = _volunteer.status;
      }
      _didInit = true;
    }
  }

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
      final updatedVolunteer = _volunteer.copyWith(
        title: _titleController.text.trim(),
        organization: _orgController.text.trim(),
        description: _descController.text.trim(),
        location: _locationController.text.trim(),
        numberOfVolunteers: int.parse(_volunteersController.text),
        status: _selectedStatus,
        updatedAt: DateTime.now(),
      );
      context.read<VolunteerBloc>().add(UpdateVolunteerEvent(
        id: _volunteer.id,
        volunteer: updatedVolunteer,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Opportunity'),
      ),
      body: BlocListener<VolunteerBloc, VolunteerState>(
        listener: (context, state) {
          if (state is VolunteerActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            Navigator.pop(context, true);
          } else if (state is VolunteerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
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
                      controller: _titleController,
                      validator: Validators.validateTitle,
                      prefixIcon: Icons.title,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Organization',
                      controller: _orgController,
                      validator: Validators.validateOrganization,
                      prefixIcon: Icons.business,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Description',
                      controller: _descController,
                      validator: Validators.validateDescription,
                      isMultiline: true,
                      maxLines: 5,
                      prefixIcon: Icons.description,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Location',
                      controller: _locationController,
                      validator: Validators.validateLocation,
                      prefixIcon: Icons.location_on,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Number of Volunteers',
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                      label: 'Save Changes',
                      onPressed: _submitForm,
                      isLoading: isLoading,
                      isPrimary: true,
                      icon: Icons.save,
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