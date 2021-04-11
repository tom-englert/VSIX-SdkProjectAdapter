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
- These properties are set by default, so you don't have to include them in your project:
```xml
<PropertyGroup>
  <UseCodebase Condition="'$(UseCodebase)'==''">true</UseCodebase>
  <VSCTResourceName Condition="'$(VSCTResourceName)'==''">Menus.ctmenu</VSCTResourceName>
</PropertyGroup>
```
- The `VSPackage` resources and corresponding `.vsct` files are automatically included, so you don't have to include them in your project:
```xml
<ItemGroup Condition="'$(SkipVSIXDefaults)'!='true' AND 'EnableDefaultItems'!='false'">

  <None Update="**\*.vsixmanifest">
    <SubType>Designer</SubType>
  </None>

  <!-- Neutral VSPackage resources -->
  <EmbeddedResource Update="VSPackage.resx">
    <MergeWithCTO>true</MergeWithCTO>
    <ManifestResourceName>VSPackage</ManifestResourceName>
  </EmbeddedResource>

  <!-- Localized VSPackage resources -->
  <EmbeddedResource Update="VSPackage.*.resx">
    <MergeWithCTO>true</MergeWithCTO>
    <LogicalName>%(FileName).resources</LogicalName>
    <DependentUpon>VSPackage.resx</DependentUpon>
  </EmbeddedResource>

  <_VSCTLocalizedFiles Include="*.*.vsct" />
  <_VSCTNeutralFile Include="*.vsct" Exclude="@(_VSCTLocalizedFiles)"/>

  <!-- Neutral .vsct file, only include if there are no localized files -->
  <VSCTCompile Include="@(_VSCTNeutralFile)" Condition="@(_VSCTLocalizedFiles->'%(Identity)')==''">
    <ResourceName>$(VSCTResourceName)</ResourceName>
    <SubType>Designer</SubType>
  </VSCTCompile>

  <!-- Localized .vsct files -->
  <VSCTCompile Include="@(_VSCTLocalizedFiles)">
    <ResourceName>$(VSCTResourceName)</ResourceName>
    <SubType>Designer</SubType>
    <DependentUpon>@(_VSCTNeutralFile)</DependentUpon>
  </VSCTCompile>

</ItemGroup>

```
- Provides a build target to set the version in your `source.extension.manifest` file; just use ` Version="|%CurrentProject%;GetVsixVersion|"` in your manifest file.

  Turn of the target by setting the property `<SkipVsixGetVersionTarget>` to `true`:
```xml
  <Target Name="GetVsixVersion" Returns="$(VsixVersion)" Condition="'$(SkipVsixGetVersionTarget)'!='true' AND '$(SkipVSIXDefaults)'!='true'">
    <PropertyGroup>
      <VsixVersion Condition="'$(VsixVersion)' == ''">$(Version)</VsixVersion>
    </PropertyGroup>
  </Target>  
```
- Disable all features at once by setting the property `<SkipVSIXDefaults>` to `true`



