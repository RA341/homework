# Controllers

Controllers must use the service class direct db calls inside controllers are not allowed

Use the prebuilt route attributes in `Vector.Core/Common/Api/ProtectedController.cs`

Always use ApiBaseController

[TenantRoute("opportunity-stages")]

Always add `Authorize` attribute if user has not mentioned any specific auth requirments
