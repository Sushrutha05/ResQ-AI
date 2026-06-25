# 11 - Vibecoding Prompt Library

> **Version:** 1.0
> **Status:** Ready for Development

---

# Purpose

This document contains production-ready prompts for AI coding assistants such as:

* Cursor
* Claude Code
* Gemini CLI
* Jules
* GitHub Copilot Agent

Each prompt is designed to complete **one well-defined engineering task** while preserving project consistency.

---

# Global Prompt Rules

Prepend the following instructions to **every** development prompt:

---

You are a senior Flutter engineer working on **ResQ AI**, an AI-powered productivity operating system.

Before generating code:

* Read the existing project structure.
* Preserve architectural consistency.
* Follow the design system.
* Do not introduce unnecessary dependencies.
* Keep business logic out of the UI.
* Use Riverpod for state management.
* Follow Clean Architecture.
* Generate readable, maintainable code.
* Add documentation where appropriate.
* Avoid placeholder implementations unless explicitly requested.
* Do not modify unrelated files.
* If requirements are unclear, explain assumptions before coding.

Always produce production-quality code.

---

# Prompt 01 — Initialize Project

## Goal

Create the project foundation.

---

### Tasks

* Create Flutter project
* Configure folders
* Configure linting
* Setup Riverpod
* Setup GoRouter
* Setup Firebase
* Configure themes

---

### Acceptance Criteria

Application launches successfully.

---

# Prompt 02 — Authentication

## Goal

Implement authentication.

---

### Requirements

* Firebase Auth
* Google Sign-In
* Email Login
* Session persistence
* Logout

---

### Do Not

* Build Dashboard
* Add Firestore logic

---

# Prompt 03 — Design System

Implement

* Colors
* Typography
* Theme
* Buttons
* Cards
* Chips
* Navigation

Must follow

05_UI_UX.md

---

# Prompt 04 — Navigation

Implement

Bottom Navigation

Dashboard

Tasks

Calendar

AI

Profile

Use GoRouter.

---

# Prompt 05 — Firestore Models

Generate

User

Task

Subtask

Schedule

RiskScore

Reflection

Notification

Use Freezed + JSON serialization.

---

# Prompt 06 — Repository Layer

Implement repositories.

Do not call Firestore directly from UI.

---

# Prompt 07 — Task CRUD

Create

Edit

Delete

Read

Realtime updates

---

# Prompt 08 — Planner Agent Integration

Connect Gemini.

Implement

Task parsing

Subtask generation

Duration estimation

---

# Prompt 09 — Risk Engine

Generate

Completion probability

Risk explanations

Confidence score

---

# Prompt 10 — Scheduler

Create

Daily schedule

Conflict detection

Break insertion

---

# Prompt 11 — Dashboard

Build

Today's timeline

Success score

Recommendations

High-risk tasks

Upcoming deadlines

---

# Prompt 12 — Task Details

Display

Subtasks

Risk

AI plan

History

---

# Prompt 13 — Coach Agent

Implement

Daily recommendations

Motivational messages

Next action

---

# Prompt 14 — Rescue Mode

Automatically trigger

Recovery plan

Emergency banner

Timeline compression

---

# Prompt 15 — Calendar

Google Calendar

Import

Sync

Conflict detection

---

# Prompt 16 — Notifications

Firebase Cloud Messaging

AI notifications

Rescue notifications

Daily summaries

---

# Prompt 17 — Reflection

Generate

Daily summary

Weekly insights

Productivity analysis

---

# Prompt 18 — Loading States

Implement

Skeletons

Progress indicators

Animated placeholders

---

# Prompt 19 — Error Handling

Handle

Offline

Gemini errors

Firestore errors

Calendar failures

Authentication failures

---

# Prompt 20 — Animations

Implement

Page transitions

Task completion

Card expansion

Timeline updates

Rescue banner

---

# Prompt 21 — Responsive Layout

Support

Phone

Tablet

Desktop

---

# Prompt 22 — Accessibility

Implement

Large text

Screen readers

Keyboard navigation

Semantic widgets

---

# Prompt 23 — Unit Tests

Generate

Repository tests

Provider tests

Utility tests

---

# Prompt 24 — Integration Tests

Generate

Authentication flow

Task creation

Planner

Scheduler

Rescue

---

# Prompt 25 — Performance

Optimize

Firestore reads

Widget rebuilds

Caching

Lazy loading

Pagination

---

# Prompt Template

Every future prompt should follow this structure.

---

## Objective

One clear sentence.

---

## Context

Reference:

* PRD
* Architecture
* Database
* Design System

---

## Requirements

Bullet list.

---

## Constraints

Things the AI must not change.

---

## Deliverables

Files created.

Files modified.

---

## Acceptance Criteria

Definition of Done.

---

## Suggested Commit Message

Provide one.

---

# Example Prompt

## Objective

Implement the Dashboard screen.

---

## Context

Use:

* 04_Information_Architecture.md
* 05_UI_UX.md
* 07_Database.md

---

## Requirements

Display:

* Success Score
* Timeline
* AI Recommendations
* High-Risk Tasks

Use Riverpod.

No mock data.

---

## Constraints

Do not modify authentication.

Do not change routing.

---

## Deliverables

DashboardScreen

DashboardCard

TimelineWidget

RecommendationCard

---

## Acceptance Criteria

Dashboard loads successfully.

Firestore connected.

Widgets reusable.

---

## Commit

```text id="a7t8kt"
feat(dashboard): implement dashboard overview
```

---

# AI Prompting Guidelines

Always:

* Build incrementally.
* Keep commits small.
* Explain architectural decisions.
* Respect existing code.
* Prefer composition over duplication.

Never:

* Rewrite unrelated code.
* Introduce breaking changes.
* Ignore architecture.
* Mix UI with business logic.

---

# Review Checklist

Before accepting AI-generated code:

* Compiles successfully
* Lints successfully
* Uses correct architecture
* Matches design system
* Uses reusable widgets
* Handles loading/errors
* No duplicated logic

---

# Development Workflow

```text id="a6msq7"
Select Prompt

↓

Generate Code

↓

Review

↓

Run

↓

Fix

↓

Commit

↓

Next Prompt
```

---

# Guiding Principle

AI should act like a senior teammate—not an autocomplete tool.

Every prompt should produce code that is:

* Modular
* Testable
* Explainable
* Production-ready
* Easy to extend

Small, high-quality iterations will always outperform one massive prompt that attempts to build the entire application.
