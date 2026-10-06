# JanSeva (जनसेवा) — Civic Governance & Municipal Service Delivery Platform

JanSeva is a full-stack civic governance platform designed for municipal corporations, citizens, and ward administration. It bridges citizen grievance reporting with real-time field triage, SLA-driven municipal resolution, and ward telemetry.

---

## 🏛️ Project Architecture & Folder Structure

The repository follows a clean, decoupled monorepo structure:

```
JanSeva/
├── .github/                      # CI/CD Workflows & automation
│   └── workflows/
│       └── build_ios.yml         # iOS release IPA packaging pipeline
├── mobile/                       # Flutter Mobile Application (Cross-Platform)
│   ├── lib/
│   │   ├── core/                 # Shared domain models, state, services, theme & widgets
│   │   │   ├── enums/            # Grievance types, categories, statutory urgency
│   │   │   ├── localization/     # Multi-lingual localization helpers (Bilingual)
│   │   │   ├── models/           # Data models (Grievance, Notice, Audit, Telemetry, etc.)
│   │   │   ├── repository/       # Data sources & local persistence
│   │   │   ├── services/         # Audio, route optimizer, DigiLocker, push notifications
│   │   │   ├── state/            # Application state management (ChangeNotifiers)
│   │   │   ├── theme/            # Material 3 styling tokens & typography
│   │   │   └── widgets/          # Shared components (voice recorder, inspection dialogs)
│   │   ├── features/             # Feature-driven modules (20+ civic domains)
│   │   │   ├── analytics/        # Ward analytics & SLA compliance metrics
│   │   │   ├── billing/          # Utility dispute & municipal billing
│   │   │   ├── budget/           # Participatory ward budgeting & civic voting
│   │   │   ├── climate/          # Environmental air quality & heat index
│   │   │   ├── community/        # Community drives & local citizen initiatives
│   │   │   ├── disaster/         # Flood preparedness & emergency alerts
│   │   │   ├── emergency/        # Rapid SOS dispatch & ward emergency hotlines
│   │   │   ├── feed/             # Ward activity feed & civic updates
│   │   │   ├── forum/            # Moderated citizen discussion forum
│   │   │   ├── map/              # GIS ward mapping & route inspection
│   │   │   ├── notices/          # Municipal announcements & public broadcasts
│   │   │   ├── notifications/    # Citizen alert center & push messages
│   │   │   ├── officer/          # Field officer triage & inspection console
│   │   │   ├── profile/          # User identity, DigiLocker & language toggle
│   │   │   ├── public_works/     # Social audits & infrastructure scorecards
│   │   │   ├── reporting/        # Citizen grievance submission with geo-tagging
│   │   │   ├── rti/              # Right to Information (RTI) portal & tracking
│   │   │   ├── schemes/          # Welfare scheme discovery & eligibility checker
│   │   │   ├── telemetry/        # IoT smart water sump & air quality telemetry
│   │   │   ├── tracking/         # Grievance status timeline & escalation history
│   │   │   ├── vending/          # Street vending certificates & regulated zones
│   │   │   ├── verification/     # DigiLocker citizen identity verification
│   │   │   └── veterinary/       # Stray animal & stray vaccination management
│   │   └── main.dart             # Mobile app entry point
│   ├── test/                     # 91 unit, widget, and multi-viewport AQIL test suites
│   ├── pubspec.yaml              # Flutter dependencies and asset configuration
│   └── .gitignore                # Flutter & Dart ignore rules
├── web/                          # Municipal Admin Command Center (Next.js 16)
│   ├── src/
│   │   └── app/
│   │       ├── page.tsx          # Municipal triage command dashboard
│   │       ├── layout.tsx        # Dashboard layout shell
│   │       └── globals.css       # Tailwind CSS design system styles
│   ├── package.json              # Web dependencies (Next.js, React 19, Lucide, Tailwind)
│   ├── tsconfig.json             # TypeScript compiler settings
│   └── .gitignore                # Next.js and Node.js ignore rules
├── scripts/                      # Deployment & maintenance scripts
│   └── deploy.ps1                # Antigravity deployment pipeline script
├── .gitignore                    # Monorepo root ignore rules
└── README.md                     # Platform overview & documentation
```

---

## 🚀 Getting Started

### 1. Prerequisites
- **Flutter SDK**: `>= 3.5.4`
- **Node.js**: `>= 18.x` / `npm >= 9.x`

### 2. Mobile App (`mobile/`)
```bash
cd mobile
flutter pub get
flutter test
flutter analyze
```

### 3. Web Municipal Dashboard (`web/`)
```bash
cd web
npm install
npm run lint
npx tsc --noEmit
npm run dev
```

---

## 🛡️ Code Quality & Quality Assurance
- **Static Analysis**: 100% clean across both Dart (`flutter analyze`) and TypeScript (`tsc --noEmit`, ESLint).
- **Responsive Layout Verification (AQIL)**: Tested across 5 viewports (320px compact mobile to 1280px desktop) with dynamic font scaling ($1.5\times$).
- **Test Coverage**: 91 passing Flutter unit and widget tests covering all municipal domains.
