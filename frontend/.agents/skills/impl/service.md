# Service

In the project we use a simple structure for our services

All service files are named `Service.cs`, the class will always be suffixed by `Service`
Class name will be the foldername for example

```
Stage
    Service.cs (class StageService)
    StageHistory (class StageHistoryService)
```

Always use C# primary constructors

```C#
class StageService(AppdbCtx db, ILogger<StageService> logger) {}
```
