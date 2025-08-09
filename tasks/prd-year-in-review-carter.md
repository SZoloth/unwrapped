# PRD: Year-in-Review (Bubba & Bubba)

## Overview
Create a personalized, fully offline “Wrapped” for the first year of Bubba & Bubba. The iOS (SwiftUI) app ingests hand‑curated content (primarily photos, optional Strava screenshots, music lists) and generates shareable portrait story cards capturing milestones, places, activities, soundtrack, fun stats, and a look‑ahead. Date range is fixed: July 30, 2024 → July 30, 2025.

## Goals
- Generate a cohesive set of 8–15 portrait cards summarizing the year.
- Keep all processing and data on-device (no cloud, no third‑party APIs).
- Make manual curation simple and fast (drag/drop/import, minimal required fields).

## User Stories
- As a user, I import selected photos and notes to build “Top Moments”.
- As a user, I optionally import Strava activity screenshots to see distance/time highlights.
- As a user, I provide exact date range to scope the year.
- As a user, I export story cards as PNG to share.

## Functional Requirements
1. Onboarding (defaults first, settings later): prefill exact start/end dates (July 30, 2024 → July 30, 2025); allow edits and skipping advanced options.
2. Imports (manual):
   - Photos via Photos library (with permission) and Files picker; read EXIF date/location when present; allow manual edits.
   - Strava: accept screenshots; optionally apply on‑device OCR (Vision) to extract totals (distance, elevation, time) within date range; allow manual entry/edit of parsed values.
   - Music: accept a simple text list or CSV (track – artist) for “Soundtrack”.
3. Cards (portrait 1080×1920, 9:16):
   - Top Moments (photo + caption grid or carousel).
   - Places Map + Top Spots (MapKit snapshot + list from photo/GPX coords).
   - Activities Summary (totals, best week/month; from Strava import if provided).
   - Soundtrack of the Year (user-provided list; no streaming API).
   - Milestones (firsts, trips, celebrations; user-entered).
   - Fun Stats (counts: dates per month, coffees, sunsets; user-entered or derived from imports).
   - Goals / Looking Ahead card (user-entered).
4. Theming & Personalization: cozy/filmic style; soft pastel palette (include green accents); headline uses “Bubba & Bubba”.
5. Export: single-card PNG export and “Export All” as ZIP of PNGs. Save to Photos or Files.
6. Privacy: on-device only; no network usage; no analytics.

## Non-Goals
- Live integrations (Spotify, Strava API), cloud sync, or server rendering.
- Full photo library scanning; app only processes user-selected assets.

## Design Considerations
- Visual style: soft pastels, filmic grain option, subtle gradients, rounded cards.
- Typography: large friendly display for headlines; readable body for captions.
- Layout presets for each card to keep curation quick (few required fields).

## Proposed Card Order
1. Title Card — “Bubba & Bubba: Our Year” with dates and hero photo.
2. Top Moments — curated photo grid/carousel with captions.
3. Milestones — timeline of firsts, trips, celebrations.
4. Places & Top Spots — map snapshot + top 5 locations.
5. Activities Summary — Strava totals/highlights (from screenshots/OCR).
6. Soundtrack of the Year — curated tracks list.
7. Fun Stats — playful counts (dates per month, coffees, sunsets, etc.).
8. Goals / Looking Ahead — intentions for the next year.
9. Closing Card (optional) — thank‑you/credits; subtle collage.

Notes: Keep 8–10 cards; order can be adjusted. Maintain visual rhythm by alternating photo‑heavy and text‑heavy cards.

## Technical Considerations
- Platform: iOS 17+, SwiftUI, MapKit snapshot for places.
- Data model: local JSON project file + imported media in app container.
- Image processing: downscale to 1080×1920, safe-area margins.
- OCR: use Vision framework on‑device to parse Strava screenshots (optional; user can correct values).

## Pastel Palette (with Usage)
- Pastel Green `#8FD5A6` — primary accents; buttons, highlights.
- Blush Pink `#F7C5CC` — backgrounds for moments/soundtrack.
- Soft Peach `#FFD7A8` — fun stats backgrounds; subtle charts.
- Lavender `#C9C3E6` — milestones and goals panels.
- Sky Blue `#B8DDF4` — places/map background and chips.
- Warm Cream `#FFF6E8` — base canvas, title/closing cards.
- Slate Ink `#2B2B2B` — primary text; Secondary `#6B7280`.

Suggested pairings:
- Title: Warm Cream bg + Pastel Green accents.
- Top Moments: Warm Cream/Blush mix.
- Milestones: Lavender bg + Slate Ink text.
- Places: Sky Blue bg + Cream panels.
- Activities: Pastel Green bg + Ink text.
- Soundtrack: Blush bg + Cream panels.
- Fun Stats: Peach bg + Ink text.
- Goals: Lavender bg + Green accents.

## Success Metrics (to confirm)
- Generates at least 8 polished cards per project (target; flexible).
- Fully offline; zero PII leaves device.
- Export to PNG (and ZIP) completes reliably.

## Open Questions
- Any specific pastel palette references beyond green accents?
- Preferred default ordering of cards (timeline, top moments, milestones, etc.)?
