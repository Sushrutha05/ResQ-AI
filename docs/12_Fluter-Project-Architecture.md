# 12 - Flutter Project Architecture

> **Version:** 1.0
> **Framework:** Flutter
> **Architecture:** Feature First + Clean Architecture + Riverpod

---

# Purpose

This document defines the complete Flutter project architecture for ResQ AI.

It standardizes:

* Folder structure
* Layer responsibilities
* State management
* Dependency injection
* Navigation
* Shared components
* Naming conventions

Every feature must follow this architecture.

---

# Architecture Principles

The project follows these principles:

* Feature-first organization
* Separation of concerns
* Reusable components
* Testability
* Scalability
* Minimal coupling

Business logic must never live inside widgets.

---

# High-Level Folder Structure

```text
lib/
│
├── app/
│   ├── app.dart
│   ├── router.dart
│   ├── theme.dart
│   └── providers.dart
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── network/
│   ├── services/
│   ├── utils/
│   ├── widgets/
│   └── models/
│
├── features/
│
│   ├── authentication/
│   ├── dashboard/
│   ├── tasks/
│   ├── planner/
│   ├── scheduler/
│   ├── risk/
│   ├── coach/
│   ├── rescue/
│   ├── calendar/
│   ├── reflection/
│   ├── notifications/
│   └── profile/
│
├── ai/
│
│   ├── orchestrator/
│   ├── planner/
│   ├── scheduler/
│   ├── risk/
│   ├── coach/
│   ├── rescue/
│   ├── reflection/
│   └── prompts/
│
└── main.dart
```

---

# Feature Structure

Every feature follows the same layout.

Example:

```text
tasks/

├── data/
│   ├── models/
│   ├── repositories/
│   ├── datasources/
│   └── dto/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   ├── usecases/
│   └── services/
│
├── presentation/
│   ├── screens/
│   ├── widgets/
│   ├── providers/
│   └── controllers/
│
└── routes.dart
```

---

# Layer Responsibilities

## Presentation

Contains only UI.

Allowed:

* Widgets
* Screens
* Dialogs
* Animations

Not allowed:

* Firestore queries
* AI requests
* Business logic

---

## Domain

Contains business logic.

Includes:

* Entities
* Use Cases
* Interfaces

Independent of Flutter.

---

## Data

Responsible for:

* Firestore
* Gemini
* APIs
* Local Cache

Implements repository interfaces.

---

# Riverpod Structure

Every feature owns its providers.

Example:

```text
tasks/

presentation/

providers/

task_provider.dart

task_list_provider.dart

task_detail_provider.dart
```

No global providers unless absolutely necessary.

---

# Routing

GoRouter structure:

```text
/

↓

login

↓

dashboard

↓

tasks

↓

task/:id

↓

calendar

↓

assistant

↓

profile
```

Routes should be declarative and centralized.

---

# Shared Widgets

Reusable widgets belong in:

```text
core/widgets/
```

Examples:

* PrimaryButton
* AppCard
* LoadingIndicator
* RiskBadge
* ProgressRing
* TimelineTile

Avoid duplicating UI components.

---

# Theme Structure

```text
theme/

colors.dart

typography.dart

spacing.dart

shadows.dart

theme.dart
```

Never hardcode colors or font sizes.

Always use design tokens.

---

# Services

Global services:

```text
services/

auth_service.dart

firestore_service.dart

notification_service.dart

calendar_service.dart

analytics_service.dart
```

Services should remain lightweight.

---

# AI Layer

AI-related code lives outside feature modules.

```text
ai/

planner/

risk/

scheduler/

coach/

orchestrator/

prompts/
```

This makes AI replaceable in the future.

---

# State Management

Preferred order:

UI

↓

Provider

↓

Use Case

↓

Repository

↓

Datasource

↓

Firestore/API

Never skip layers without a good reason.

---

# Dependency Injection

Use Riverpod Providers.

Avoid singleton classes where possible.

Dependencies should be injected—not created manually.

---

# Error Handling

Every async operation returns:

* Success
* Loading
* Error

The UI never catches raw exceptions.

---

# Model Naming

Examples:

```text
TaskModel

TaskEntity

TaskRepository

TaskRepositoryImpl

CreateTaskUseCase

TaskController

TaskProvider
```

Maintain consistent suffixes.

---

# File Naming

Use snake_case.

Examples:

```text
task_repository.dart

create_task_usecase.dart

dashboard_screen.dart

risk_badge.dart
```

---

# Widget Guidelines

Widgets should:

* Be small
* Be reusable
* Accept data through constructors
* Avoid hidden state

Extract widgets before they exceed ~200 lines.

---

# Code Style

Prefer:

* const constructors
* immutable classes
* extension methods
* composition over inheritance

Avoid:

* giant widgets
* deeply nested build methods
* duplicated code

---

# Feature Communication

Features communicate through:

* Providers
* Use Cases
* Repositories

Never access another feature's internals directly.

Example:

Dashboard can request task data through a repository, not by importing task UI files.

---

# Offline Strategy

Repositories should:

1. Read local cache
2. Fetch remote data
3. Sync changes

The UI should not know whether data is local or remote.

---

# Testing Structure

```text
test/

features/

core/

ai/

integration/

golden/
```

Mirror the `lib/` folder where practical.

---

# Generated Code

Store generated files alongside their sources.

Example:

```text
task_model.dart

task_model.freezed.dart

task_model.g.dart
```

Never edit generated files manually.

---

# Build Order

1. Core
2. Authentication
3. Tasks
4. Dashboard
5. AI
6. Calendar
7. Notifications
8. Reflection

Each layer builds on the previous one.

---

# Architecture Summary

```text
UI

↓

Provider

↓

Use Case

↓

Repository

↓

Datasource

↓

Firestore / Gemini / APIs
```

This flow should remain consistent across every feature.

---

# Definition of Good Architecture

A new developer should be able to:

* Find any file within seconds.
* Understand feature boundaries immediately.
* Add a new feature without restructuring the project.
* Replace an implementation (e.g., Firestore or Gemini) without changing unrelated layers.

Consistency is more valuable than cleverness.

The architecture should make the codebase predictable, easy to navigate, and easy to extend throughout the hackathon and beyond.
