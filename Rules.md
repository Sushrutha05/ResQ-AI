# RULES.md

# ResQ AI - AI Development Rules

## Purpose

This document defines the mandatory development rules for every AI coding session.

It acts as the permanent engineering guideline for the project.

Every implementation must follow these rules unless the user explicitly overrides them.

---

# Source of Truth

Before making any changes:

1. Read the relevant documents inside `/docs`.
2. Treat the documentation as the source of truth.
3. Never ignore architectural decisions defined in the documentation.
4. If documentation conflicts with existing code, explain the conflict before proceeding.
5. Never invent architecture that is not documented.

---

# Development Philosophy

This is **not** a CRUD application.

This is an **AI Productivity Operating System**.

Every feature should increase the user's probability of completing meaningful work before its deadline.

If a feature does not contribute toward this objective, question whether it belongs.

---

# General Rules

Always:

* Understand the requested task completely before coding.
* Explain your implementation approach.
* List the files that will be created or modified.
* Build incrementally.
* Keep commits small and focused.
* Preserve existing functionality.
* Follow existing naming conventions.
* Prefer readability over cleverness.

Never:

* Rewrite unrelated code.
* Rename files without reason.
* Introduce breaking architectural changes.
* Delete functionality unless explicitly requested.
* Create duplicate implementations.

---

# Architecture Rules

Follow:

* Feature-First Architecture
* Clean Architecture
* Repository Pattern
* Dependency Injection
* Separation of Concerns
* Modular AI Agent Architecture

Business logic must never exist inside UI widgets.

---

# Flutter Rules

Use:

* Flutter
* Riverpod
* GoRouter
* Material 3

Never:

* Query Firestore directly from widgets.
* Put business logic inside build methods.
* Hardcode theme values.
* Duplicate widgets.

Widgets should remain small and reusable.

---

# Backend Rules

Backend uses:

* Firebase Cloud Functions
* Firestore
* Firebase Authentication
* Firebase Cloud Messaging

Cloud Functions should:

* Validate requests
* Call repositories
* Orchestrate AI agents
* Update Firestore

Never:

* Store UI logic
* Duplicate frontend validation
* Mix multiple responsibilities

---

# Firestore Rules

Access Firestore only through repositories.

Do not access Firestore directly from:

* Screens
* Widgets
* Controllers

Always validate data before writing.

Prefer denormalized reads over expensive queries.

---

# AI Rules

The AI system consists of specialized agents.

Agents include:

* Orchestrator
* Planner
* Risk
* Scheduler
* Coach
* Rescue
* Reflection

Rules:

* Agents solve one problem only.
* Agents never call each other directly.
* The Orchestrator coordinates execution.
* Every AI decision must be explainable.
* Never fabricate information.

If confidence is low, request clarification instead of guessing.

---

# UI Rules

Always follow:

`05_UI_UX_Design_System.md`

Never:

* Hardcode colors.
* Hardcode spacing.
* Hardcode typography.
* Ignore accessibility.

Use design tokens.

Prefer reusable widgets.

---

# Code Style

Prefer:

* Immutable models
* Const constructors
* Extension methods
* Composition
* Descriptive names
* Small files

Avoid:

* Giant classes
* Deep widget trees
* Nested callbacks
* Global mutable state

---

# File Organization

Every feature belongs inside:

features/

Following:

data/

domain/

presentation/

Shared widgets belong inside:

core/widgets/

AI code belongs inside:

ai/

Never mix these responsibilities.

---

# State Management

Use Riverpod.

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

Never skip layers without justification.

---

# Error Handling

Every async operation must handle:

* Loading
* Success
* Error

Never expose raw exceptions to users.

Provide meaningful messages.

---

# Performance Rules

Optimize for:

* Fast startup
* Minimal rebuilds
* Efficient Firestore reads
* Lazy loading
* Reusable widgets

Avoid premature optimization.

---

# Security Rules

Never trust client input.

Validate everything server-side.

Never expose:

* API keys
* Secrets
* Internal identifiers

Follow Firestore Security Rules.

---

# Documentation

Every major class should include documentation.

Every complex function should explain:

* Purpose
* Inputs
* Outputs

Avoid unnecessary comments.

Write self-explanatory code.

---

# Testing Mindset

Write code that is testable.

Avoid tightly coupled implementations.

Prefer dependency injection.

Avoid static state.

---

# AI Prompting Rules

When implementing a feature:

1. Read the relevant documentation.
2. Explain the implementation plan.
3. List affected files.
4. Implement only the requested feature.
5. Verify consistency.
6. Suggest the next logical task.

Never attempt to build the entire application in one response.

---

# Feature Implementation Order

Unless instructed otherwise:

1. Foundation
2. Authentication
3. Dashboard
4. Tasks
5. Planner
6. Risk
7. Scheduler
8. Coach
9. Rescue
10. Reflection
11. Calendar
12. Notifications
13. Polish

---

# Commit Philosophy

One feature = One commit.

Suggested format:

feat(scope): description

Examples:

feat(tasks): add task repository

feat(risk): implement completion probability

fix(schedule): resolve overlapping blocks

refactor(core): extract shared widgets

---

# Code Review Checklist

Before completing any task, verify:

* Project builds successfully.
* No architecture violations.
* No duplicate code.
* No unnecessary dependencies.
* No broken navigation.
* No unused imports.
* No analyzer warnings.
* UI follows design system.
* Business logic is outside widgets.
* Firestore is accessed only through repositories.

---

# When Unsure

If documentation is ambiguous:

* Do not guess.
* Explain the ambiguity.
* Present possible approaches.
* Choose the least disruptive solution.

---

# Guiding Principle

The AI should behave like a senior software engineer joining an existing professional codebase.

Its goal is not to generate the most code.

Its goal is to generate the **right code**.

Every implementation should leave the project:

* More maintainable
* More modular
* More consistent
* Easier to extend

Quality is always preferred over quantity.
