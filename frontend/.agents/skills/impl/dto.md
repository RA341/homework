# DTO Design Guidelines

To maintain clean, DRY, and maintainable APIs, do not duplicate common fields across different request or response DTOs
within a feature. Instead, extract shared properties into a common base record and embed it.

Always name the file Dto.cs

---

## Guidelines

### 1. Avoid Field Duplication

Do not copy-paste identical fields (e.g., `Name`, `CustomProductId`, `Description`, `PriceBase`) across `Create`,
`Update`, or other specialized request DTOs.

### 2. Extract Common Fields

Any common subset of fields should be extracted into a dedicated base record (conventionally named `*BaseDto`):

```csharp
// Extract shared schema fields here
public record ProductBaseDto(
    string Name,
    string? CustomProductId,
    string? Description,
    string CurrencyCode,
    int PriceBase
);
```

### 3. Embed Nested Records

If a request DTO needs these fields plus additional custom properties (e.g. uploaded streams, multipart-form boundaries,
flags), embed the `*BaseDto` as a property rather than flattening it:

```csharp
// Correct: Embed common fields and add context-specific fields
public record CreateProductDto(
    ProductBaseDto Base,
    Stream? BrochureFile,
    string? BrochureFileName
);

public record UpdateProductDto(
    ProductBaseDto Base,
    Stream? BrochureFile,
    string? BrochureFileName
);
```

### 4. Integration with Mapping

By nesting the base DTO, we can seamlessly map it to its corresponding domain model base class using polymorphic mapping
methods in **Mapperly** (see [dtomapper.md](file:///.guidelines/dtomapper.md) for details).
