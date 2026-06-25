# 01 - Agent Architecture

> **Version:** 1.0
> **Status:** Draft

---

# Overview

ResQ AI is built around a **multi-agent architecture**.

Instead of relying on a single AI assistant, multiple specialized agents collaborate to continuously optimize the user's productivity.

Each agent has a clearly defined responsibility, memory, inputs, outputs, and available tools.

An **Orchestrator Agent** coordinates communication between them.

This architecture enables proactive planning, continuous adaptation, explainable decisions, and autonomous intervention.

---

# Design Principles

Every agent should:

* Have a single responsibility.
* Be independently testable.
* Explain its reasoning.
* Operate asynchronously where possible.
* Share information through structured outputs.
* Never directly modify data without the Orchestrator.

---

# High-Level Architecture

```text
                           User
                             │
                             ▼
                  Orchestrator Agent
                             │
 ┌──────────┬───────────┬────────────┬────────────┬────────────┐
 │          │           │            │            │            │
 ▼          ▼           ▼            ▼            ▼            ▼
Planner   Risk     Scheduler     Coach      Rescue      Reflection
Agent     Agent      Agent        Agent       Agent         Agent
 │
 └──────────────────────────────────────────────────────────────┐
                                                               │
                       Shared Knowledge & Memory               │
                                                               │
     Tasks • Calendar • Habits • Progress • Preferences • History
```

---

# Agent Communication Flow

Every task follows this pipeline:

```text
Task Added

↓

Planner Agent

↓

Risk Agent

↓

Scheduler Agent

↓

Coach Agent

↓

Context Monitoring

↓

Rescue Agent (if needed)

↓

Reflection Agent

↓

Knowledge Base Updated
```

---

# Shared Memory

Every agent has access to structured user information.

Examples:

* Active tasks
* Deadlines
* Calendar events
* User preferences
* Focus history
* Productivity trends
* Habit streaks
* Previous AI decisions
* Rescue history

Agents never store private memory internally.

All memory lives in the central datastore.

---

# 1. Orchestrator Agent

## Purpose

Acts as the brain of the system.

Coordinates communication between every other agent.

---

## Responsibilities

* Receive all user actions.
* Decide which agents should execute.
* Merge responses.
* Resolve conflicts.
* Maintain execution order.
* Prevent duplicate work.

---

## Inputs

* User requests
* Task events
* Calendar updates
* Notification events
* Agent outputs

---

## Outputs

* Agent execution plan
* Final UI updates
* Notifications
* Database updates

---

## Available Tools

* Firestore
* Calendar API
* Gemini
* Notification Service

---

# 2. Planner Agent

## Purpose

Transforms vague tasks into executable plans.

---

## Responsibilities

* Understand natural language.
* Estimate effort.
* Break work into subtasks.
* Detect dependencies.
* Identify milestones.
* Estimate completion time.

---

## Example

Input

> Finish Operating Systems Assignment before Friday

Output

* Read requirements
* Study chapter
* Implement solution
* Test
* Generate report
* Submit

---

## Inputs

* Task
* Deadline
* User profile
* Previous tasks

---

## Outputs

* Structured task
* Estimated duration
* Priority
* Complexity
* Dependencies
* Confidence score

---

# 3. Risk Agent

## Purpose

Predicts the probability that the user will miss deadlines.

---

## Responsibilities

* Calculate completion probability.
* Detect overloaded schedules.
* Identify bottlenecks.
* Monitor increasing risk.
* Trigger Rescue Mode.

---

## Factors Considered

* Time remaining
* Work remaining
* Calendar availability
* User productivity
* Similar historical tasks
* Interruptions
* Focus trends

---

## Outputs

* Success probability
* Risk level
* Explanation
* Suggested actions

---

# 4. Scheduler Agent

## Purpose

Creates and continuously updates the user's execution plan.

---

## Responsibilities

* Schedule tasks.
* Respect deadlines.
* Avoid calendar conflicts.
* Insert breaks.
* Group similar work.
* Optimize focus sessions.

---

## Inputs

* Calendar
* Risk score
* User preferences
* Task durations

---

## Outputs

* Daily plan
* Weekly plan
* Updated schedule

---

# 5. Coach Agent

## Purpose

Keeps the user engaged and accountable.

---

## Responsibilities

* Daily check-ins
* Progress tracking
* Motivation
* Explain recommendations
* Suggest next actions
* Encourage consistency

---

## Example

Instead of:

> Start Assignment.

The Coach says:

> Starting now gives you an 87% chance of finishing before tomorrow. Waiting until tonight reduces it to 54%.

---

# 6. Rescue Agent

## Purpose

Intervenes when deadlines become critical.

---

## Responsibilities

* Detect emergency situations.
* Reprioritize work.
* Compress schedules.
* Remove low-value tasks.
* Escalate notifications.
* Generate recovery plans.

---

## Trigger Conditions

* High risk score
* Missed milestones
* Delayed progress
* Calendar overload

---

## Outputs

* Emergency schedule
* Recovery timeline
* Updated priorities

---

# 7. Reflection Agent

## Purpose

Continuously improves future planning.

---

## Responsibilities

* Analyze completed work.
* Detect planning mistakes.
* Identify recurring delays.
* Learn productivity patterns.
* Generate daily summaries.

---

## Example

Today's Reflection

* Completed: 8 tasks
* Missed: 1 task
* Cause: Underestimated effort
* Recommendation: Start similar assignments one hour earlier.

---

# Agent Collaboration Example

```text
User adds assignment

↓

Planner

Breaks into 6 subtasks

↓

Risk

Predicts 42% completion chance

↓

Scheduler

Creates study sessions

↓

Coach

Suggests starting today

↓

User ignores plan

↓

Risk increases to 18%

↓

Rescue Agent activates

↓

Schedule rebuilt

↓

Assignment completed

↓

Reflection learns from outcome
```

---

# Explainability

Every AI decision must be explainable.

Every recommendation should include:

* Why was this decision made?
* What data influenced it?
* What happens if ignored?
* What alternatives exist?

Users should never feel that the AI is making arbitrary decisions.

---

# Agent Priorities

| Priority | Agent        | Critical         |
| -------- | ------------ | ---------------- |
| P0       | Orchestrator | ✅                |
| P0       | Planner      | ✅                |
| P0       | Risk         | ✅                |
| P0       | Scheduler    | ✅                |
| P1       | Coach        | ✅                |
| P1       | Rescue       | ✅                |
| P2       | Reflection   | Optional for MVP |

---

# Hackathon MVP

The initial implementation will focus on six agents:

* Orchestrator Agent
* Planner Agent
* Risk Agent
* Scheduler Agent
* Coach Agent
* Rescue Agent

The Reflection Agent will be implemented if time permits.

---

# Future Agents

The architecture is designed to support additional agents without modifying the existing system.

Potential future agents include:

* Habit Agent
* Health Agent
* Email Agent
* Finance Agent
* Study Agent
* Meeting Agent
* Focus Agent
* Travel Agent
* Notification Agent
* Automation Agent

---

# Guiding Principle

Each agent should solve **one problem exceptionally well**.

Complex intelligence emerges not from one massive AI prompt, but from multiple specialized agents collaborating through the Orchestrator.

This modular architecture improves scalability, maintainability, explainability, and aligns with the hackathon's focus on **Agentic AI**.
