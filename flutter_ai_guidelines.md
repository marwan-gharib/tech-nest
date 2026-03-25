# Flutter AI Engineering Guidelines

> Single source of truth for production-grade Flutter development.
> Read this document before starting any task. Follow all rules strictly.

---

## 1. Purpose & Scope

This document defines all engineering rules, architecture patterns, and workflow conventions that must be followed when building Flutter projects. It applies to both human developers and AI coding assistants. No rule in this document is optional.

**Core goal:**
- Clean, scalable, maintainable, production-ready code
- Consistent architecture across all features and team members
- Zero tolerance for shortcuts that create long-term technical debt

---

## 2. Clean Architecture

### 2.1 Folder Structure

```
lib/
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── endpoints.dart
│   │   ├── api_keys.dart
│   │   ├── links.dart
│   │   ├── assets.dart
│   │   └── ..etc
│   │
│   ├── cubits/             (shared cubits used across multiple features)
│   │   ├── connectivity/
│   │   │   ├── connectivity_cubit.dart
│   │   │   └── connectivity_state.dart
│   │   └── ..etc
│   │
│   ├── di/
│   │   └── service_locator.dart
│   │
│   ├── domain/        (shared domain objects used across multiple features)
│   │   ├── entities/
│   │   │   └── shared_entity.dart
│   │   ├── enums/
│   │   │   └── shared_enum.dart
│   │   └── params/
│   │       └── shared_params.dart
│   │
│   ├── error/
│   │   ├── exceptions.dart
│   │   ├── failures.dart
│   │   ├── handling/
│   │   │   ├── dio_error_handler.dart
│   │   │   └── error_handler.dart
│   │   └── mappers/
│   │       └── error_mapper.dart
│   │
│   ├── local/
│   │   ├── database/
│   │   │   ├── app_database.dart          (abstract)
│   │   │   └── sqflite_database.dart
│   │   └── secure/
│   │       ├── secure_storage_client.dart (abstract)
│   │       └── secure_storage_impl.dart
│   │
│   ├── network/
│   │   ├── api_client.dart               (abstract)
│   │   ├── dio_client.dart
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart
│   │       ├── error_interceptor.dart
│   │       └── logging_interceptor.dart
│   │
│   ├── routing/
│   │   ├── app_router.dart
│   │   └── routes.dart
│   │
│   ├── services/
│   │
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   ├── app_theme.dart
│   │   ├── cubit/
│   │   │   ├── theme_cubit.dart
│   │   │   └── theme_state.dart
│   │   ├── modes/
│   │   │   ├── light.dart
│   │   │   └── dark.dart
│   │   └── theme_extensions/
│   │
│   ├── utils/
│   └── widgets/
│
├── features/
│   └── feature_name/
│       ├── di/
│       │   └── feature_di.dart
│       │
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── remote/
│       │   │   │   ├── feature_remote_datasource.dart      (abstract — if needed)
│       │   │   │   └── feature_remote_datasource_impl.dart
│       │   │   └── local/
│       │   │       ├── feature_local_datasource.dart       (abstract — if needed)
│       │   │       └── feature_local_datasource_impl.dart
│       │   ├── models/
│       │   │   ├── feature_model.dart
│       │   │   ├── feature_cache_model.dart                (if needed)
│       │   │   └── sub_models/
│       │   └── repositories/
│       │       └── feature_repository_impl.dart
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   └── feature_entity.dart
│       │   ├── repositories/
│       │   │   └── feature_repository.dart                 (abstract)
│       │   └── usecases/
│       │       └── get_feature_usecase.dart
│       │
│       └── presentation/
│           ├── cubits/
│           │   ├── feature_list/
│           │   │   ├── feature_list_cubit.dart
│           │   │   └── feature_list_state.dart
│           │   ├── feature_detail/
│           │   │   ├── feature_detail_cubit.dart
│           │   │   └── feature_detail_state.dart
│           │   ├── feature_form/
│           │   │   ├── feature_form_cubit.dart
│           │   │   └── feature_form_state.dart
│           │   └── ...
│           ├── screens/
│           │   └── feature_screen.dart
│           └── widgets/
│               └── feature_widget.dart
│
└── main.dart
```

### 2.2 Notes on Key Folders

**core/cubits — shared cubits:**
- Place a Cubit in `core/cubits/` only when it is used by more than one feature, or when it manages a concern that belongs to the core of the app (e.g. connectivity status, global session state, push notification state).
- Each shared Cubit follows the same subfolder convention as feature Cubits: one subfolder per Cubit containing the cubit file and its state file.
- Cubits that are used exclusively within a single feature must stay inside that feature's `presentation/cubits/` folder — do not move them to core preemptively.
- Shared Cubits registered in DI follow the same rules: `lazySingleton` if the state must persist across the app lifetime, `factory` if each consumer needs a fresh instance.

**core/domain — shared domain objects:**
- Place entities, enums, and params in `core/domain/` only when they are referenced by more than one feature.
- `core/domain/entities/` — shared entity classes used across features (e.g. `UserEntity` if referenced by both auth and profile features).
- `core/domain/enums/` — shared enums used across features (e.g. `UserRole`, `OrderStatus`).
- `core/domain/params/` — shared parameter classes passed to use cases across features.
- If an entity, enum, or param is used exclusively within a single feature, it stays inside that feature's `domain/` folder. Do not move it to core until a second feature actually needs it.

**local storage:**
- `app_database.dart` is an abstract interface for sqflite — the rest of the app depends on this abstraction, not on sqflite directly.
- `sqflite_database.dart` is the concrete implementation.
- `secure_storage_client.dart` is an abstract interface for sensitive key-value data — implemented by `secure_storage_impl.dart` using `flutter_secure_storage`.

**feature DI:**
- Each feature owns its dependency registration inside `di/feature_di.dart`.
- The global `service_locator.dart` only registers core dependencies and calls each feature's DI function.
- This keeps the global file small and makes each feature fully self-contained.

**cubits folder:**
- Each Cubit and its corresponding State file live together inside their own subfolder under `cubits/`.
- Never mix multiple Cubits in the same folder without subfolders.

**models vs entities:**
- `feature_model.dart` — DTO in the data layer. Contains `fromJson`, `toJson`, and `fromEntity` / `toEntity` mappers. Never used outside the data layer.
- `feature_cache_model.dart` — separate DTO for local database serialization (sqflite maps). Only create this when local caching is actually required.
- `feature_entity.dart` — pure Dart class in the domain layer. No JSON, no Flutter imports, no serialization logic.
- Never use `feature_model.dart` directly in the presentation or domain layers — always map to `feature_entity.dart` first.

### 2.3 Layer Rules

**Data Layer** — Contains: models, remote/local datasources, repository implementations
- Models are DTOs — they map to/from domain entities
- Datasources handle only raw API/DB calls — no business logic
- Repository implementations coordinate between remote and local datasources
- Never expose data models outside the data layer

**Domain Layer** — Contains: entities, abstract repository interfaces, use cases
- Entities are pure Dart classes — no Flutter imports, no JSON logic
- Repository interfaces defined here, implemented in the data layer
- Each use case has a single `call()` method and one responsibility
- This layer has zero dependencies on other layers

**Presentation Layer** — Contains: Cubits/BLoCs, screens, widgets
- UI communicates only with Cubits — never with use cases directly
- Cubits call use cases and emit states
- Screens and widgets are stateless where possible
- No business logic in the UI layer — ever

### 2.4 Dependency Rules

| Allowed | Not Allowed | Reason |
|---|---|---|
| Presentation -> Domain | Presentation -> Data | UI must not touch DTOs |
| Data -> Domain | Domain -> Data | Domain stays pure |
| Features -> Core | Core -> Features | Core must be feature-agnostic |
| Feature A (via core) | Feature A -> Feature B | Features are independent |

---

## 3. SOLID Principles

All code must adhere to SOLID. These are non-negotiable engineering standards, not guidelines.

**S — Single Responsibility**
- Each class has exactly one reason to change
- A repository fetches data — it does not parse UI state
- A use case executes one business rule — nothing more
- If a class name has "And" in it, split it

**O — Open / Closed**
- Open for extension, closed for modification
- Add new use cases instead of bloating existing ones
- Use abstract classes and inheritance instead of if/else chains

**L — Liskov Substitution**
- Subclasses must be usable in place of their parent without breaking behavior
- Repository implementations must fully satisfy the abstract interface contract
- Never override a method and change its semantics

**I — Interface Segregation**
- Keep interfaces small and focused
- Do not force a class to implement methods it does not use
- Prefer multiple small abstract classes over one large one

**D — Dependency Inversion**
- Depend on abstractions, not concrete implementations
- Inject dependencies via constructor or get_it
- Cubits receive use case abstractions, not implementations

---

## 4. State Management (Cubit / BLoC)

### 4.1 When to Use What

| Use Cubit when... | Upgrade to BLoC when... |
|---|---|
| Feature has simple linear state flow | Multiple concurrent event streams needed |
| No complex event transformation required | Event debouncing / throttling required |
| State transitions are straightforward | Complex state machines or event queues |

### 4.2 Cubits Per Feature — Split by Responsibility

A feature must never have a single Cubit that handles all its logic. Split Cubits by responsibility within the same feature:

- `FeatureListCubit` — handles fetching and displaying a list
- `FeatureDetailCubit` — handles a single item's details and actions
- `FeatureFormCubit` — handles form inputs, validation, and submission

Each Cubit and its state file live in their own subfolder inside `presentation/cubits/`. This keeps each Cubit small, focused, and independently testable.

### 4.3 State Design — Two Valid Approaches

**Approach A — Sealed class states (recommended with `freezed`)**

Best for async operations with distinct phases (loading, success, failure). Use when the UI needs to render completely different layouts depending on the state. Use the `freezed` package to generate sealed unions — this eliminates boilerplate while preserving exhaustiveness checking and `copyWith` support. This is the preferred approach for most async feature states.

**Approach B — Single state class with `copyWith`**

Best for forms, filters, and screens that have many independent fields updating over time. Use when partial updates are frequent and sealed classes would produce too much boilerplate. Use `freezed` here as well to generate `copyWith` and equality automatically.

Choose the approach that best fits the use case. Do not force sealed states where `copyWith` is cleaner, and do not force a single state class where sealed states are more explicit.

### 4.4 General Cubit Rules

- Cubits call use cases only — not repositories, not datasources
- Never perform navigation, show dialogs, or call `BuildContext` inside a Cubit
- Use `BlocListener` for side effects (navigation, snackbars, dialogs)
- Use `BlocBuilder` only for UI rebuilds — always add `buildWhen` to avoid unnecessary rebuilds
- Use `BlocConsumer` only when both listener and builder are needed in the same widget

### 4.5 When Not to Use Cubit — Alternative State Management

Cubit and BLoC are the default state management approach for this project, but they are not the right tool for every situation. Use the best solution for the case at hand.

**Use `ValueNotifier` / `ValueListenableBuilder` when:**
- The state is a single value that changes over time (a counter, a boolean toggle, a selected index)
- The scope is purely local to one widget or one file
- Adding a Cubit would be significant overhead for a trivial piece of state

**Use `flutter_riverpod` when:**
- The state must be accessible from anywhere in the widget tree without explicit `BlocProvider` nesting
- The feature has complex dependency graphs that benefit from Riverpod's provider composition
- The team agrees to use Riverpod for a specific feature or module — do not mix Riverpod and Cubit randomly across the codebase; if Riverpod is adopted for a feature, apply it consistently within that feature
- Async data fetching with automatic caching and revalidation is needed (`AsyncNotifierProvider`, `FutureProvider`)

**Use `ChangeNotifier` when:**
- Riverpod or Cubit is too heavy and `ValueNotifier` is too simple — `ChangeNotifier` fits complex local state that has multiple fields but does not need a full Cubit
- The widget tree is small and scoped, and `ListenableBuilder` or `AnimatedBuilder` is sufficient

**Rules that apply regardless of which state management is used:**
- Business logic must never live in the UI layer — it belongs in the Cubit, Notifier, or equivalent
- State must be immutable or treated as immutable — mutate by emitting or notifying, never by directly changing fields
- Choose one approach per feature and apply it consistently — do not mix Cubit and Riverpod within the same feature
- Document the reason for using a non-default approach in a comment at the top of the relevant file

---

## 5. Routing (go_router)

- All routing is handled exclusively via the `go_router` package — no `Navigator.push` calls anywhere in the codebase
- `app_router.dart` contains the `GoRouter` instance and all route definitions
- `routes.dart` contains all route name/path constants — never hardcode route strings inline
- Use `ShellRoute` for nested navigation (e.g. bottom navigation bar)
- Pass only primitive parameters through routes — fetch full data inside the destination screen via its Cubit
- Handle redirect logic (auth guards) inside `GoRouter`'s `redirect` callback, not in widgets
- Cubits are injected at the route definition level via `BlocProvider` — not inside the screen widget itself

---

## 6. Dependency Injection (get_it)

- The global `core/di/service_locator.dart` registers only core, network, and local storage dependencies, then calls each feature's DI setup function
- Each feature registers its own dependencies in `features/feature_name/di/feature_di.dart`
- Use `lazySingleton` for services, repositories, datasources, and use cases
- Use `factory` for Cubits — a new instance is created every time a page is opened

**Why `factory` for Cubits and not `lazySingleton`:**
Using `lazySingleton` for a Cubit means the same instance (and its stale state) is reused every time the screen is opened. Using `factory` ensures a fresh Cubit with a clean initial state on every navigation.

**Injecting Cubits in the UI:**
- Do not call `sl<>()` inside widget `build()` methods or widget constructors
- Inject Cubits at the route definition level inside `app_router.dart` using `BlocProvider`
- This keeps screens clean, testable, and free of direct DI dependencies
- The router is the single place where `sl<>()` is called for Cubits

---

## 7. Networking (Dio)

- All Dio configuration lives in `core/network/dio_client.dart`
- Never import or call Dio directly from a Cubit, use case, or widget
- Use three interceptors: `AuthInterceptor`, `ErrorInterceptor`, `LoggingInterceptor`
- `AuthInterceptor`: attaches tokens to requests, handles 401 token refresh logic
- `ErrorInterceptor`: converts `DioException` into domain `Failure` objects
- `LoggingInterceptor`: active in debug mode only — disabled in release builds
- All endpoints are defined as constants in `core/constants/endpoints.dart`
- API responses are mapped to models in the data layer — never parse JSON in a Cubit
- Always set `connectTimeout`, `receiveTimeout`, and `sendTimeout`

---

## 8. Package Rules

- For models/entities/states: Prefer `freezed` + `json_serializable` when the class has many fields or needs `copyWith` / equality.
- Always run `build_runner` after changes and commit generated files.

| Required | Forbidden |
|---|---|
| Always use the latest stable version | Using an outdated version |
| Always specify the version number in pubspec.yaml | Leaving the version field empty |
| Package must be actively maintained | Abandoned packages (last update > 1 year with open critical issues) |
| Prefer Flutter Favorite or high pub.dev score | Packages with no documentation |
| Verify null-safety and Dart 3 compatibility | Forked or unpublished packages in production |

**Version format in `pubspec.yaml`:**
Always write the latest version number explicitly using the caret (`^`) format. Never leave the version field empty and never use `any`.

### 8.1 Package Deprecation & Replacement Protocol

Core packages can become deprecated, unmaintained, or break across Flutter/Dart SDK upgrades. When this happens, follow this protocol without exception:

**When a package shows any of these signals:**
- Marked as discontinued on pub.dev
- No updates for over 12 months with open breaking issues
- Incompatible with the current stable Flutter SDK
- Official Flutter or Dart team recommends migrating away from it

**What must happen:**
- Stop using that package immediately in any new code — do not add new usages even temporarily
- Identify the official or community-recommended replacement and evaluate it (pub.dev score, maintenance status, null-safety, Dart 3 compatibility)
- Migrate existing usages to the replacement package in a dedicated branch with a clear commit trail
- Update `pubspec.yaml`, regenerate any generated files if applicable, and run the full app to verify
- Update this document and any internal references to reflect the new package

**Known replacement paths (update as ecosystem evolves):**

| Package | Replacement if deprecated |
|---|---|
| `dio` | `http` + custom interceptor layer, or evaluate `chopper` |
| `get_it` | `auto_injectable` pattern, or Flutter's built-in `InheritedWidget` DI |
| `flutter_bloc` | Evaluate `riverpod` or `signals` depending on team familiarity |
| `go_router` | Currently the Flutter team's recommended solution — monitor `flutter/packages` for changes |
| `sqflite` | `drift` (type-safe, actively maintained) |
| `flutter_secure_storage` | Platform-specific keychain/keystore via `local_auth` or a successor package |
| `freezed` | Manual `copyWith` + `sealed` classes (Dart 3 native) |
| `fpdart` | Evaluate `result_dart` or native Dart patterns |

**Never keep a deprecated package in production** just because migration is inconvenient. Technical debt from delayed migrations compounds.

*This table will be updated whenever the Flutter/Dart ecosystem changes. Last review: March 2026.*

---

## 9. File, Class & Code Rules

### 9.1 One Class Per File — Strict Rule

Every file must contain exactly one class. No exceptions — with one strictly defined case:

- A `StatefulWidget` file contains exactly two classes: the widget class and its private `State` class. This is the only case where two classes may coexist in a single file, because they are inseparable by Flutter's design.
- No other multi-class combinations are allowed in any file under any circumstance.
- Enums and simple typedefs that directly support the single class in the file may be defined in the same file. If an enum is shared across multiple files, move it to its own file.

### 9.2 File Structure

- File name must match the primary class name in snake_case (`UserProfileCubit` -> `user_profile_cubit.dart`)
- Files must stay small and focused — if a file grows beyond ~150 lines, split it
- Break logic into small, reusable private methods
- Never create catch-all utility files — group utilities by domain

### 9.3 Naming Conventions

| Type | Convention | Example |
|---|---|---|
| Classes / Enums | PascalCase | `UserRepository`, `AuthState` |
| Variables / Functions | camelCase | `fetchUser()`, `isLoading` |
| Constants | camelCase or k-prefix | `kBaseUrl`, `maxRetries` |
| Files | snake_case | `user_repository_impl.dart` |
| Folders | snake_case | `features/auth/domain/` |
| Private members | `_` prefix | `_controller`, `_fetchData()` |

### 9.4 Import Ordering

Always order imports in this exact sequence with a blank line between groups:

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter framework
import 'package:flutter/material.dart';

// 3. External packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

// 4. Local project files
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/features/auth/domain/usecases/login_usecase.dart';
```

---

## 10. StatelessWidget vs StatefulWidget

Choosing the wrong widget type is a common source of unnecessary complexity and bugs. Default to `StatelessWidget` and only upgrade to `StatefulWidget` when there is a concrete, justified reason.

### 10.1 Use StatelessWidget When

- The widget has no local state — it only renders based on data passed to it via constructor parameters
- All state is managed externally by a Cubit, `ValueNotifier`, or a parent widget
- The widget does not need controllers, animation tickers, focus nodes, or lifecycle callbacks
- The widget can be `const` — if it can be `const`, it must be `StatelessWidget`

This should be the default choice for the vast majority of widgets in a Cubit-driven app.

### 10.2 Use StatefulWidget When

One or more of the following are genuinely required:

- **Controllers** — `TextEditingController`, `ScrollController`, `AnimationController`, `PageController`, or any controller that must be initialized and disposed within the widget's lifecycle
- **Animation** — `SingleTickerProviderStateMixin` or `TickerProviderStateMixin` is needed for `AnimationController`
- **Focus management** — `FocusNode` that is created and disposed locally
- **`initState` / `didChangeDependencies` / `didUpdateWidget`** — when initialization logic must run exactly once on mount, or when the widget must react to dependency changes
- **Local ephemeral UI state** — state that is genuinely local to this single widget, will never be needed elsewhere, and does not belong in a Cubit (e.g. a visibility toggle for a password field, a local expansion state)

Do not use `StatefulWidget` as a shortcut to avoid creating a Cubit. If state needs to be shared, persisted, or tested, it belongs in a Cubit — not in a `State` class.

### 10.3 Widget Lifecycle Management

When using `StatefulWidget`, every resource created in the `State` class must be properly managed across the full lifecycle:

**`initState`:**
- Initialize controllers, animation objects, and focus nodes here
- Call `super.initState()` as the first line
- Do not call async methods directly here — trigger them via `WidgetsBinding.instance.addPostFrameCallback` or schedule them through the Cubit

**`dispose`:**
- Dispose every controller, animation, and focus node created in `initState` — no exceptions
- Call `super.dispose()` as the last line
- Never access `context` after `dispose` has been called

**`didUpdateWidget`:**
- Use this to react when the widget's configuration changes and the controller or resource needs to be updated accordingly

**`didChangeDependencies`:**
- Use this when the widget depends on an `InheritedWidget` that may change

**Controller disposal checklist — always dispose the following when created locally:**
- `TextEditingController`
- `ScrollController`
- `AnimationController`
- `PageController`
- `TabController`
- `FocusNode`
- `StreamSubscription`

Failing to dispose controllers causes memory leaks. Lint rules (`flutter_lints`) will catch some of these — treat all lint warnings as errors and fix them before merging.

---

## 11. Code Quality & Best Practices

### 11.1 General Rules

- Write code that reads like documentation — naming must eliminate the need for comments
- Comments only when explaining WHY, never WHAT (the code explains what)
- Avoid magic numbers — define named constants
- Prefer explicit over clever — readable code beats clever code
- Delete dead code — do not comment it out

### 11.2 DRY (Don't Repeat Yourself)

- If the same logic appears twice, extract it to a shared utility, extension, or base class
- Shared widgets go in `core/widgets/`
- Shared utilities go in `core/utils/`
- Do not copy-paste code between features — abstract it to core

### 11.3 Abstraction Rules

Abstraction must be a deliberate decision, not a default reflex. Applying it incorrectly adds complexity without value.

**When abstraction is required:**
- Repository interfaces in the domain layer — always required, enables DI and testability
- `ApiClient` in `core/network/` — always required, enables swapping the HTTP client without touching features
- `AppDatabase` and `SecureStorageClient` in `core/local/` — always required, decouples features from specific storage engines

**When abstraction is optional (only add if there is a real reason):**
- Datasource interfaces inside features — only create `feature_remote_datasource.dart` (abstract) if the feature genuinely needs to be testable in isolation, or if a second implementation is planned. For simple features with no testing requirement, skip the interface and create only the implementation.
- Service classes in `core/services/` — only abstract if more than one implementation exists or is planned

**When abstraction must not be used:**
- Do not create an abstract class for a class that will only ever have one implementation and is not tested with mocks
- Do not create base classes just to share a few lines of code — use composition or extension methods instead
- Do not abstract purely for the appearance of "clean architecture" — every abstract layer must serve a concrete purpose

**Core folder files specifically:** When creating new files in `core/`, do not default to creating an abstract interface unless the abstraction provides genuine value per the rules above. A utility class, a constants file, a helper, or a single-purpose service does not need an interface.

### 11.4 Error Handling

- Use the `Either<Failure, Success>` pattern from the `fpdart` package (preferred over `dartz` for better documentation and maintenance)
- Define all Failure types in `core/error/failures.dart` (`NetworkFailure`, `ServerFailure`, `CacheFailure`, etc.)
- Never let `DioException` bubble up past the data layer — convert in `ErrorInterceptor` or repository
- Always handle edge cases — never assume valid input or a successful network response
- Use `try/catch` only at the datasource level — propagate via `Either` above that
- **Error messages shown to the user must be clear, human-readable, and meaningful:**
  - Never show raw exception messages, stack traces, or developer-oriented output to the user
  - Never show generic messages like "Unknown error" or "Something went wrong" without context
  - Every `Failure` type must carry a message that explains what happened in plain language
  - Messages must indicate what went wrong and ideally what the user can do next
  - Wrong: `"SocketException: Connection refused"` — Right: `"No internet connection. Please check your network and try again."`
  - Wrong: `"500 Internal Server Error"` — Right: `"Something went wrong on our side. Please try again later."`

### 11.5 Debugging Strategy

- Fix the root cause — never suppress errors with empty catch blocks
- Understand the full call chain before writing a fix
- No TODO comments in production code — either fix it now or create a tracked issue
- Avoid temporary hacks — if a workaround is necessary, document it and create a cleanup task

---

## 12. Widget & Screen Decomposition

This is one of the most impactful rules for keeping a codebase readable and maintainable. A screen or widget file should never be a monolith.

### 12.1 Screen Responsibility

- A screen file is an orchestrator — it assembles smaller widgets and connects them to the Cubit
- A screen's `build()` method should be short — ideally under 30 lines
- A screen must not contain inline widget trees more than 2–3 levels deep without extracting
- Logic (formatting, conditions, calculations) must not live inside `build()` — extract to methods or the Cubit

### 12.2 When to Extract a Widget into a Separate Class

Extract a piece of UI into its own `StatelessWidget` or `StatefulWidget` class when any of the following is true:
- It is reused in more than one place
- It has its own distinct visual identity or responsibility (a card, a header, an empty state view, a list item)
- It would make the parent's `build()` method shorter and more readable
- It benefits from `const` construction — extracting enables `const`, which prevents unnecessary rebuilds
- It needs its own lifecycle (animations, controllers, focus nodes)

Do not hesitate to extract a widget just because it is small. A 10-line widget in its own file is always preferable to bloating the parent.

### 12.3 When to Use a Private Method Instead of a Separate Class

Use a private `Widget _buildSomething()` method (not a separate class) only when:
- The piece of UI is tightly coupled to the parent's local state or variables and cannot be passed as constructor parameters cleanly
- It will never be reused outside the current file
- It is a minor visual grouping with no independent behavior

Even then, keep the method short. If it grows beyond ~15 lines, it is a signal to convert it to a separate class.

### 12.4 Splitting Logic into Methods

Every class — widget, Cubit, repository, datasource — must decompose its logic into small, named methods:
- Each method does one thing and has a name that describes exactly what it does
- No method should exceed ~20–25 lines — if it does, extract sub-steps into separate private methods
- Avoid deeply nested logic (more than 2 levels of if/for/try nesting) — extract inner blocks into named methods
- Computed values that require more than one expression belong in a named getter or method, not inline in `build()`

### 12.5 Method & Attribute Visibility — Public vs Private

**Make a method or attribute private (prefix with `_`) when:**
- It is an implementation detail of the class that callers should never depend on
- It is a helper used only within the same file
- Exposing it would violate encapsulation (e.g. internal controllers, internal state variables)

**Make a method or attribute public when:**
- It is part of the class's intentional API — something a caller legitimately needs to invoke or read
- It is required by an interface or abstract class contract
- It is a Cubit method that the UI calls (`loadData()`, `submitForm()`, etc.)

**Rules:**
- Default to private — only promote to public when there is a clear reason
- Never expose internal helpers as public methods just for convenience
- Widget fields passed in as constructor parameters are always public
- Internal controllers (`TextEditingController`, `ScrollController`, etc.) are always private
- Cubit-facing methods are always public; internal helper methods called only from within the Cubit are always private

---

## 13. Flutter Performance

- Use `const` constructors everywhere possible — prevents unnecessary rebuilds
- `BlocBuilder`: always use `buildWhen` to limit rebuilds to relevant state changes only
- Split large widgets into smaller dedicated widget classes to minimize rebuild scope
- Use `ListView.builder` / `GridView.builder` for any list longer than a few items
- Avoid building sub-widgets inside `build()` — extract to separate widget classes or fields
- Use `RepaintBoundary` on heavy animated widgets to isolate repaint
- Profile with Flutter DevTools before optimizing — do not guess
- Use `cached_network_image` for network images — always specify width/height
- **`setState` usage rules:**
  - Use `setState` only in small, fully self-contained widgets where the entire widget must rebuild on every change
  - If the widget has more than 2–3 fields, or if only part of it needs to rebuild, do not use `setState`
  - For anything beyond a trivial local UI toggle, prefer `ValueNotifier` / `ValueListenableBuilder` or a Cubit
  - Never use `setState` to manage data that is shared between widgets or screens

---

## 14. Deprecated Code — Zero Tolerance Policy

Using deprecated APIs, widgets, parameters, or packages is not allowed under any circumstance.

- **Never use a deprecated Flutter or Dart API** — if the framework emits a deprecation warning, fix it before merging
- **Never use a deprecated widget** (e.g. `FlatButton`, `RaisedButton`, etc.) — always use the current equivalent
- **Never use deprecated constructor parameters** — read the migration guide and apply the updated API immediately
- **Never use a deprecated package** — follow the replacement protocol defined in section 8.1
- When upgrading Flutter or Dart SDK versions, immediately audit the codebase for newly introduced deprecations and resolve them in a dedicated chore commit before continuing feature work
- Deprecation warnings in the IDE must be treated as errors — do not ignore them, do not suppress them, fix them

---

## 15. Theming

- All theme-related code lives exclusively in `core/theme/`
- `app_colors.dart`: defines all color constants as `static const` values
- `app_text_styles.dart`: defines all `TextStyle` constants
- `app_theme.dart`: builds `ThemeData` from colors and text styles
- `light.dart` / `dark.dart`: contain light and dark mode `ThemeData` instances
- `theme_cubit.dart`: manages runtime theme switching
- Theme extensions: use for custom design tokens not covered by `ThemeData`
- Never define colors, font sizes, or spacing inline in widget code
- Never use hardcoded hex strings inside widgets — always reference `app_colors.dart`

---

## 16. Security

- Never store secrets, tokens, or sensitive data in `SharedPreferences` or plain local files
- Use `flutter_secure_storage` via the `SecureStorageClient` abstraction for all sensitive data at rest
- Never log tokens, passwords, or PII — `LoggingInterceptor` must redact auth headers
- Do not hardcode API keys, base URLs, or credentials in source code — use `core/constants/api_keys.dart` loaded via `--dart-define`
- Validate all user input on the domain layer before sending to APIs

---

## 17. Git Workflow

- One branch per feature or fix — never work directly on `main` or `develop`
- Branch naming: `feature/feature-name`, `fix/bug-name`, `chore/task-name`
- Commit messages follow Conventional Commits format
- Commits must be atomic — one logical change per commit
- Open a Pull Request when the feature is complete and tested
- PR title describes what changed; PR description explains why
- No self-merge — code review required before merging
- Rebase onto the target branch before opening a PR to keep history clean

**Conventional Commit Examples:**

```
feat(auth): add biometric login support
fix(network): handle 504 timeout in error interceptor
refactor(home): extract product card into separate widget
chore(deps): update dio and flutter_bloc
test(auth): add unit tests for login use case
```

---

## 18. AI Assistant Behavior Rules

### 18.1 Existing Project Compatibility

**This is the most critical rule for AI assistants working on existing codebases:**

If the project being worked on does not follow this document's architecture, the AI must continue working within the project's existing pattern. Do not attempt to refactor or restructure the project to match these guidelines mid-task. Mixing two different architectural patterns in the same project causes conflicts, inconsistencies, and bugs that are expensive to fix. These guidelines apply to new projects or new features added from scratch.

### 18.2 Code Changes

- Never rewrite an entire file for a small change — modify only the affected lines
- Always read the existing file structure before generating new code
- Generated code must match the existing naming, formatting, and architecture conventions
- Do not add packages unless explicitly requested — check `pubspec.yaml` first
- Never remove existing code or comments unless explicitly asked to

### 18.3 Output Standards

- Generate clean, production-ready code from the first attempt
- Do not add unnecessary explanatory comments in generated code
- Do not include TODO or FIXME in generated code — complete the implementation
- Follow all naming and structure rules defined in this document
- Every generated class must comply with SOLID and Clean Architecture
- Never generate deprecated APIs, widgets, parameters, or patterns — always use the current Flutter/Dart equivalent
- Apply widget decomposition rules from section 12 — never generate a monolithic screen or widget
- Apply `StatelessWidget` vs `StatefulWidget` rules from section 10 — never default to `StatefulWidget`
- Every `StatefulWidget` generated must include proper `dispose()` for all controllers created in `initState`

### 18.4 Collaboration

- Act as a senior team member, not just a code generator
- If a requirement is ambiguous, ask for clarification before generating
- If the requested approach violates these guidelines, flag it and suggest the correct approach
- If an improvement to existing code is spotted, mention it — do not silently ignore it
- If rules conflict, always choose the simplest, most maintainable solution

---

> **Read this document before starting any task. Follow all rules strictly.**
>
> **Goal:** ***Clean | Scalable | Maintainable | Production-Ready***
