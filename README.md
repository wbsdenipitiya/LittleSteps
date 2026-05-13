# 👶 LittleSteps – Premium Early Childhood Adaptive Learning Ecosystem

Welcome to **LittleSteps**, a premium, state-of-the-art educational environment engineered specifically for early childhood development. This application bridges the gap between active play and cognitive milestones by adaptively transforming its interface, typography, interactions, and security protocols based on the child's developmental age.

Developed with **Flutter** (Frontend), **Riverpod** (State Management), and **Supabase** (Backend Cloud Sync), **LittleSteps** provides a seamless, offline-first responsive interface that parents can trust and children love.

---

## 🎨 1. Developmental Layout Engine (Adaptive UI System)
Rather than providing a static experience, **LittleSteps** features a dynamic layout transformer that reshapes the entire application depending on the child’s selected age group. 

### 🌟 Age Adaptations Profile Table
| Age Group | Target Age | UI Aesthetics & Themes | Mascot Narrator Speed | Core Activities |
| :--- | :--- | :--- | :--- | :--- |
| **Toddler** | 1 - 2 Years | Pastel colors, massive touch surfaces, gentle fluid animations | Slowly paced (Lisa: $0.30$ speed) | Alphabet Soundboard, Shape Matching |
| **Explorer** | 3 - 4 Years | Vibrant gradients, structured floating cards, interactive badge holder | Medium pace (Lisa: $0.40$ speed) | Cognitive Sorting, Counting Math Wizards |
| **Preschooler** | 5+ Years | Structured glassmorphic grids, clean typography, complex gamification | Fast pace (Lisa: $0.50$ speed) | Stranger Danger Scenarios, Dental Hygiene |

---

## 🎮 2. Interactive Game Playgrounds & Features

### 🅰️ Alphabet Lab
*   A colorful, voice-activated tactile soundboard.
*   **How it Works:** Tap any letter card to hear **Lisa the Mascot** pronounce the letter, followed by an educational word example using a high-fidelity speech synthesis engine.

### 🔢 Math Wizards
*   A responsive, tactile counting playground designed to build early numeracy.
*   **Features:** Interactive star counters, dynamic summation animations, and instant haptic feedback when completing arithmetic challenges.

### 🧠 Cognitive Zone
*   A shape, object, and color association matching engine.
*   **Goal:** Encourages spatial reasoning and logical deduction via premium drag-and-drop mechanics.

### 🦁 Safe Stories (Story Library)
*   A premium, illustrated narrative reader designed to teach children physical safety, dental hygiene, and boundary awareness.
*   **Narrator Sync:** Uses advanced Text-to-Speech (TTS) pipelines to sync Lisa's narration word-by-word, slowing down or speeding up based on the child's age profile.
*   **Automatic Completion Flow:** Upon finishing a story, the app logs the database progress milestone, launches a 1.5-second confetti celebration, and automatically returns the child safely to the play dashboard.

### 🦷 Toothpaste Game
*   A gamified daily hygiene helper that makes teeth brushing fun!
*   **Mechanics:** Guides children through standard brushing intervals with visual cues, sound rewards, and haptic feedback.

### 🎭 Mood Check-in
*   An emotional intelligence builder that allows children to log their feelings using vibrant, interactive mascot expressions.
*   Stores results securely to help parents track emotional well-being trends.

---

## 🔒 3. Hardened Parent Dashboard & Biometric Gateways

To protect children from navigating away or accessing sensitive analytical charts, all administrative areas are locked behind a modern, secure gate.

### 🧬 Biometric Gate (`local_auth`)
*   Integrates Android's native fingerprint/biometric authentication hardware.
*   **Technical Implementation:** Kotlin's `MainActivity` inherits from `FlutterFragmentActivity` to bind securely to low-level hardware security layers.

### 💻 Seamless Emulator & Virtual Machine Simulator Support
*   **Hardware Auto-Detection:** Automatically scans system model properties (`google_sdk`, `vbox`, `emulator`, etc.) to identify if the app is running in a virtual environment.
*   **Interactive Simulation Mode:** On emulators where physical biometric scanners are missing, the gate dynamically transforms into a gorgeous glassmorphic **Biometric Scanner Simulation Card** with a pulsing heartbeat fingerprint animation, allowing full flow demonstration without hardware limits.
*   **Supervisor Bypass Pins:** Universal supervisor PINs (`0000` or `1234`) are registered to allow presentations to bypass biometric authentication instantly on any device.
*   **Pre-filled Demo Credentials:** Pre-fills login credentials on emulators to make viva walkthroughs effortless.

---

## ⚡ 4. Reactive State & Timezone-Safe Cloud Database Sync

### 🔄 WebSocket Bypass via HTTP Riverpod Streams
*   **The Problem:** Traditional WebSocket realtime streaming (`.stream()`) is highly unstable on firewalled machines or emulators, causing dashboards to hang on "Loading Badges...".
*   **The Engineering Solution:** Bypassed the unstable sockets with a highly stable REST-based query provider (`milestonesProvider`) using Riverpod.
*   **Reactive Invalidation:** When a game or story is completed, the dashboard automatically calls `ref.invalidate(milestonesProvider)`, forcing an instant, reactive dashboard trophy sync in milliseconds!

### 🌍 Timezone-Aware Trophy Accumulation
*   **The Problem:** Raw server-side database timestamps can cause completed trophies to fail to register on the dashboard if local and UTC timezones are out of sync.
*   **The Engineering Solution:** Integrated full UTC-to-Local conversion helpers to compare completion timestamps against the local device's calendar day, ensuring trophies always sync flawlessly.

---

## 🛠️ 5. Technical Stack
*   **Framework:** Flutter SDK (Channel stable)
*   **State Architecture:** Riverpod (Providers, AsyncNotifier, FutureProvider)
*   **Database & Auth backend:** Supabase PostgreSQL Cloud Client
*   **Animation Library:** Flutter Animate & Custom Haptic Drivers
*   **Local Hardware Hook:** `local_auth` & `device_info_plus`

---

## 🚀 6. Setup & Installation Guide

### Prerequisites
Make sure you have Flutter installed:
```bash
flutter doctor
```

### 1. Clone the Project
```bash
git clone https://github.com/wbsdenipitiya/LittleSteps.git
cd LittleSteps
```

### 2. Configure Environment Variables
Verify your connection parameters in your environment configuration file:
*   `SUPABASE_URL`: Your Supabase REST API endpoint.
*   `SUPABASE_ANON_KEY`: Your Supabase public anonymous API key.

### 3. Database Initialization (PostgreSQL)
Run the following SQL setup query in your Supabase SQL Editor to initialize all tables, relations, and row policies:
```sql
-- See full script in: supabase_setup_pro.sql
CREATE TABLE public.milestones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id),
    title TEXT NOT NULL,
    category TEXT NOT NULL,
    completed_at TIMESTAMPTZ DEFAULT NOW()
);
```

### 4. Build and Run
To launch the application on your physical device or Android/iOS Emulator:
```bash
flutter pub get
flutter run
```

