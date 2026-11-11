---
name: decide
description: Record a decision so the other person knows what we chose and why. Writes a short decision record in docs/decisions/. Use when we settle a design question, a rule, a tool, or anything we might later ask "why did we do it this way?".
argument-hint: "[the decision, in a few words]"
---

# /decide: write a decision down

1. **Gather** from the conversation, asking only for what's missing: the question, the options considered, the choice, why, who decided (one of us or both), and what would make us revisit it.
2. **Number:** the next free three-digit number in `docs/decisions/`.
3. **Write** `docs/decisions/NNN-short-title.md` from `docs/decisions/TEMPLATE.md`. Keep it under a page, in plain words.
4. **Replacing an earlier decision?** Set the old record's status to `Replaced by NNN`, and link both ways.
5. **Mention it** under "Decisions" in this session's log entry. It's shared with the next `/save`; offer to run it now.
