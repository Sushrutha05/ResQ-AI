# 14 - AI Orchestrator & Decision Engine

> **Version:** 1.0
> **Status:** Core AI Specification

---

# Purpose

This document defines how intelligence flows through ResQ AI.

Instead of treating AI as a chatbot, ResQ AI uses an Orchestrator that coordinates specialized agents to solve productivity problems collaboratively.

This document specifies:

* Agent orchestration
* Decision making
* Context management
* Tool invocation
* Memory handling
* Failure recovery
* Explainability
* Agent communication

---

# Philosophy

The Orchestrator never tries to solve user problems directly.

Its responsibility is to determine:

* Which agents should execute
* In what order
* What context they receive
* How outputs are combined
* Whether additional reasoning is required

The Orchestrator behaves like an engineering manager—not an engineer.

---

# AI Execution Pipeline

```text
User Input
      │
      ▼
Intent Detection
      │
      ▼
Context Assembly
      │
      ▼
Execution Plan
      │
      ▼
Agent Invocation
      │
      ▼
Result Validation
      │
      ▼
Conflict Resolution
      │
      ▼
Response Generation
      │
      ▼
Memory Update
```

---

# Step 1 — Intent Detection

Every request is classified before any AI agent executes.

Possible intents:

* Create Task
* Update Task
* Delete Task
* Ask Question
* Generate Schedule
* Replan Day
* Activate Rescue
* Daily Reflection
* Weekly Insights
* Calendar Sync

Example:

Input:

> I have an interview tomorrow and haven't prepared.

Intent:

```
CREATE_TASK
REQUEST_PLANNING
CHECK_RISK
GENERATE_SCHEDULE
```

One user message may trigger multiple intents.

---

# Step 2 — Context Assembly

The Orchestrator builds a shared context object.

Example:

```json
{
  "currentTime": "...",
  "timezone": "...",
  "tasks": [],
  "calendar": [],
  "riskScores": [],
  "workingHours": {},
  "preferences": {},
  "activeRescue": false
}
```

Agents receive only relevant context.

Avoid sending unnecessary information to reduce token usage.

---

# Step 3 — Execution Planning

The Orchestrator decides:

* Which agents are required
* Execution order
* Parallel vs sequential execution

Example:

Task Creation

```
Planner

↓

Risk

↓

Scheduler

↓

Coach
```

Example:

Daily Dashboard Refresh

```
Risk
      │
      ├─────────┐
      ▼         ▼
Scheduler   Reflection
      │         │
      └────┬────┘
           ▼
        Coach
```

---

# Sequential vs Parallel Execution

## Sequential

Used when later agents depend on earlier outputs.

Example:

Planner

↓

Risk

↓

Scheduler

---

## Parallel

Used when tasks are independent.

Example:

Calendar Sync

Reflection

Notification Cleanup

These can execute simultaneously.

---

# Shared Context Rules

Each agent receives:

* Relevant task data
* User preferences
* Calendar snapshot
* Time information
* Previous AI decisions (when needed)

Agents never receive:

* Raw Firestore collections
* Private authentication tokens
* Irrelevant historical data

---

# Tool Invocation

Agents never call external services directly.

Instead:

```
Planner

↓

Tool Request

↓

Orchestrator

↓

Gemini

↓

Result

↓

Planner
```

The Orchestrator owns all tool access.

---

# Agent Output Schema

Every agent returns:

```json
{
  "success": true,
  "confidence": 91,
  "summary": "...",
  "reasoning": "...",
  "actions": [],
  "warnings": [],
  "requiresHumanInput": false
}
```

This standard format simplifies orchestration.

---

# Confidence Aggregation

When multiple agents execute:

Planner: 92%

Risk: 78%

Scheduler: 95%

Overall confidence is **not** a simple average.

The Orchestrator weighs confidence based on the importance of each agent for the current workflow.

Example:

For scheduling, Scheduler confidence has more influence than Reflection confidence.

---

# Conflict Resolution

Sometimes agents disagree.

Example:

Planner:

Task needs 5 hours.

Risk:

Task can be completed today.

Scheduler:

Only 3 free hours.

The Orchestrator resolves conflicts by:

1. Trusting deterministic data first.
2. Asking another agent if necessary.
3. Requesting clarification from the user if uncertainty remains.

Never fabricate a resolution.

---

# Human Clarification

If confidence drops below a defined threshold:

Instead of guessing:

Ask.

Example:

> I estimate this task may take between 2 and 5 hours. Could you tell me roughly how familiar you are with the topic?

---

# Memory Model

Three memory levels:

## Short-Term Memory

Current conversation

Current task

Current schedule

---

## Session Memory

Today's activity

Dashboard state

Current Rescue Mode

---

## Long-Term Memory

Average completion time

Preferred work hours

Historical productivity

Recurring habits

Planning accuracy

---

# Memory Update Rules

After every completed workflow:

Update:

* Completion history
* Duration estimates
* Risk calibration
* Productivity patterns

Never overwrite raw user data.

---

# Rescue Escalation Logic

```text
Completion Probability

90-100%

↓

Safe

--------------------

70-89%

↓

Monitor

--------------------

40-69%

↓

Warning

--------------------

20-39%

↓

Prepare Rescue

--------------------

0-19%

↓

Activate Rescue
```

Thresholds should be configurable.

---

# Explainability Pipeline

Every recommendation must include:

1. Recommendation
2. Why?
3. Expected benefit
4. Confidence
5. Alternative (if available)

Example:

Recommendation:

Start the DBMS assignment now.

Why?

It requires approximately three hours, and your calendar becomes full after 5 PM.

Benefit:

Completion probability increases from 61% to 92%.

Confidence:

High.

---

# Retry Strategy

If an agent fails:

1. Retry once.
2. Retry with simplified context.
3. Use fallback logic.
4. Inform the user if recovery fails.

Never silently ignore failures.

---

# Context Compression

Before calling Gemini:

Remove:

* Old completed tasks
* Duplicate history
* Irrelevant calendar events
* Expired notifications

Only send context that can influence the decision.

---

# State Machine

```text
Idle

↓

Waiting for Input

↓

Planning

↓

Reasoning

↓

Scheduling

↓

Responding

↓

Learning

↓

Idle
```

The Orchestrator always returns to Idle.

---

# Event-Driven Triggers

Events:

Task Created

↓

Planning

---

Task Updated

↓

Risk

↓

Schedule

---

Calendar Updated

↓

Scheduler

↓

Risk

---

Task Completed

↓

Reflection

↓

Learning

---

# Decision Priority

Priority order:

1. User intent
2. Calendar constraints
3. Deadlines
4. Existing schedule
5. User preferences
6. Historical behavior
7. AI recommendations

User intent always has the highest priority.

---

# Failure Philosophy

If uncertain:

Ask.

If impossible:

Explain.

If incomplete:

Provide the best partial solution.

Never pretend certainty.

---

# Future Enhancements

Potential additions:

* Multi-agent voting
* Self-critique stage
* Retrieval-Augmented Generation (RAG)
* Tool selection using AI
* Multi-model orchestration
* Learning from user feedback
* Personalized planning model

---

# Summary

The Orchestrator transforms a collection of specialized AI agents into a cohesive productivity system.

Rather than relying on one large prompt, intelligence emerges from:

* Structured reasoning
* Specialized responsibilities
* Shared context
* Explainable decisions
* Continuous learning

This architecture enables ResQ AI to act as an autonomous productivity teammate rather than a traditional chatbot or task manager.
