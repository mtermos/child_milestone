# Child Milestone Tracker

A Flutter-based application designed to help track child development milestones, providing parents and caregivers with a simple and efficient way to monitor progress.

---
## Features

- **Track Milestones and Vaccines**: Log and monitor developmental milestones and vaccines at different stages and ages.

- **Notifications**: Set reminders for important tasks and milestones.

- **Multi-language Support**: Configured for localization for a global audience.

- **Cross-Platform Compatibility**: Works on Android and iOS.

---
## Screenshots

<div align="center">
  <img src="screenshots/main%20page.png" alt="Home Screen" width="400" style="margin-right: 50px;" />
  <img src="screenshots/milestones.png" alt="Milestones Screen" width="400" />
</div>
  

---
## Installation

1. Clone the repository:

```bash

git clone https://github.com/mtermos/child_milestone.git

cd child_milestone-master

```

2. Install dependencies:

```bash

flutter pub get

```

3. Run the app:

```bash

flutter run

```


---
## Project Structure
### **lib/**

The core logic and UI of the application reside here. Below is a detailed breakdown of its structure:

- **`main.dart`**: The entry point of the application.
- **`presentation/`**: contains the user interface (UI) components and screen layouts that define how the application visually interacts with users.
- **`logic/`**: contains the logic and the _BLoC_ state management components that handle the application's core functionality and behavior.
- **`data/`**: - manages data-related operations, including models, database, and repositories for fetching, storing, and processing application data.
- **`l10n/`**: Localization support (for different language usage).

- **`presentation/screens/`**: Contains the screens (pages) of the application.
- **`data/models/`**: Data models representing core entities.
    - `milestone.dart`: Represents a child milestone entity.
    - `user.dart`: Represents a user or parent entity.
- **`data/data_providers/`**: contains files to add static data to the app.
- **`data/dao/`**: contains Data Access Objects (DAOs) responsible for managing interactions with the database or local storage, such as querying, inserting, updating, and deleting data.
- **`data/repositories/`**: contains repository classes that serve as intermediaries between the data layer (DAOs, APIs, etc.) and the application logic.
- **`data/database/`**: contains the database setup and configuration files for local SQLite database.
- **`logic/blocs/`**: Contains Bloc (Business Logic Component) classes for managing complex state and event handling.
- **`logic/cubits/`**: Contains Cubit classes, a simpler version of Bloc, for managing state with minimal boilerplate where only state changes (no event handling) are required.
- **`logic/shared/`**: Contains shared logic or utilities that are reused across the application.
### **assets/**

The `assets/` directory contains resources like images and icons

---

## Screens and Routes

### **Splash Screen**
The app begins with a splash screen, which determines the next screen based on user status:
1. **Existing User**: If a user is already logged in, the app navigates directly to the home screen.
2. **New User**: If no user is logged in:
   - The app displays a welcome screen with a button to proceed to the login screen.
   - In this version, the app only supports login using credentials provided by the university (no sign-up or "forgot password" functionality).
   - Upon successful login, the app navigates to the home screen.


### **Home Screen**
The home screen is the central hub of the application, featuring four primary tabs and additional functionalities:

#### **Tabs:**
1. **Home Tab**:
   - Displays progress (e.g., the percentage of milestones completed for the current age group).
   - Provides access to:
     - Milestones
     - Vaccines
     - Progress reports
2. **Notifications Tab**: Shows reminders and alerts related to milestones, vaccinations, or if it is the time for the parents to check the doctor.
3. **Tips Tab**: Offers helpful parenting tips and guidance for child development.
4. **Rates Tab**: Allows users to review and provide feedback on app features (the rating process is a little bit complex as requested by client).

#### **Additional Features:**
- **Add a Child**: A dedicated button to add child profiles to the app.
- **Top Bar**:
  - Access the settings menu.
  - Switch between children (if the parent has added multiple profiles).

---

### Notes

- **Notifications**: 
  - Since the required notifications do not rely on a backend, push notifications were not implemented. Instead, a dynamic solution was created to handle user-specific progress:
    - All notifications are pre-scheduled.
    - Irrelevant notifications are dynamically removed as the user progresses.
  
- **Multi-Language Support**: 
  - The application was prepared for a multi-language setup. However, the current version focuses solely on the Arabic language.

- **DAO and Repository Separation**: 
  - DAOs were separated from repositories to support potential integration with multiple data sources. However, this flexibility was not heavily utilized in this version.

- **State Management**: 
  - The app uses the **Bloc** (Business Logic Component) pattern to efficiently manage states and events across the application, ensuring a reactive and predictable architecture.

---
## Contact

For questions or suggestions, reach out:

- **Email**: mortada.termos@gmail.com

