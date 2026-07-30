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

## 3. Error Handling and API Calls

To maintain consistent error handling across the application:

*   **gRPC / Connect Clients**: Keep client classes generated and raw (e.g. `DownloaderServiceClient`). In the UI or controllers, wrap their calls with the `runReq` helper from `lib/common/api/runner.dart` to yield an `ErrorResult`. Never write raw `try-catch` blocks in UI code.
*   **Non-gRPC / Custom Services**: Custom services/endpoints (e.g., `UploadService`) must return `ErrorResult<T>` (typedef for `Result<T, String>` defined in `lib/common/result/result.dart`) directly and utilize the `runReq` helper internally.
*   **Result Pattern Matching**: Process the returned `ErrorResult` inside the UI or queue providers using Dart's switch pattern matching:
    ```dart
    // For gRPC calls:
    final result = await runReq(() => downloader.download(...));

    // For custom services:
    final result = await uploadService.upload(...);

    switch (result) {
      case Ok(:final value):
        // handle success
      case Error(:final error):
        // handle error string directly (e.g. display in UI)
    }
    ```
