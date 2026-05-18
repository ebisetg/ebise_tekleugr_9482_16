import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/volunteer.dart';
import '../../repositories/volunteer_repository.dart';
import 'volunteer_event.dart';
import 'volunteer_state.dart';

class VolunteerBloc extends Bloc<VolunteerEvent, VolunteerState> {
  final VolunteerRepository repository;

  VolunteerBloc({required this.repository}) : super(VolunteerInitial()) {
    on<LoadVolunteersEvent>(_onLoadVolunteers);
    on<LoadVolunteerDetailEvent>(_onLoadDetail);
    on<AddVolunteerEvent>(_onAdd);
    on<UpdateVolunteerEvent>(_onUpdate);
    on<DeleteVolunteerEvent>(_onDelete);
    on<ApplyVolunteerEvent>(_onApply);
  }

  
  Future<void> _onLoadVolunteers(
    LoadVolunteersEvent event,
    Emitter<VolunteerState> emit,
  ) async {
    emit(VolunteerLoading());
    try {
      final data = await repository.getVolunteers();
      emit(VolunteerLoaded(volunteers: data));
    } catch (e) {
      emit(VolunteerError(message: e.toString()));
    }
  }

 
  Future<void> _onLoadDetail(
    LoadVolunteerDetailEvent event,
    Emitter<VolunteerState> emit,
  ) async {
    emit(VolunteerDetailLoading());
    try {
      final data = await repository.getVolunteerById(event.id);
      emit(VolunteerDetailLoaded(volunteer: data));
    } catch (e) {
      emit(VolunteerError(message: e.toString()));
    }
  }


  Future<void> _onAdd(
    AddVolunteerEvent event,
    Emitter<VolunteerState> emit,
  ) async {
    emit(VolunteerActionLoading());

    try {
      await repository.createVolunteer(event.volunteer);

      final updated = await repository.getVolunteers();
      emit(VolunteerLoaded(volunteers: updated));
    } catch (e) {
      emit(VolunteerError(message: e.toString()));
    }
  }


  Future<void> _onUpdate(
    UpdateVolunteerEvent event,
    Emitter<VolunteerState> emit,
  ) async {
    emit(VolunteerActionLoading());

    try {
      await repository.updateVolunteer(event.id, event.volunteer);

      final updated = await repository.getVolunteers();
      emit(VolunteerLoaded(volunteers: updated));
    } catch (e) {
      emit(VolunteerError(message: e.toString()));
    }
  }

  
  Future<void> _onDelete(
    DeleteVolunteerEvent event,
    Emitter<VolunteerState> emit,
  ) async {
    emit(VolunteerActionLoading());

    try {
      await repository.deleteVolunteer(event.id);

      final updated = await repository.getVolunteers();
      emit(VolunteerLoaded(volunteers: updated));
    } catch (e) {
      emit(VolunteerError(message: e.toString()));
    }
  }


  Future<void> _onApply(
    ApplyVolunteerEvent event,
    Emitter<VolunteerState> emit,
  ) async {
    emit(VolunteerActionLoading());

    try {
      final current = await repository.getVolunteerById(event.id);

      if (current.status.toLowerCase() == 'filled') {
        emit(const VolunteerError(message: 'This position is already filled!'));
        return;
      }

      final updated = current.copyWith(
        numberOfVolunteers: current.numberOfVolunteers + 1,
        updatedAt: DateTime.now(),
      );

      await repository.updateVolunteer(event.id, updated);

      final refreshed = await repository.getVolunteers();
      emit(VolunteerLoaded(volunteers: refreshed));
    } catch (e) {
      emit(VolunteerError(message: e.toString()));
    }
  }
}