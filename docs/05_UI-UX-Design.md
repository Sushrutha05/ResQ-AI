# 05 - UI/UX Design System

> **Version:** 1.0
> **Status:** Draft

---

# Purpose

This document defines the complete design language for ResQ AI.

It ensures consistency across:

* UI
* UX
* Components
* Animations
* Typography
* Colors
* Accessibility
* AI interactions

Every screen should feel like part of one unified product.

---

# Design Philosophy

ResQ AI should feel like:

* Calm
* Intelligent
* Trustworthy
* Proactive
* Modern
* Minimal

The user is already overwhelmed.

The interface should reduce stress—not create it.

---

# Design Principles

## 1. Clarity First

Users should instantly know:

* What to do next
* Why
* What happens next

---

## 2. AI Explains Everything

Never show

> Risk: High

Instead show

> High Risk
>
> Because this task needs approximately 4 hours, but only 2.5 hours remain before your deadline.

---

## 3. Reduce Cognitive Load

Never show everything.

Always surface only the most important information.

---

## 4. Encourage Progress

The interface should celebrate progress.

Not punish unfinished work.

---

# Brand Personality

ResQ AI behaves like

* A senior project manager
* A thoughtful mentor
* A reliable teammate

Never:

* Robotic
* Judgmental
* Aggressive
* Overly cheerful

---

# Color System

## Primary

Used for

* Buttons
* Navigation
* Highlights
* AI suggestions

---

## Success

Used for

* Completed tasks
* Safe deadlines
* Positive insights

---

## Warning

Used for

* Medium risk
* Delays
* Schedule conflicts

---

## Error

Used for

* Rescue Mode
* Missed deadlines
* Critical alerts

---

## Neutral

Used for

* Cards
* Backgrounds
* Secondary text
* Dividers

---

# Risk Colors

Completion Probability

90–100%

Safe

Green

---

70–89%

Moderate

Blue

---

40–69%

Warning

Orange

---

0–39%

Critical

Red

---

# Typography

## Headings

Large

Dashboard

Task Details

Calendar

---

Medium

Section titles

Cards

Dialogs

---

Small

Captions

Labels

Metadata

---

Body

Readable

Comfortable line spacing

High contrast

---

# Spacing System

Use an 8-point grid.

Spacing

8

16

24

32

40

48

Never use arbitrary spacing.

---

# Corner Radius

Small

Buttons

Inputs

8dp

---

Medium

Cards

Dialogs

16dp

---

Large

Bottom Sheets

24dp

---

# Shadows

Three elevation levels.

Low

Cards

Medium

Dialogs

High

Floating Panels

Avoid excessive shadows.

---

# Component Library

---

## Primary Button

Purpose

Main action.

Examples

Create Task

Start Session

Save

Characteristics

Filled

Rounded

High contrast

---

## Secondary Button

Purpose

Alternative actions.

Examples

Later

Skip

Cancel

Outlined style.

---

## Text Button

Purpose

Low-priority actions.

---

## FAB

Only one FAB.

Always

*

Create Task

---

# Cards

Every card should answer one question.

---

## Task Card

Displays

Title

Deadline

Progress

Risk

Estimated duration

---

Actions

Open

Complete

Edit

---

## AI Suggestion Card

Displays

Recommendation

Reason

Expected benefit

Actions

Accept

Dismiss

Explain

---

## Rescue Card

Displays

Recovery Plan

Remaining work

Success chance

Action button

---

# Chips

Examples

High Priority

Coding

Interview

Assignment

Completed

---

# Progress Components

Never show

3 of 10 Tasks

Instead

Completion Probability

87%

or

Today's Progress

76%

Focus on outcomes instead of counts.

---

# Navigation

Bottom Navigation

Dashboard

Tasks

Calendar

AI

Profile

Maximum of five items.

---

# Dialogs

Use only for

Delete confirmation

Critical Rescue confirmation

Calendar conflict

Never interrupt unnecessarily.

---

# Bottom Sheets

Preferred over dialogs.

Used for

Task creation

Task editing

AI explanations

Filters

---

# Empty States

Every empty screen should guide users.

Example

"No tasks yet."

↓

"Let's create your first goal."

↓

Button

Create Task

---

# Loading States

Avoid blank screens.

Use

Skeleton loaders

Progress indicators

Meaningful loading messages

Example

"AI is planning your day..."

---

# Error States

Instead of

Something went wrong.

Show

Unable to generate your schedule.

Retry

or

Edit task manually.

---

# AI Interaction Design

Every AI response includes

Recommendation

↓

Reason

↓

Expected Outcome

↓

Confidence

---

Example

Start your DBMS assignment now.

Reason

It requires approximately three hours.

Outcome

Completion probability increases from 58% to 91%.

Confidence

High

---

# Notifications

Good Notification

Working now increases your completion chance by 26%.

Bad Notification

Reminder:

Study.

---

# Dashboard Layout

```text
──────────────────────────

Good Morning

Today's Success Score

Today's Timeline

High Risk Tasks

AI Recommendations

Upcoming Deadlines

Calendar Preview

──────────────────────────
```

---

# Task Details Layout

Header

↓

Task Summary

↓

Risk Score

↓

Subtasks

↓

Timeline

↓

AI Plan

↓

History

---

# Calendar Layout

Weekly View

↓

Today's Plan

↓

Conflicts

↓

Focus Sessions

---

# Motion Design

Animations should feel

Smooth

Intentional

Fast

Never distracting.

---

Animation Duration

150–300 ms

---

Use animations for

Task completion

Schedule updates

Card expansion

Rescue activation

Timeline movement

---

# Rescue Mode

The interface changes subtly.

Banner appears.

Accent color changes.

Timeline highlights critical work.

Everything communicates urgency without causing panic.

---

# Accessibility

Support

High contrast

Large text

Screen readers

Keyboard navigation

Color-independent indicators

---

# Responsive Design

Mobile

Primary target.

Tablet

Optimized dashboard.

Desktop

Multi-column layout.

---

# Design Tokens

Every visual property should use tokens.

Examples

Primary Color

Background Color

Spacing

Radius

Animation Speed

Typography Scale

Never hardcode values.

---

# UX Principles

Every interaction should answer

What happened?

Why?

What should I do next?

---

# Final Experience

The user should feel

"I don't need to think about planning anymore."

Instead

"My AI teammate already has a plan."

That emotional outcome is the ultimate goal of the ResQ AI experience.
