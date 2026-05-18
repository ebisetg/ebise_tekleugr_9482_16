import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/volunteer/volunteer_bloc.dart';
import '../../blocs/volunteer/volunteer_event.dart';
import '../../blocs/volunteer/volunteer_state.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/volunteer_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/empty_state_widget.dart';

class VolunteerListScreen extends StatefulWidget {
  const VolunteerListScreen({super.key});

  @override
  State<VolunteerListScreen> createState() => _VolunteerListScreenState();
}

class _VolunteerListScreenState extends State<VolunteerListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VolunteerBloc>().add(LoadVolunteersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Opportunities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<VolunteerBloc>().add(LoadVolunteersEvent());
            },
          ),
        ],
      ),

      body: BlocBuilder<VolunteerBloc, VolunteerState>(
        builder: (context, state) {

          // LOADING
          if (state is VolunteerLoading) {
            return const LoadingWidget(message: "Loading...");
          }

          // DATA
          if (state is VolunteerLoaded) {
            if (state.volunteers.isEmpty) {
              return EmptyStateWidget(
                title: "No Opportunities",
                message: "No volunteer opportunities available.",
                icon: Icons.volunteer_activism,
                onAction: () {
                  Navigator.pushNamed(context, AppRoutes.createVolunteer);
                },
                actionLabel: "Add",
              );
            }

            return ListView.builder(
              itemCount: state.volunteers.length,
              itemBuilder: (context, index) {
                final item = state.volunteers[index];

                return VolunteerCard(
                  volunteer: item,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.volunteerDetail,
                      arguments: item.id,
                    );
                  },
                );
              },
            );
          }

          // ERROR
          if (state is VolunteerError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: () {
                context.read<VolunteerBloc>().add(LoadVolunteersEvent());
              },
            );
          }

          return const SizedBox();
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createVolunteer);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}