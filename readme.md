# VSIX-SdkProjectAdapter
[![Build Status](https://dev.azure.com/tom-englert/Open%20Source/_apis/build/status/VSIX-SdkProjectAdapter?repoName=tom-englert%2FVSIX-SdkProjectAdapter&branchName=master)](https://dev.azure.com/tom-englert/Open%20Source/_build/latest?definitionId=40&repoName=tom-englert%2FVSIX-SdkProjectAdapter&branchName=master)
[![NuGet Status](http://img.shields.io/nuget/v/VSIX-SdkProjectAdapter.svg?style=flat)](https://www.nuget.org/packages/VSIX-SdkProjectAdapter/)

Extends [Microsoft.VSSDK.BuildTools](https://www.nuget.org/packages/Microsoft.VSSDK.BuildTools/) so you can use SDK style projects for your Visual Studio Extension.

---
### Preparation
- Ensure your VSIX project uses the latest tools: [Writing Visual Studio Extensions with Mads - Upgrading an old extension](https://www.youtube.com/watch?v=apPIuJCZhUk)
- Migrate your VSIX project to the SDK style project format. (e.g. using [Project Migration Helper](https://marketplace.visualstudio.com/items?itemName=TomEnglert.ProjectMigrationHelper)). 
  In this state your project will build the binaries, but does not generate the `.vsix` container.

### Usage
- Add a PackageReference to [VSIX-SdkProjectAdapter](https://github.com/tom-englert/VSIX-SdkProjectAdapter.git)
- **Remove** the import to `Microsoft.VsSDK.targets` from your project:
```xml 
<Import Project="$(VSToolsPath)\VSSDK\Microsoft.VsSDK.targets" Condition="'$(VSToolsPath)' != ''" />
```
---

### Features
- The version in your `source.extension.manifest` file will be automatically synchronized with the `<Version>` of your project. Turn of by setting the property `<SkipSetVsixManifestVersion>` to `true`
- These properties and items are set by default, so you don't have to include them in your project:
```xml
<PropertyGroup>
  <VsixManifestSourceFile>source.extension.vsixmanifest</VsixManifestSourceFile>
  <GeneratePkgDefFile>true</GeneratePkgDefFile>
  <UseCodebase>true</UseCodebase>
  <IncludeAssemblyInVSIXContainer>true</IncludeAssemblyInVSIXContainer>
  <IncludeDebugSymbolsInVSIXContainer>false</IncludeDebugSymbolsInVSIXContainer>
  <IncludeDebugSymbolsInLocalVSIXDeployment>false</IncludeDebugSymbolsInLocalVSIXDeployment>
  <CopyBuildOutputToOutputDirectory>true</CopyBuildOutputToOutputDirectory>
  <CopyOutputSymbolsToOutputDirectory>true</CopyOutputSymbolsToOutputDirectory>
  <VSCTResourceName>Menus.ctmenu</VSCTResourceName>
</PropertyGroup>

<ItemGroup Condition="'$(SkipVSIXDefaultItems)'!='true'">
  <None Update="**\*.vsixmanifest">
    <SubType>Designer</SubType>
  </None>
  <VSCTCompile Include="**\*.vsct">
    <ResourceName>$(VSCTResourceName)</ResourceName>
  </VSCTCompile>
</ItemGroup>
```



