# 13 - Backend & Cloud Functions Architecture

> **Version:** 1.0
> **Backend:** Firebase Cloud Functions (Gen 2)
> **Database:** Cloud Firestore
> **Status:** Draft

---

# Purpose

This document defines the backend architecture of ResQ AI.

It specifies:

* Cloud Functions organization
* AI orchestration
* Firestore triggers
* HTTPS APIs
* Background jobs
* Logging
* Security
* Retry strategy
* Deployment strategy

The backend should remain stateless, scalable, and event-driven.

---

# Design Principles

Backend responsibilities:

* Authenticate requests
* Validate input
* Orchestrate AI agents
* Update Firestore
* Trigger workflows
* Notify users

Backend should NOT:

* Store UI state
* Contain presentation logic
* Duplicate frontend validation

---

# High Level Architecture

```text
Flutter App

↓

Firebase Auth

↓

HTTPS Cloud Function

↓

Orchestrator

↓

Planner

↓

Risk

↓

Scheduler

↓

Firestore

↓

Notification

↓

Dashboard Refresh
```

---

# Backend Folder Structure

```text
functions/

│

├── src/

│

├── config/

├── middleware/

├── routes/

├── orchestrator/

├── agents/

│     planner/

│     scheduler/

│     risk/

│     coach/

│     rescue/

│     reflection/

│

├── services/

│

├── repositories/

│

├── firestore/

│

├── notifications/

│

├── calendar/

│

├── analytics/

│

├── utils/

│

└── index.ts
```

---

# Cloud Function Categories

## HTTPS APIs

Examples

```
POST /tasks

POST /planner

POST /schedule

POST /assistant

POST /calendar

POST /rescue
```

Used by Flutter.

---

## Firestore Triggers

Examples

```
Task Created

↓

Planner

↓

Risk

↓

Scheduler
```

```
Task Updated

↓

Risk

↓

Scheduler
```

```
Task Completed

↓

Reflection
```

---

## Scheduled Jobs

Daily

Generate Reflection

Weekly

Generate Productivity Report

Hourly

Calendar Sync

Risk Refresh

---

# Orchestrator

The Orchestrator coordinates every workflow.

It decides

* Which agents execute
* Execution order
* Shared context
* Result merging

---

Example

Task Created

↓

Planner

↓

Risk

↓

Scheduler

↓

Coach

↓

Return

---

The Orchestrator should never perform AI reasoning itself.

---

# Planner Service

Responsibilities

* Parse task
* Create subtasks
* Estimate effort
* Estimate complexity

Input

Task

Output

AI Plan

---

# Risk Service

Responsibilities

* Completion prediction
* Risk score
* Confidence

Output

```
Risk

Probability

Reasons

Confidence
```

---

# Scheduler Service

Responsibilities

* Timeline generation
* Conflict resolution
* Break insertion

---

# Coach Service

Responsibilities

* Daily advice
* Motivation
* Explanation

Coach never changes schedules.

---

# Rescue Service

Responsibilities

* Recovery plan
* Priority changes
* Emergency schedule

---

# Reflection Service

Runs asynchronously.

Updates

* User statistics
* Productivity trends
* Future estimates

---

# Repository Layer

Repositories isolate Firestore.

Example

```
TaskRepository

RiskRepository

ScheduleRepository

UserRepository
```

Services never query Firestore directly.

---

# Middleware

Authentication

↓

Validation

↓

Logging

↓

Rate Limiting

↓

Business Logic

---

# Firestore Access Pattern

```
Cloud Function

↓

Repository

↓

Firestore

↓

Repository

↓

Service

↓

Response
```

---

# Logging

Every request logs

Request ID

↓

User ID

↓

Execution Time

↓

Agent

↓

Status

↓

Error

---

# Monitoring

Track

Function latency

Gemini latency

Firestore reads

Firestore writes

Notification delivery

Calendar sync

---

# Error Strategy

AI Failure

↓

Retry

↓

Fallback

↓

Notify User

---

Firestore Failure

↓

Retry

↓

Queue

↓

Recover

---

Calendar Failure

↓

Continue Without Calendar

---

# Retry Policy

Gemini

3 retries

Exponential backoff

Firestore

Automatic retry

Notifications

Retry queue

---

# Rate Limiting

Planner

30/hour

AI Chat

100/day

Rescue

Unlimited

Authentication

Standard Firebase limits

---

# Environment Variables

Store

Gemini API Key

Google OAuth

Project IDs

Notification Secrets

Calendar Credentials

Never hardcode secrets.

---

# Background Jobs

Daily

Reflection

Weekly

Insights

Hourly

Calendar Sync

Risk Refresh

Notification Cleanup

---

# Notification Pipeline

Coach

↓

Notification Service

↓

Firebase Cloud Messaging

↓

Flutter

---

# Deployment

GitHub

↓

Firebase Deploy

↓

Cloud Functions

↓

Firestore Rules

↓

Indexes

↓

Hosting

---

# CI/CD

Pull Request

↓

Lint

↓

Tests

↓

Build

↓

Deploy Preview

↓

Production

---

# Security

Every request

Authenticated

↓

Validated

↓

Authorized

↓

Logged

↓

Executed

---

# Cloud Function Naming

Examples

```
createTask()

generatePlan()

calculateRisk()

generateSchedule()

activateRescue()

dailyReflection()
```

Clear names.

One responsibility.

---

# Performance Goals

Planner

<3 sec

Risk

<2 sec

Schedule

<3 sec

Dashboard

<2 sec

Reflection

Background only

---

# Backend Philosophy

Backend services should behave like independent workers.

Each service:

* Solves one problem
* Returns structured output
* Never performs another service's job
* Can be replaced independently

Complex behavior emerges through orchestration—not monolithic functions.

---

# Future Scalability

Future integrations:

* Gmail
* Google Drive
* Slack
* Discord
* GitHub
* Wearables
* Desktop App
* Browser Extension

The architecture should support these additions without redesigning the backend.

---

# Summary

The backend follows an event-driven, service-oriented architecture where Cloud Functions coordinate specialized AI services through a central Orchestrator.

This approach keeps the system modular, explainable, and aligned with the multi-agent vision of ResQ AI.
