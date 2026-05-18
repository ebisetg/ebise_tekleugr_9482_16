import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/volunteer/volunteer_bloc.dart';
import '../../blocs/volunteer/volunteer_event.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../repositories/volunteer_repository.dart';
import '../../services/volunteer_api_service.dart';

void main() {
  runApp(const VolunteerApp());
}

class VolunteerApp extends StatelessWidget {
  const VolunteerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => VolunteerRepository(
        apiService: VolunteerApiService(),
      ),
      child: BlocProvider(
        create: (context) => VolunteerBloc(
          repository: context.read<VolunteerRepository>(),
        )..add(LoadVolunteersEvent()),
        child: MaterialApp(
          title: 'Volunteer Opportunities',
          theme: AppTheme.lightTheme,
          initialRoute: AppRoutes.volunteerList,
          routes: AppRoutes.routes,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}