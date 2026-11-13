# FinTrack - Personal Finance Management Dashboard

FinTrack is a modern, responsive personal finance web application built using **Flutter Web** and **Dart**. It provides an intuitive SaaS-style interface that allows users to track income, expenses, savings, and transactions with real-time calculations and interactive visual analytics.

---

## 🚀 Key Features

### 1. 🔐 Authentication
- **Demo Sign-in & Sign-up**: Quick 1-click test credential login or new user registration.
- **Form Validation**: Strict email format and password minimum-length checks.
- **Password Visibility Toggle**: Show/hide password fields dynamically.
- **Session State**: Preserves logged-in state across page reloads via `SharedPreferences`.

### 2. 📊 Executive Dashboard
- **Financial Metric Cards**: Instant summary of Total Balance, Total Income, Total Expenses, and Total Savings with monthly trend percentages.
- **Monthly Cash Flow Chart**: Income vs. Expense visual bar chart powered by `fl_chart`.
- **Spending Breakdown**: Donut chart detailing expense distribution by category.
- **Recent Transactions Feed**: Quick access to the most recent financial events.

### 3. 💳 Transaction Management
- **Full CRUD Support**: Add, view, edit, and delete transactions.
- **Categorization**: Salary, Freelance, Investment, Food & Dining, Shopping, Bills & Utilities, Entertainment, Transport, Health, Education, and Other.
- **Search & Filtering**: Real-time title/notes search, category dropdown filter, and type filter chips (*All*, *Income*, *Expense*).
- **Responsive Layout**: Clean desktop data table view and adaptive card view for tablets and mobile devices.

### 4. 📈 Analytics & Financial Insights
- **Net Savings Rate**: Real-time percentage rate tracking.
- **6-Month Cash Flow Trends**: Visual tracking of income and expense trajectory.
- **Interactive Pie & Bar Charts**: Responsive chart rendering with custom touch tooltips and legends.

### 5. ⚙️ Settings & Customization
- **User Profile**: Update display name and email.
- **Multi-Currency Support**: Switch between USD (`$`), EUR (`€`), GBP (`£`), INR (`₹`), CAD (`CA$`), AUD (`AU$`), and JPY (`¥`).
- **Theme Modes**: Seamless toggle between clean Light Theme and modern Dark Theme (Material 3).
- **Demo Data Reset**: Instant one-click restore to sample transactions.

---

## 🎨 UI/UX & Responsive Design

Built in strict compliance with **Material Design 3**:

- **Color Palette**:
  - Primary: `#6C63FF`
  - Secondary: `#8B80F9`
  - Background (Light): `#F7F8FC`
  - Card Surface (Light): `#FFFFFF`
  - Background (Dark): `#0F172A`
  - Card Surface (Dark): `#1E293B`
  - Text: `#202238` / `#F8FAFC`
  - Success: `#16A34A`
  - Error: `#DC4545`

### Responsive Breakpoints
- **Desktop ($\ge$ 1100px)**: Persistent sidebar navigation, multi-column metric grids, expanded comparison charts, and tabular transaction views.
- **Tablet (650px – 1099px)**: Drawer navigation, 2x2 metric card grids, and stacked responsive charts.
- **Mobile (< 650px)**: Bottom navigation bar, drawer integration, stacked metric cards, and mobile-optimized transaction cards with overflow prevention.

---

## 📁 Project Structure

```text
FinTrack/
├── context.md                       # Comprehensive project context & guidelines
├── README.md                        # Documentation and run instructions
├── pubspec.yaml                     # Dependencies and project metadata
├── web/
│   ├── index.html                   # HTML entry point with metadata
│   └── manifest.json
├── lib/
│   ├── main.dart                    # Application entry point & theme provider
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart      # Brand color palette & gradients
│   │   │   └── app_dimensions.dart  # Spacing, radius & layout breakpoints
│   │   ├── theme/
│   │   │   └── app_theme.dart       # Material 3 light & dark theme definitions
│   │   └── utils/
│   │       ├── formatters.dart      # Currency, date & compact number formatting
│   │       └── responsive_builder.dart # Device screen type detection utilities
│   ├── models/
│   │   ├── user_model.dart          # User profile model & JSON serialization
│   │   └── transaction_model.dart   # Transaction model, categories & types
│   ├── services/
│   │   └── storage_service.dart     # SharedPreferences local storage abstraction
│   ├── providers/
│   │   ├── auth_provider.dart       # Authentication & user profile state
│   │   └── transaction_provider.dart# Transaction CRUD, metrics & analytics state
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart    # Login form & demo login
│   │   │   └── register_screen.dart # User registration form
│   │   ├── dashboard/
│   │   │   └── dashboard_screen.dart# KPI cards, charts & recent transactions
│   │   ├── transactions/
│   │   │   └── transactions_screen.dart # Filterable transaction table/list
│   │   ├── analytics/
│   │   │   └── analytics_screen.dart# Financial trends & visual charts
│   │   └── settings/
│   │       └── settings_screen.dart # Profile, currency & theme settings
│   ├── widgets/
│   │   ├── cards/
│   │   │   ├── modern_card.dart     # Styled card container
│   │   │   └── summary_metric_card.dart # KPI metric cards with trend badges
│   │   ├── charts/
│   │   │   ├── income_expense_chart.dart # Monthly cashflow bar chart
│   │   │   └── category_pie_chart.dart  # Category spend donut chart
│   │   ├── dialogs/
│   │   │   └── add_transaction_dialog.dart # Add/Edit transaction modal
│   │   └── layout/
│   │       ├── app_sidebar.dart     # Fixed sidebar / drawer navigation
│   │       ├── app_topbar.dart      # Header with date, theme toggle & actions
│   │       └── main_scaffold.dart   # Responsive shell orchestrator
│   └── data/
│       └── demo_data.dart           # Rich initial dataset for demonstration
└── test/
    ├── widget_test.dart             # Desktop smoke test
    └── fintrack_unit_and_widget_test.dart # Responsive mobile & provider unit tests
```

---

## 🛠️ Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.22.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.4.0`)
- Google Chrome or Microsoft Edge

### Installation & Run

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run in development mode (Chrome):**
   ```bash
   flutter run -d chrome
   ```

3. **Run automated test suite:**
   ```bash
   flutter test
   ```

4. **Build release web bundle:**
   ```bash
   flutter build web --release
   ```
   The compiled web build will be available inside `build/web/`.

---

## 🔮 Future Enhancements
- Firebase Auth & Cloud Firestore synchronization
- Custom budget limits with budget alert notifications
- Recurring automated transactions
- Export transactions to PDF and CSV/Excel
- Advanced multi-year trend analytics
