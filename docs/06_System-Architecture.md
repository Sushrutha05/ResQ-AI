# 06 - System Architecture

> **Version:** 1.0
> **Status:** Draft

---

# Purpose

This document defines the technical architecture of ResQ AI.

It explains:

* System components
* Service responsibilities
* Data flow
* AI orchestration
* External integrations
* Scalability strategy
* Security principles

This architecture is designed to support the Hackathon MVP while remaining extensible for future growth.

---

# High-Level Architecture

```text
                     ┌────────────────────┐
                     │    Flutter App     │
                     └─────────┬──────────┘
                               │
                    Firebase Authentication
                               │
                               ▼
                    ┌────────────────────┐
                    │    Firestore DB    │
                    └─────────┬──────────┘
                              │
                    Cloud Functions Backend
                              │
       ┌──────────────┬──────────────┬──────────────┐
       ▼              ▼              ▼
 Planner Service   Risk Engine   Scheduler Engine
       │              │              │
       └──────────────┴──────────────┘
                      │
              Orchestrator Service
                      │
              Gemini API Integration
                      │
 ┌──────────────┬───────────────┬───────────────┐
 ▼              ▼               ▼
Google      Firebase FCM     Calendar API
Calendar      Notifications
```

---

# Architecture Goals

The system should be:

* Modular
* Event-driven
* AI-first
* Cloud-native
* Explainable
* Scalable

---

# Core Components

## 1. Flutter Client

### Responsibilities

* Authentication
* UI rendering
* Offline cache
* User interactions
* Display AI recommendations
* Timeline visualization

The client contains **no business logic**.

Business logic belongs in backend services.

---

## 2. Firebase Authentication

Used for:

* Email authentication
* Google Sign-In
* Session management

Every Firestore document is scoped to a user.

---

## 3. Firestore

Acts as the primary datastore.

Stores:

* Users
* Tasks
* Subtasks
* Schedules
* Risk scores
* AI decisions
* Reflections
* Preferences

Firestore also acts as the communication layer between services.

---

## 4. Cloud Functions

Cloud Functions serve as the application's backend.

Responsibilities:

* Execute AI workflows
* Validate requests
* Trigger agents
* Call Gemini
* Update Firestore
* Send notifications

The mobile app never communicates directly with Gemini.

---

# AI Architecture

## Orchestrator

The Orchestrator coordinates every AI workflow.

It determines:

* Which agent should execute
* Execution order
* Shared context
* Final output

The Orchestrator does not generate user-facing content.

It delegates.

---

## Planner Service

Input

Natural language task

Output

Structured task

Responsibilities

* Extract title
* Detect deadline
* Estimate duration
* Generate subtasks
* Determine complexity

---

## Risk Engine

Input

Task

Calendar

History

Output

Success probability

Responsibilities

* Predict completion risk
* Detect overload
* Trigger Rescue Mode

---

## Scheduler Engine

Input

Tasks

Calendar

Working hours

Risk

Output

Daily schedule

Responsibilities

* Create timeline
* Allocate work blocks
* Resolve conflicts

---

## Coach Service

Responsibilities

* Daily suggestions
* AI explanations
* Accountability
* Motivation

The Coach never changes schedules.

It only communicates.

---

## Rescue Service

Responsibilities

* Emergency replanning
* Task reprioritization
* Recovery plan generation

---

## Reflection Service

Runs after task completion.

Updates:

* Duration estimates
* Productivity patterns
* Historical insights

---

# Event Flow

Everything in the system is event-driven.

Example:

```text
Task Created

↓

Cloud Function Trigger

↓

Planner Service

↓

Risk Engine

↓

Scheduler

↓

Firestore Updated

↓

Flutter Dashboard Refreshes
```

---

# Daily Monitoring Flow

```text
Calendar Change

↓

Trigger

↓

Risk Recalculated

↓

Schedule Updated

↓

Coach Notification

↓

Dashboard Refresh
```

---

# Rescue Flow

```text
Risk Score < Threshold

↓

Rescue Triggered

↓

Recovery Plan Generated

↓

Schedule Updated

↓

Notification Sent

↓

Dashboard Updated
```

---

# External Integrations

## Gemini API

Used for:

* Task understanding
* Planning
* Explanations
* Reflections
* Natural language conversations

---

## Google Calendar

Read

* Meetings
* Classes
* Busy time

Write

* Focus blocks
* AI schedule

---

## Firebase Cloud Messaging

Used for

* Rescue alerts
* AI suggestions
* Daily summaries

---

# Security Principles

Every request:

* Authenticated
* Authorized
* Logged

AI should never access another user's data.

Firestore Security Rules enforce document ownership.

---

# Error Handling

If Gemini fails:

* Retry
* Fallback response
* Manual task editing

If Calendar fails:

* Continue using local schedule

If Notification fails:

* Retry asynchronously

---

# Scalability

Future architecture should support:

* Multiple AI providers
* Team collaboration
* Shared workspaces
* Wearables
* Desktop application
* Browser extension

No architectural redesign should be required.

---

# Performance Targets

Dashboard

< 2 seconds

Task creation

< 3 seconds

AI planning

< 5 seconds

Schedule generation

< 3 seconds

Rescue activation

< 2 seconds

---

# Offline Support

The Flutter client should cache:

* Tasks
* Today's schedule
* Calendar snapshot

Offline users can:

* Create tasks
* Mark completion
* View timeline

Synchronization occurs automatically once connectivity returns.

---

# Logging

Every AI decision should be logged.

Example

Planner

↓

Generated 5 subtasks

↓

Confidence 91%

↓

Execution Time 1.8s

This improves debugging and explainability.

---

# Future Architecture

Future services may include:

* Email Agent
* Habit Engine
* Finance Agent
* Health Engine
* Browser Extension
* Smartwatch Companion

The Orchestrator remains the central coordinator.

---

# Technology Stack

| Layer           | Technology               |
| --------------- | ------------------------ |
| Frontend        | Flutter                  |
| Authentication  | Firebase Auth            |
| Database        | Cloud Firestore          |
| Backend         | Firebase Cloud Functions |
| AI              | Gemini 2.5 Pro / Flash   |
| Notifications   | Firebase Cloud Messaging |
| Calendar        | Google Calendar API      |
| Analytics       | Firebase Analytics       |
| Storage         | Firebase Storage         |
| Crash Reporting | Firebase Crashlytics     |

---

# Architectural Principles

1. Keep business logic on the backend.
2. AI services remain modular.
3. Every AI decision is explainable.
4. Communication is event-driven.
5. Components remain loosely coupled.
6. Every service has one clear responsibility.

---

# Architecture Summary

```text
Flutter UI
      │
      ▼
Firebase Backend
      │
      ▼
Cloud Functions
      │
      ▼
Orchestrator
      │
      ▼
Specialized AI Agents
      │
      ▼
Firestore + External Google Services
```

This architecture keeps the MVP simple while demonstrating a production-inspired, modular AI system that aligns well with the hackathon's focus on agentic intelligence.
