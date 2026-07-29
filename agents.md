# Developer Agent Guidelines

This document outlines the coding standards, page layout constraints, and naming conventions for developer agents contributing to this project. All agents must follow these rules strictly.

## 1. File Naming Conventions

To keep routing and structure consistent:

*   **Pages**: All page entrypoint files must be named `+page.dart`.
    *   *Example*: `lib/pages/home/+page.dart`
*   **Providers**: All root-level or page-level providers must be named `+provider.dart`.
    *   *Example*: `lib/common/navigation/+provider.dart`

## 2. Directory Structure & Page Layout

Organize features and sub-features using strict folder nesting:

1.  **Every Page in a Directory**: All new pages must be placed in their own directory. Never place page files directly in a parent directory.
2.  **Sub-Pages**: Any sub-pages or child views must be nested inside the folder of their respective parent page.
    *   *Correct structure example*:
        ```
        lib/pages/
        └── settings/
            ├── +page.dart
            └── profile/             <-- Sub-page of settings
                └── +page.dart
        ```
