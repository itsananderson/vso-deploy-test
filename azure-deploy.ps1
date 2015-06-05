Param(
    [string]$websiteName,
    [string]$stagingSlot,
    [boolean]$swap = $true
)

function ZipFiles( $zipfilename, $sourcedir )
{
    echo "Adding filesystem assembly"
    Add-Type -Assembly System.IO.Compression.FileSystem
    $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
    echo "Creating zip file"
    [System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir,
        $zipfilename, $compressionLevel, $false)
}

$pwd = pwd

$sourcesDir = pwd

if ($env:BUILD_SOURCESDIRECTORY) {
    echo "Moving to ${env:BUILD_SOURCESDIRECTORY}"
    cd $env:BUILD_SOURCESDIRECTORY
    $sourcesDir = $env:BUILD_SOURCESDIRECTORY
}

$binDir = "$sourcesDir/bin"
$zipPath = "$sourcesDir/website.zip"

$npm = echo "C:\Program Files\nodejs\npm.cmd"
if (!(test-path "$npm")) {
    $npm = echo "C:\Program Files (x86)\nodejs\npm.cmd";
}

echo "Using npm at $npm"

echo "Installing base npm modules"
cmd /C "$npm" i

if (test-path $binDir) {
    echo "Removing bin"
    remove-item -Recurse -Force $binDir
}

echo "Copying sources"
cp -r src/ $binDir/src/

echo "Copying package.json"
cp package.json $binDir/

echo "Copying README"
cp README.md $binDir/

echo "Copying web.config"
cp web.config $binDir/

echo "Moving into $binDir/"
cd $binDir

pwd

echo "Installing production modules"
cmd /C "$npm" i --production

echo "Moving out of $binDir/"
cd ..

pwd

if (test-path $zipPath) {
    echo "Deleting old zip"
    rm $zipPath
}

echo "Creating new zip at $zipPath"
ZipFiles $zipPath $binDir

echo "Stopping $stagingSlot slot on $websiteName"
Stop-AzureWebsite -Name $websiteName -Slot $stagingSlot

echo "Publishing to $stagingSlot slot on $websiteName"
Publish-AzureWebsiteProject -Name $websiteName -Slot $stagingSlot -Package $zipPath

echo "Starting $stagingSlot slot on $websiteName"
Start-AzureWebsite -Name $websiteName -Slot $stagingSlot

if ($swap) {
    echo "Swapping staging and production slots on $websiteName"
    Switch-AzureWebsiteSlot -name $websiteName -force
}