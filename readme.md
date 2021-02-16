# VSSDK.BuildTools.SdkProjectAdapter

Extends Microsoft.VSSDK.BuildTools so you can use SDK style projects for your Visual Studio Extension.

---

### Usage
- Upgrade your VSIX project to use the latest tools: [Writing Visual Studio Extensions with Mads - Upgrading an old extension](https://www.youtube.com/watch?v=apPIuJCZhUk)
- Migrate your VSIX project to the SDK style project format.
- Add a PackageReference to [VSSDK.BuildTools.ProjectAdapter](todo)
- Remove the import to `Microsoft.VsSDK.targets` from your project:
```xml 
<Import Project="$(VSToolsPath)\VSSDK\Microsoft.VsSDK.targets" Condition="'$(VSToolsPath)' != ''" />
```
---

### Features
- The version in your `source.extension.manifest` file will be automatically synchronized with the `<Version>` of your project.



