# app_base

Reusable Flutter base template: Splash, Onboarding, Login, Register, and a Home/More bottom-nav shell,
wired to a clean core (Dio client, secure token storage, localization, DI, theming).

Home ships empty on purpose — build the screen's UI first, then wire its API per project.

## Getting Started

1. Rename the package/app id away from `app_base` for the new project (pubspec `name`, Android `applicationId`, iOS bundle id).
2. Point `ApiEndpoints.baseUrl` (`lib/core/network/api_endpoints.dart`) at the new backend.
3. Drop project assets into `assets/images/`, `assets/icons/`; add translation keys to `assets/translations/{en,ar}.json`.
