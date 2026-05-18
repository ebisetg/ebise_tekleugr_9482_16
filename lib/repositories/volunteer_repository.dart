import '../../models/volunteer.dart';
import '../../services/volunteer_api_service.dart';

class VolunteerRepository {
  final VolunteerApiService apiService;

  VolunteerRepository({required this.apiService});

  Future<List<Volunteer>> getVolunteers() async {
    return await apiService.getVolunteers();
  }

  Future<Volunteer> getVolunteerById(String id) async {
    return await apiService.getVolunteerById(id);
  }

  Future<Volunteer> createVolunteer(Volunteer volunteer) async {
    return await apiService.createVolunteer(volunteer);
  }

  Future<Volunteer> updateVolunteer(String id, Volunteer volunteer) async {
    return await apiService.updateVolunteer(id, volunteer);
  }

  Future<void> deleteVolunteer(String id) async {
    await apiService.deleteVolunteer(id);
  }
}