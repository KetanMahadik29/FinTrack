# Project Context – FinTrack

## 1. Project Overview

**Project Name:** FinTrack  
**Project Type:** Personal Finance Management Dashboard  
**Platform:** Flutter Web  
**Language:** Dart  
**Status:** Initial Development

FinTrack is a personal finance management web application that helps users track income, expenses, savings and transactions through an interactive dashboard.

The goal is to build a modern, responsive and user-friendly financial dashboard.

## 2. Technology Stack

- **Frontend:** Flutter Web
- **Language:** Dart
- **UI:** Material Design 3
- **Charts:** fl_chart
- **Local Storage:** SharedPreferences
- **Development Tool:** Google Antigravity
- **Version Control:** Git and GitHub

Initial development will use demo data and local storage. Backend integration can be considered in future versions.

## 3. Core Features

### Authentication
- Login and registration pages.
- Email and password validation.
- Password visibility toggle.
- Demo authentication and logout.

### Dashboard
- Total balance.
- Total income.
- Total expenses.
- Total savings.
- Income vs. expense charts.
- Recent transactions.

### Transaction Management
- Add, edit and delete transactions.
- Categorize income and expenses.
- Store transaction date, amount and description.
- Filter transactions by category and type.

### Analytics
- Monthly income and expense analysis.
- Category-wise spending charts.
- Savings trends.

### Settings
- User profile.
- Currency preference.
- Theme preference.
- Logout.

## 4. UI/UX Requirements

Create a clean, modern SaaS-style dashboard.

**Colour Palette:**
- Primary: #6C63FF
- Secondary: #8B80F9
- Background: #F7F8FC
- Cards: #FFFFFF
- Text: #202238
- Success: #16A34A
- Error: #DC4545

**Design Guidelines:**
- Use Material Design 3.
- Maintain consistent spacing and typography.
- Use rounded cards and subtle shadows.
- Create a responsive layout for desktop, tablet and mobile.
- Include a sidebar and top navigation bar.
- Maintain a consistent design across all screens.

## 5. Project Structure

Follow a modular Flutter architecture.

```text
fintrack/
│
├── context.md
├── README.md
├── pubspec.yaml
│
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── theme/
│   │   ├── constants/
│   │   └── routing/
│   │
│   ├── models/
│   ├── services/
│   ├── screens/
│   ├── widgets/
│   └── data/
│
└── test/
```

Keep UI components, business logic, models and services separate.

## 6. Development Guidelines

When working on this project, Antigravity must:

1. Read this context file before implementing features.
2. Inspect the existing project structure.
3. Follow the approved Flutter and Dart technology stack.
4. Create reusable widgets and maintain clean code.
5. Avoid unnecessary dependencies and duplicate code.
6. Validate user inputs and handle errors.
7. Test features before declaring them complete.
8. Ask for clarification when requirements are unclear.
9. Update documentation when important project details change.

Do not introduce another frontend framework or change the technology stack without approval.

Frontend demo authentication must not be treated as production-secure authentication.

## 7. Development Phases

**Phase 1:** Flutter project setup and theme configuration.

**Phase 2:** Login and registration screens.

**Phase 3:** Dashboard layout and financial summary cards.

**Phase 4:** Transaction management.

**Phase 5:** Charts and financial analytics.

**Phase 6:** Local storage and functionality testing.

**Phase 7:** Responsive testing, README preparation and GitHub upload.

Complete and verify each phase before moving to the next.

## 8. Current Project Status

**Completed:**
- Project concept finalized & approved.
- Flutter Web project setup with Material Design 3 and responsive architecture.
- Authentication module (Login, Register, Demo credentials, validation, password visibility toggle).
- Executive Dashboard (Total Balance, Income, Expenses, Savings, recent transactions feed).
- Transaction Management (Full CRUD, categories, filters by type/category, search, modals).
- Analytics & Charts (Monthly cash flow comparison & category spend donut chart via `fl_chart`).
- Settings & Customization (User profile, multi-currency switcher, dark mode toggle, demo reset).
- Local storage persistence with `SharedPreferences`.
- Responsive layout verification across Desktop, Tablet, and Mobile viewports.
- Automated unit and widget test suite passing (`flutter test`).
- Production release build generated (`flutter build web --release`).
- Comprehensive documentation and Git repository initialization.

**Pending:**
- Production backend integration (Firebase / Supabase) for multi-device sync in future versions.
- GitHub remote repository connection (ready for `git push`).

## 9. Future Enhancements

- Firebase authentication.
- Cloud database integration.
- Budget management.
- Recurring transactions.
- PDF and Excel report exports.
- Advanced financial analytics.

Implement these only after completing the initial version.

---

**Final Goal:** Build a professional, responsive and functional Flutter Web application that provides an intuitive interface for managing personal finances. Prioritize clean UI, reusable components, accurate calculations and maintainable code.
