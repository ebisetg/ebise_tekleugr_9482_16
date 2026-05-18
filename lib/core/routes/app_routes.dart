import 'package:flutter/material.dart';
import '../../screens/volunteer/create_volunteer_screen.dart';
import '../../screens/volunteer/edit_volunteer_screen.dart';
import '../../screens/volunteer/volunteer_detail_screen.dart';
import '../../screens/volunteer/volunteer_list_screen.dart';

class AppRoutes {
  static const String volunteerList = '/';
  static const String volunteerDetail = '/detail';
  static const String createVolunteer = '/create';
  static const String editVolunteer = '/edit';

  static Map<String, WidgetBuilder> get routes {
    return {
      volunteerList: (context) => const VolunteerListScreen(),
      volunteerDetail: (context) => const VolunteerDetailScreen(),
      createVolunteer: (context) => const CreateVolunteerScreen(),
      editVolunteer: (context) => const EditVolunteerScreen(),
    };
  }
}