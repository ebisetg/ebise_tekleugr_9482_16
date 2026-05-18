# ebise_tekleugr_9482_16

A Flutter volunteer opportunity app with create/edit and list screens.

## What it is

This app manages volunteer opportunities using Flutter and `flutter_bloc`.
It includes screens for listing opportunities, creating new ones, editing details, and deleting entries.

## How to run

1. Open the project folder.
2. Install dependencies:

```bash
flutter pub get
```

3. Run on Chrome or another device:

```bash
flutter run -d chrome

App Flow
 1. Load Volunteers
App starts → fetches data from API
Event: LoadVolunteersEvent
State: VolunteerLoaded
 2. Create Volunteer
User fills form
Event: AddVolunteerEvent
API POST request
List updates automatically
 3. View Details
Tap card → navigate to detail screen
Event: LoadVolunteerDetailEvent
Shows full information
 4. Update Volunteer
Edit form submitted
Event: UpdateVolunteerEvent
API PUT request updates data
UI refreshes
5. Delete Volunteer
Confirmation dialog
Event: DeleteVolunteerEvent
API DELETE request
Item removed from list
6. Apply for Volunteer
Increases number of volunteers
Prevents applying if status = Filled
Updates backend via PUT request
```

## Screenshots

![Volunteer Opportunities](ebise_tekleugr_9482_16\screenshots\photo_2026-05-18_20-10-02.jpg)

![Create Opportunity](ebise_tekleugr_9482_16\screenshots\photo_2026-05-18_20-10-40.jpg)

![Opportunity Details](ebise_tekleugr_9482_16\screenshots\photo_2026-05-18_20-10-53.jpg)

![Delete Confirmation](ebise_tekleugr_9482_16\screenshots\photo_2026-05-18_20-10-59.jpg)

![Edit Opportunity](ebise_tekleugr_9482_16\screenshots\photo_2026-05-18_20-11-03.jpg)

## Key files

- `lib/main.dart` — app entry point
- `lib/screens/volunteer/create_volunteer_screen.dart` — create volunteer form
- `lib/screens/volunteer/edit_volunteer_screen.dart` — edit volunteer form
- `lib/blocs/volunteer/volunteer_bloc.dart` — bloc logic
- `lib/blocs/volunteer/volunteer_state.dart` — volunteer states
- `lib/models/volunteer.dart` — volunteer model

