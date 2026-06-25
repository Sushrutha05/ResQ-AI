# 02 - User Journeys

> **Version:** 1.0
> **Status:** Draft

---

# Purpose

This document defines the complete end-to-end journeys a user can experience while using ResQ AI.

Every feature, screen, API, notification, AI decision, and database action should support one or more of these journeys.

A feature that doesn't improve any user journey should not be included in the product.

---

# Journey Map Overview

```text
Onboarding
    │
    ▼
Import Calendar
    │
    ▼
Create Task
    │
    ▼
AI Planning
    │
    ▼
Risk Analysis
    │
    ▼
Schedule Generation
    │
    ▼
Daily Execution
    │
    ▼
Continuous Monitoring
    │
    ▼
Dynamic Replanning
    │
    ▼
Rescue Mode (if required)
    │
    ▼
Task Completion
    │
    ▼
Daily Reflection
    │
    ▼
Continuous Learning
```

---

# Journey 1 — First-Time User

## Goal

Help the user become productive in under five minutes.

---

## Flow

```text
Open App

↓

Create Account

↓

Choose Role
(Student / Professional / Founder / Other)

↓

Connect Google Calendar (Optional)

↓

Select Working Hours

↓

Set Productivity Preferences

↓

Dashboard Ready
```

---

## AI Actions

* Learns preferred work hours.
* Imports existing calendar events.
* Creates an initial productivity profile.

---

## Success Criteria

The user reaches the dashboard without manually configuring dozens of settings.

---

# Journey 2 — Add a Task

## Goal

Capture work with minimal effort.

---

## User Input

Examples:

> Finish DBMS Assignment by Friday 5 PM

> Prepare for interview tomorrow

> Submit hackathon project before Sunday

---

## AI Flow

```text
User Input

↓

Planner Agent

↓

Extract Task

↓

Estimate Duration

↓

Generate Subtasks

↓

Determine Priority

↓

Send to Risk Agent
```

---

## Success Criteria

The user never manually creates subtasks.

---

# Journey 3 — AI Task Planning

## Goal

Convert vague intentions into actionable work.

---

## Example

Input

> Prepare Internship Resume

Output

```text
Collect achievements

↓

Update projects

↓

Improve formatting

↓

Proofread

↓

Export PDF
```

---

## AI Output

* Subtasks
* Estimated duration
* Dependencies
* Complexity
* Confidence score

---

# Journey 4 — Risk Prediction

## Goal

Warn users before they fall behind.

---

## Flow

```text
Planner

↓

Risk Agent

↓

Calculate Success Probability

↓

Display Risk Score

↓

Generate Explanation
```

---

## Example

```text
Completion Chance

82%

Reason

You have enough free time.

Recommended Action

Start before 6 PM.
```

---

# Journey 5 — Automatic Scheduling

## Goal

Build an executable daily plan.

---

## Flow

```text
Calendar

+

Tasks

+

Deadlines

↓

Scheduler Agent

↓

Generate Timeline
```

---

## Output

* Focus blocks
* Breaks
* Task order
* Time estimates

---

# Journey 6 — Daily Dashboard

## Goal

Show the user exactly what matters today.

---

## Dashboard Components

* Today's Success Score
* Timeline
* High-Risk Tasks
* AI Suggestions
* Upcoming Deadlines
* Calendar
* Focus Session

---

## AI Actions

Every dashboard refresh recalculates:

* Risk
* Priorities
* Schedule

---

# Journey 7 — Work Session

## Goal

Help users begin working immediately.

---

## Flow

```text
User clicks Start

↓

Focus Session Begins

↓

Coach Agent Active

↓

Track Progress

↓

Complete Session
```

---

## During Session

The Coach can:

* Encourage progress
* Explain remaining work
* Suggest breaks

---

# Journey 8 — Dynamic Replanning

## Goal

Adapt when reality changes.

---

## Trigger

User misses planned work.

---

## Flow

```text
Delay Detected

↓

Risk Updated

↓

Scheduler Recalculates

↓

Coach Explains Changes

↓

Dashboard Updated
```

---

## Success Criteria

The user never manually rebuilds their schedule.

---

# Journey 9 — Rescue Mode

## Goal

Recover before deadlines are missed.

---

## Trigger Conditions

* High risk score
* Missed milestones
* Large overdue tasks
* Calendar overload

---

## Flow

```text
Risk Critical

↓

Rescue Agent

↓

Remove Low Priority Tasks

↓

Compress Timeline

↓

Generate Recovery Plan

↓

Notify User
```

---

## Dashboard

Displays:

🚨 Rescue Mode Activated

Recovery Plan

Estimated Completion Chance

---

# Journey 10 — Task Completion

## Goal

Celebrate progress and collect data.

---

## Flow

```text
Task Completed

↓

Reflection Agent

↓

Analyze Planning Accuracy

↓

Update User History

↓

Improve Future Estimates
```

---

# Journey 11 — Daily Reflection

## Goal

Turn every day into training data.

---

## Example

Today

Completed: 7

Missed: 2

Most Productive Time:

9–11 AM

Recommendation:

Schedule difficult work earlier.

---

# Journey 12 — Weekly Insights

## Goal

Show long-term improvement.

---

## Dashboard

* Completion rate
* Focus time
* Rescue activations
* Productivity trend
* Habit consistency

---

## AI Insights

Examples:

"You consistently underestimate research tasks."

"You perform coding tasks best in the morning."

---

# Journey 13 — Calendar Conflict

## Goal

Resolve scheduling conflicts automatically.

---

## Example

Meeting added externally.

↓

Scheduler detects overlap.

↓

Task moved.

↓

Risk recalculated.

↓

User informed.

---

# Journey 14 — Missed Deadline

## Goal

Recover instead of blaming.

---

## Flow

```text
Deadline Missed

↓

Reflection

↓

Determine Cause

↓

Suggest Improvements

↓

Apply Learning
```

---

# Journey 15 — Voice Assistant

## User

"What should I do next?"

---

## AI

Analyzes:

* Tasks
* Risk
* Calendar
* Focus level

Returns:

The next highest-impact action.

---

# Journey 16 — What-If Simulation

## User

"If I skip today's study session, can I still finish?"

---

## AI

Runs multiple scheduling simulations.

Returns:

* Updated success probability
* Trade-offs
* Alternative plans

---

# Journey 17 — Context-Aware Intervention

## Examples

User opens VS Code.

↓

AI suggests continuing the active coding task.

---

User is idle for two hours.

↓

Coach recommends beginning the highest-risk task.

---

# Journey 18 — Notification Journey

Notifications should always provide value.

Never:

> "Reminder: Finish assignment."

Instead:

> "Starting now increases your completion probability from 58% to 91%."

---

# Journey 19 — Learning Loop

Every completed task improves the AI.

Updates:

* Duration estimates
* Productivity patterns
* Preferred work hours
* Rescue effectiveness
* Planning accuracy

---

# Journey 20 — End-to-End Product Loop

```text
Task Created

↓

Planner Agent

↓

Risk Prediction

↓

Schedule Generation

↓

Daily Coaching

↓

Progress Monitoring

↓

Dynamic Replanning

↓

Rescue Mode (If Needed)

↓

Task Completion

↓

Reflection

↓

Learning

↓

Better Future Planning
```

---

# Journey Priorities

## P0 (Hackathon MVP)

* First-Time User
* Add Task
* AI Planning
* Risk Prediction
* Automatic Scheduling
* Daily Dashboard
* Work Session
* Dynamic Replanning
* Rescue Mode
* Task Completion

---

## P1

* Reflection
* Weekly Insights
* Calendar Conflicts
* Voice Assistant

---

## P2

* What-If Simulation
* Habit Learning
* Context Awareness
* Long-Term Analytics

---

# Design Principle

Every screen in the application should answer one of these questions:

* What should I do next?
* Am I on track?
* What changed?
* What happens if I don't act?
* How can I recover?

If a screen cannot answer one of these questions, it likely does not belong in the MVP.

---

# Final Guiding Principle

The user should never feel like they are managing tasks.

They should feel like they are collaborating with an intelligent teammate that continuously helps them succeed.
