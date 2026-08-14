# Mapperly DTO Mapping Guidelines

When mapping nested or complex DTO structures to entity models using **Riok.Mapperly**, avoid using the `[MapProperty]`
attribute for nested source properties (e.g., mapping `Dto.Base.Prop` to `Model.Prop`). Instead, follow the base-class
conversion pattern.

Always name the file DtoMapper.cs

---

## The Pattern

### 1. Define a Shared Base/Common Structure

Define the common properties in a base/abstract class for the model, and a matching nested DTO record:

```csharp
// Model Base Class
public abstract class ProductBase : TenantBaseModel
{
    public string Name { get; set; } = string.Empty;
    public string? CustomProductId { get; set; } = string.Empty;
    public string? Description { get; set; } = string.Empty;
    public string CurrencyCode { get; set; } = string.Empty;
    public int PriceBase { get; set; }
}

// Flat Entity Model
public class ProductModel : ProductBase
{
    public string? BrochureLink { get; set; }
}
```

```csharp
// Nested DTO
public record ProductBaseDto(
    string Name,
    string? CustomProductId,
    string? Description,
    string CurrencyCode,
    int PriceBase
);

// Outer Request DTO
public record CreateProductDto(
    ProductBaseDto Base,
    Stream? BrochureFile,
    string? BrochureFileName
);
```

### 2. Configure the Mapper

Declare a Mapperly conversion method for the base types where names match exactly. Since names and types match 1:1,
Mapperly handles this automatically without any custom configuration attributes.

Implement outer DTO mappings manually inside the partial mapper class, delegating the base property mappings to the
generated method:

```csharp
[Mapper]
public partial class ProductMapper
{
    // 1. Generate flat mapper for Response DTO
    public partial ProductDto ToDto(ProductModel model);

    // 2. Generate mapping for matching base classes
    public partial void MapToBase(ProductBaseDto dto, ProductBase target);

    // 3. Delegate complex/nested DTO mappings manually
    public ProductModel ToModel(CreateProductDto request)
    {
        var model = new ProductModel();
        MapToBase(request.Base, model); // polymorphic resolution
        return model;
    }

    public void UpdateModel(UpdateProductDto request, ProductModel model)
    {
        MapToBase(request.Base, model);
    }
}
```

---

## Why Avoid `[MapProperty]`?

1. **Refactoring Safety**: `[MapProperty]` uses magic strings (e.g., `[MapProperty("Base.Name", "Name")]`). If
   properties inside `Base` are renamed, these string paths will silently break or cause compilation errors that are
   harder to debug.
2. **Readability**: Keeps the mapper clean from dozens of metadata attributes.
3. **Reusability**: The base mapping configuration can be reused across create, update, and other custom endpoint DTOs.
