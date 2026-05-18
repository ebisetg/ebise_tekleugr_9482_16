import 'package:equatable/equatable.dart';
import '../../models/volunteer.dart';

abstract class VolunteerEvent extends Equatable {
  const VolunteerEvent();

  @override
  List<Object?> get props => [];
}

class LoadVolunteersEvent extends VolunteerEvent {}

class LoadVolunteerDetailEvent extends VolunteerEvent {
  final String id;
  const LoadVolunteerDetailEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class AddVolunteerEvent extends VolunteerEvent {
  final Volunteer volunteer;
  const AddVolunteerEvent({required this.volunteer});

  @override
  List<Object?> get props => [volunteer];
}

class UpdateVolunteerEvent extends VolunteerEvent {
  final String id;
  final Volunteer volunteer;
  const UpdateVolunteerEvent({required this.id, required this.volunteer});

  @override
  List<Object?> get props => [id, volunteer];
}

class DeleteVolunteerEvent extends VolunteerEvent {
  final String id;
  const DeleteVolunteerEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class ApplyVolunteerEvent extends VolunteerEvent {
  final String id;
  final int currentVolunteers;
  const ApplyVolunteerEvent({required this.id, required this.currentVolunteers});

  @override
  List<Object?> get props => [id, currentVolunteers];
}