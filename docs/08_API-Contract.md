# 08 - API Contracts

> **Version:** 1.0
> **Backend:** Firebase Cloud Functions (HTTPS + Firestore Triggers)
> **Status:** Draft

---

# Purpose

This document defines the API contracts between:

* Flutter Client
* Cloud Functions
* Firestore
* AI Agents
* External Services

Every API includes:

* Purpose
* Authentication
* Request
* Response
* Validation
* Errors
* Triggered Agents

---

# API Principles

Every endpoint must:

* Require authentication
* Validate input
* Return structured responses
* Be idempotent when possible
* Log execution
* Return explainable AI outputs

---

# Authentication

All authenticated requests include a Firebase ID Token.

Example:

```http
Authorization: Bearer <Firebase_ID_Token>
```

---

# Standard Response Format

```json
{
  "success": true,
  "message": "Task created successfully.",
  "data": {},
  "timestamp": "2026-06-25T12:00:00Z"
}
```

---

# Standard Error Format

```json
{
  "success": false,
  "error": {
    "code": "INVALID_INPUT",
    "message": "Deadline must be in the future."
  }
}
```

---

# Task APIs

## Create Task

### Endpoint

```http
POST /tasks
```

---

### Purpose

Creates a task from natural language.

---

### Request

```json
{
  "input": "Finish DBMS assignment before Friday 5 PM"
}
```

---

### Backend Flow

```text
Validate

↓

Store Task

↓

Planner Agent

↓

Risk Agent

↓

Scheduler Agent

↓

Return Updated Task
```

---

### Response

```json
{
  "taskId": "...",
  "title": "...",
  "deadline": "...",
  "priority": "High",
  "risk": 74
}
```

---

## Get Task

```http
GET /tasks/{taskId}
```

Returns

* Task
* Subtasks
* AI Plan
* Risk Score
* History

---

## Update Task

```http
PATCH /tasks/{taskId}
```

Allows

* Rename
* Deadline
* Priority
* Description

Triggers

Risk recalculation

Scheduler update

---

## Delete Task

```http
DELETE /tasks/{taskId}
```

Soft delete recommended.

---

# Planner APIs

## Generate Plan

```http
POST /planner/generate
```

---

### Input

```json
{
  "taskId": "...",
  "task": "Prepare internship resume"
}
```

---

### Output

```json
{
  "estimatedDuration": 180,
  "subtasks": [],
  "dependencies": [],
  "complexity": "Medium"
}
```

---

# Risk APIs

## Calculate Risk

```http
POST /risk/calculate
```

---

### Input

Task

Calendar

History

Schedule

---

### Response

```json
{
  "completionProbability": 82,
  "riskLevel": "Medium",
  "confidence": 91,
  "reasons": []
}
```

---

# Scheduler APIs

## Generate Schedule

```http
POST /schedule/generate
```

---

### Request

```json
{
  "date": "2026-06-25"
}
```

---

### Response

```json
{
  "blocks": [
    {
      "start": "09:00",
      "end": "10:00",
      "taskId": "...",
      "type": "Focus"
    }
  ]
}
```

---

## Replan Schedule

```http
POST /schedule/replan
```

Triggers:

* Missed work
* Calendar changes
* Rescue Mode

---

# Coach APIs

## Daily Suggestions

```http
GET /coach/suggestions
```

Returns

* Next task
* AI explanation
* Motivation
* Estimated benefit

---

# Rescue APIs

## Activate Rescue

```http
POST /rescue/activate
```

---

### Response

```json
{
  "activated": true,
  "newSchedule": [],
  "completionProbability": 73,
  "recoveryPlan": []
}
```

---

# Reflection APIs

## Generate Reflection

```http
POST /reflection/daily
```

Runs automatically.

Returns

* Productivity summary
* Lessons learned
* Recommendations

---

# Calendar APIs

## Import Calendar

```http
POST /calendar/import
```

---

## Sync Calendar

```http
POST /calendar/sync
```

---

## Resolve Conflict

```http
POST /calendar/conflicts
```

---

# Notification APIs

## Send Notification

```http
POST /notifications/send
```

---

Notification Types

* Reminder
* Rescue
* Recommendation
* Daily Summary
* Weekly Summary

---

# AI Chat

```http
POST /assistant/chat
```

---

### Request

```json
{
  "message": "What should I do next?"
}
```

---

### Backend

Orchestrator decides

↓

Planner

↓

Risk

↓

Scheduler

↓

Coach

↓

Combined response

---

# Firestore Event Triggers

Task Created

↓

Planner

↓

Risk

↓

Scheduler

---

Task Updated

↓

Risk

↓

Scheduler

---

Task Completed

↓

Reflection

↓

Statistics

---

Calendar Changed

↓

Scheduler

↓

Risk

---

# Validation Rules

Task

* Required
* Maximum 500 characters

Deadline

* Future only

Priority

* Low
* Medium
* High

Duration

* Positive integer

---

# Rate Limits

Planner

30 requests/hour

AI Chat

100/day

Schedule

50/day

Rescue

Unlimited (system-triggered)

---

# Logging

Every endpoint logs:

* User ID
* Execution time
* Agent invoked
* Status
* Error (if any)

---

# API Versioning

Current

```
v1
```

Future

```
v2
```

Breaking changes must create a new version.

---

# API Security

All endpoints require:

* Firebase Authentication
* Firestore authorization
* Server-side validation

Never trust client-side data.

---

# Future APIs

Potential additions:

```
/habits

/email

/team

/documents

/voice

/automation

/analytics
```

---

# API Philosophy

Every API should do one thing well.

Complex workflows are composed by the Orchestrator rather than hidden inside a single "AI endpoint."

This keeps the system modular, testable, and aligned with the multi-agent architecture defined in earlier documents.
