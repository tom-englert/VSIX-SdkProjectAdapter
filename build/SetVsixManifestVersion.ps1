param (
    [parameter(Mandatory=$true)] [string]$Version,
    [parameter(Mandatory=$true)] [string]$ManifestFile
)

function Version-Sanitize
{
    [cmdletbinding()]
    param (
        [Parameter(Position=0, Mandatory=1, ValueFromPipeline=$true)]
        [string]$version
    )

    #remove semantic version suffixes from a version string, e.g. 3.3.4-beta1 => 3.3.4
    $PATTERN = "(\d+)\-[\w\d]+"
    $REPLACEMENT = "`$1"
   
    $version = $version -replace $PATTERN, $REPLACEMENT

    #ensure version has 4 digits
    $v = New-Object Version $version
    while ($v.Revision -eq -1) { 
        $version += ".0"
        $v = New-Object Version $version
    }

    return $version;
}

# replace a version template in a file with the actual version.
# returns the version
function Vsix-PatchVersion
{
    [cmdletbinding()]
    param (
        [Parameter(Position=0, Mandatory=1)]
        [string]$manifestFilePath,

        [Parameter(Position=1, Mandatory=1, ValueFromPipeline=$true)]
        [string]$version
    )

    "File-PatchVersion: $manifestFilePath, $version" | Write-Host

    [xml]$vsixXml = Get-Content $manifestFilePath
    [Version]$currentVersion = $vsixXml.PackageManifest.Metadata.Identity.Version

    if ($currentVersion -ne $version) {
        $vsixXml.PackageManifest.Metadata.Identity.Version = [string]$version
        $vsixXml.Save($manifestFilePath)
        "VSIX manifest version updated: $currentVersion => $version" | Write-Host
    } else {
        "VSIX manifest version already up to date: $currentVersion" | Write-Host
    }

    return $version
}

$Version = $Version | Version-Sanitize | Vsix-PatchVersion $ManifestFile
