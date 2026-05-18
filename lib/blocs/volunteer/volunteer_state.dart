import 'package:equatable/equatable.dart';
import '../../models/volunteer.dart';

abstract class VolunteerState extends Equatable {
  const VolunteerState();

  @override
  List<Object?> get props => [];
}


class VolunteerInitial extends VolunteerState {}


class VolunteerLoading extends VolunteerState {}


class VolunteerLoaded extends VolunteerState {
  final List<Volunteer> volunteers;

  const VolunteerLoaded({required this.volunteers});

  @override
  List<Object?> get props => [volunteers];
}

// Detail loading
class VolunteerDetailLoading extends VolunteerState {}

class VolunteerDetailLoaded extends VolunteerState {
  final Volunteer volunteer;

  const VolunteerDetailLoaded({required this.volunteer});

  @override
  List<Object?> get props => [volunteer];
}


class VolunteerActionLoading extends VolunteerState {}


class VolunteerActionSuccess extends VolunteerState {
  final String message;

  const VolunteerActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

// Error
class VolunteerError extends VolunteerState {
  final String message;

  const VolunteerError({required this.message});

  @override
  List<Object?> get props => [message];
}