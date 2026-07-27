---
type: design
track: B
required_when: "the change carries the `ui` tag"
status: draft
owner: ""
updated: YYYY-MM-DD
spec: ""
---

# Design: <experience>

## User goal

<What the user is trying to accomplish.>

## Flow

```mermaid
flowchart TD
    start[Entry] --> action[User action]
    action --> success[Success]
    action --> error[Recoverable error]
```

## States

| State | User sees | Available actions |
|---|---|---|
| Empty | <message> | <action> |
| Loading | <indicator> | <action or wait> |
| Success | <result> | <next actions> |
| Error | <plain-language explanation> | <recovery> |

## Accessibility and compatibility

- Keyboard: <behavior>
- Screen reader: <labels and announcements>
- Responsive behavior: <breakpoints or adaptation>
- Localization: <text, dates, numbers>

## Acceptance notes

- [ ] <observable interaction>
