import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/volunteer/volunteer_bloc.dart';
import '../../blocs/volunteer/volunteer_event.dart';
import '../../blocs/volunteer/volunteer_state.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/helpers.dart';
import '../../models/volunteer.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/status_badge.dart';

class VolunteerDetailScreen extends StatefulWidget {
  const VolunteerDetailScreen({super.key});

  @override
  State<VolunteerDetailScreen> createState() => _VolunteerDetailScreenState();
}

class _VolunteerDetailScreenState extends State<VolunteerDetailScreen> {
  String? _id;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _id = ModalRoute.of(context)?.settings.arguments as String;

    // Only fetch from network if we don't already have it in cache.
    if (_findInCache(context.read<VolunteerBloc>().state, _id!) == null) {
      context.read<VolunteerBloc>().add(LoadVolunteerDetailEvent(id: _id!));
    }
  }

  Volunteer? _findInCache(VolunteerState state, String id) {
    if (state is VolunteerLoaded) {
      for (final v in state.volunteers) {
        if (v.id == id) return v;
      }
    }
    if (state is VolunteerDetailLoaded && state.volunteer.id == id) {
      return state.volunteer;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final id = _id!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunity Details'),
      ),
      body: BlocBuilder<VolunteerBloc, VolunteerState>(
        builder: (context, state) {
          final cached = _findInCache(state, id);
          if (cached != null) {
            return _buildDetail(context, cached, id);
          }
          if (state is VolunteerError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: () {
                context.read<VolunteerBloc>().add(LoadVolunteerDetailEvent(id: id));
              },
            );
          }
          return const LoadingWidget(message: 'Loading details...');
        },
      ),
    );
  }

  Widget _buildDetail(BuildContext context, Volunteer volunteer, String id) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.volunteer_activism,
              size: 64,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            volunteer.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.business, size: 18, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                volunteer.organization,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                volunteer.location,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          StatusBadge(status: volunteer.status),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            volunteer.description,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Volunteers Needed',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${volunteer.numberOfVolunteers} spots'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Last Updated',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(Helpers.formatDate(volunteer.updatedAt)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: 'Edit',
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      AppRoutes.editVolunteer,
                      arguments: volunteer,
                    );
                    if (!context.mounted) return;
                    if (result == true) {
                      context.read<VolunteerBloc>().add(LoadVolunteerDetailEvent(id: id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opportunity updated successfully!')),
                      );
                    }
                  },
                  isPrimary: false,
                  icon: Icons.edit,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  label: 'Delete',
                  onPressed: () {
                    _showDeleteDialog(context, id);
                  },
                  isPrimary: false,
                  icon: Icons.delete,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomButton(
            label: volunteer.status.toLowerCase() == 'filled'
                ? 'Position Filled'
                : 'Apply Now',
            onPressed: volunteer.status.toLowerCase() == 'filled'
                ? null
                : () {
                    _showApplyDialog(context, volunteer.id, volunteer.numberOfVolunteers);
                  },
            isPrimary: true,
            icon: Icons.handshake,
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Opportunity'),
        content: const Text('Are you sure you want to delete this volunteer opportunity? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<VolunteerBloc>().add(DeleteVolunteerEvent(id: id));
              Navigator.pop(context, true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opportunity deleted successfully!')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showApplyDialog(BuildContext context, String id, int currentVolunteers) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply for Opportunity'),
        content: Text('Are you sure you want to apply for this volunteer position? There are $currentVolunteers spots currently available.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<VolunteerBloc>().add(ApplyVolunteerEvent(
                id: id,
                currentVolunteers: currentVolunteers,
              ));
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
