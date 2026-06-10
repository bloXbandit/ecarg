# Pika AI Selves (pika.me) — Deconstruction for “Grace” Digital Twin App

**Source reviewed:** https://www.pika.me/#faq (landing + FAQ index; answers mostly not visible without app/auth in my scrape)

**Goal of this doc:** extract the *product primitives* Pika is promising and translate them into an implementation map you can graft into your existing **Grace** digital-twin app later.

---

## 0) What Pika is *actually* selling (in product terms)
Pika frames this as “birth/raise/set loose,” but the concrete promise is:

1) **Identity persistence**: one stable persona instance across sessions.
2) **Memory persistence**: remembers preferences + personal facts + style.
3) **Cross-context behavior**: “everywhere” (Slack/social/etc) while staying “true to you.”
4) **Multimodal output**: talk + post; implies text + voice; and in marketing they imply rich media.
5) **Human-in-the-loop training loop**: you correct it and it adapts.

> Their own page literally says: “Your AI Self talks, posts, remembers, and grows.”

---

## 1) UX / Onboarding: “Giving birth has never been easier”
From the site, onboarding inputs are:
- **Selfie upload** (appearance)
- **Voice recording** (voice clone)
- **Personality mapping** (“shy or bold?” style questions)
- **Name** for the self

### Implementation takeaways for Grace
- A “digital twin” feels real when onboarding is *ritualized* and **fast** (minutes).
- You need a **calibration phase** that produces a usable twin quickly even before memory is rich.

### Data artifacts you should store
- `IdentityProfile`: name, pronouns, short bio, origin context
- `VoiceProfile`: voice embedding/model id + consent timestamp
- `AppearanceProfile`: avatar image(s) + style prefs
- `ToneVector`: sliders like formality, humor, bluntness, emoji usage
- `Permissions`: what platforms + what actions allowed

---

## 2) Training loop: “Your AI Self learns as they live”
The site shows a conversational correction pattern:
- user: “Let’s go for more of a candid, effortless feel in our posts”
- self: “Yay or nay?”
- user: “Plz read through all my texts to sound more like me”

### What this implies under the hood
A practical way to implement this is *not* magic—it's a pipeline:
- **Preference capture** (explicit): user says what they want
- **Style extraction** (implicit): ingest writing samples
- **Memory update**: write stable preferences to a profile store
- **Prompt policy update**: change the system prompt / style guide
- **Evaluation**: “yay/nay” labels update a lightweight ranking model or ruleset

### Grace implementation primitives
- `StyleGuide.md` (generated + user-editable)
- `MemoryStore` (facts + preferences + examples)
- `FeedbackEvents` (yay/nay + “rewrite like this”) that update StyleGuide + retrieval weights

---

## 3) Cross-platform presence: “Free to roam, stays true to you”
Pika explicitly claims:
- “doesn’t just live in one app — they’re everywhere”
- “from professional updates on Slack to playful content on social”

### Translation: you need “persona layers” per context
You’ll need per-channel overlays so the same self can behave differently:
- `ChannelPolicy(slack)` = concise, professional, low emoji
- `ChannelPolicy(group_chat)` = informal, playful, more memes

### Architectural requirement
You need an **Identity Router**:
- input: (channel, thread, audience, relationship, time-of-day)
- output: (tone, safety limits, action permissions, reply format)

---

## 4) Actions: “talks” + “posts”
“Posts” implies:
- scheduled posting
- draft generation
- maybe auto-replies

### The minimal safe action model
For a twin app, the safe default is **confirm-before-send** with progressive autonomy:
- Level 0: drafts only
- Level 1: auto-send in low-risk contexts (personal notes)
- Level 2: auto-send on allowed channels + allowed intents

### You’ll want auditability
- Every outbound message should have:
  - source inputs (retrieval ids)
  - policy used
  - model version
  - user override history

---

## 5) Persistent memory (what it likely means)
Pika doesn’t give technical detail on the site, so assume consumer-grade “memory”:
- saved profile facts
- conversation summaries
- user-approved notes (“remember that I hate…”)
- retrieval of prior examples (writing samples)

### Grace implementation notes
Use a **two-tier memory** model:
- **Profile memory** (small, curated, stable): preferences, bio, boundaries
- **Episodic memory** (large, searchable): conversations, documents, samples

And a **review loop**:
- periodic summaries → user approves edits to profile memory

---

## 6) Safety / privacy signals from the site
What I could concretely extract:
- They explicitly note: **“Testimonials absolutely fake. But use cases 100% real.”**
- FAQ index includes questions about:
  - safety
  - whether onboarding inputs are used to train models
  - fake accounts using your likeness
  - children’s safety
  - IP ownership
  - content privacy
  - account deletion
- One visible answer via scrape:
  - **Account deletion exists** and they claim data is deleted when account is deleted.

### What this means for Grace
You’ll need:
- consent + provenance for voice/likeness
- impersonation reporting and takedown
- safety classifier + content filters
- “memory delete” and “account delete” semantics that are real

---

## 7) Monetization signals (from site copy)
- “Free to start.”
- Login CTA suggests it’s an app experience.

Interpretation:
- Freemium onboarding
- paid tiers for higher message volume, longer memory, more connectors, richer media (likely)

---

## 8) What we *cannot* confirm from the landing page alone
Things the marketing implies but the landing page does not prove:
- which connectors are live today (Slack/WhatsApp/iMessage/etc)
- whether there is an API/SDK
- latency/uptime/guardrail rigor
- whether memory is user-reviewable vs opaque

For your product planning, treat these as **open questions** until you test in-app.

---

## 9) “Grace” integration blueprint (high-level)
When you brief me on Grace later, we can map these into your app as modules.

### Suggested module breakdown
1) **Twin Identity**
- profile, voice, avatar, tone vector

2) **Memory**
- profile memory + episodic store + approval workflow

3) **Channel Connectors**
- per-channel policies + permissions + rate limits

4) **Action Engine**
- draft → confirm → auto-send ladder
- audit log + replay

5) **Safety**
- impersonation + consent + policy gating

6) **Tuning Loop**
- explicit feedback (“yay/nay”) + style guide updates

---

## 10) Next steps (no code, just research)
If you want me to squeeze more “free game” out of Pika:
- I should **create a test account** in a controlled way (no secrets) and document:
  - actual onboarding steps
  - what connectors appear
  - pricing gates
  - memory controls
  - export/delete flows

You tell me when you’re ready for that, and what you want benchmarked most: memory quality, connector breadth, or autonomy controls.
