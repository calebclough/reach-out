# ReachOut

An iOS app for staying in touch with the people who matter. ReachOut lets you set a call frequency for each person in your life and reminds you when you're overdue — no calendar juggling required.

## The Idea

It's easy to let weeks slip by without calling someone you care about. ReachOut keeps a simple list of people ("folks") and tracks how long it's been since you last called each one. Set a frequency — daily, weekly, monthly, whatever fits — and the app tells you at a glance who needs a call.

## Features

- **Folks dashboard** — A color-coded grid showing everyone at once: red for overdue, yellow for approaching, green for on-track
- **One-tap calling** — Tap a phone number to dial directly; the call is automatically logged as a check-in
- **Log without dialing** — Record a call you made outside the app
- **Streak tracking** — Consecutive on-time check-ins build a streak, shown as a badge on each person's detail page
- **Push notifications** — Each person gets a scheduled notification when their next call comes due; reschedules automatically after every logged call
- **Contact import** — Pull a name, phone numbers, and photo directly from your Contacts app
- **Multiple numbers** — Store up to five numbers per person

## Status Logic

Each person's status is computed from elapsed time vs. their target frequency:

| Status | Condition |
|--------|-----------|
| Overdue | Time since last call ≥ target frequency |
| Approaching | Time remaining ≤ min(24 hours, frequency ÷ 4) |
| On Track | Everything else |

The dashboard always sorts overdue folks to the top, followed by approaching, then on-track.

## Tech Stack

- Swift / SwiftUI
- SwiftData for persistent storage (photos stored with `.externalStorage`)
- `UserNotifications` framework for per-person scheduled reminders
- `UIKit` contact picker via `CNContactPickerViewController`
- `TimelineView` for live dashboard refresh every 60 seconds
- Targets iOS 17+

## Project Structure

```
ReachOut/
├── Models/
│   └── Folk.swift               # SwiftData model; status, streak, due-date logic
├── Views/
│   ├── Dashboard/
│   │   ├── DashboardView.swift  # Grid with live sorting by urgency
│   │   └── FolkTileView.swift   # Individual card with status color
│   ├── FolkDetail/
│   │   └── FolkDetailView.swift # Call, log, edit frequency, view streak
│   └── AddFolk/
│       ├── AddFolkView.swift    # New folk form
│       └── ContactPickerView.swift
├── Services/
│   ├── NotificationService.swift # Schedule / cancel per-folk notifications
│   └── CallService.swift         # Deep link to Phone app
└── Utilities/
    ├── FolkStatus.swift          # Status enum with colors and labels
    └── PhoneNumberFormatter.swift
```
