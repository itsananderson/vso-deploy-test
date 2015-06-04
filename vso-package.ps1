Param(
    [string]$zipPath
)

function ZipFiles( $zipfilename, $sourcedir )
{
    Add-Type -Assembly System.IO.Compression.FileSystem
    $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
    [System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir,
        $zipfilename, $compressionLevel, $false)
}

$npm = echo "C:\Program Files\nodejs\npm.cmd"
if (!(test-path "$npm")) {
    $npm = echo "C:\Program Files (x86)\nodejs\npm.cmd";
}

echo "Using npm at $npm"

echo "Installing base npm modules"
cmd /C "'$npm' i"

if (test-path bin/) {
    echo "Removing bin"
    remove-item -Recurse -Force bin/
}

echo "Copying sources"
cp -r src/ bin/src/

echo "Copying package.json"
cp package.json bin/

echo "Copying README"
cp README.md bin/

echo "Copying web.config"
cp web.config bin/

echo "Moving into bin/"
cd bin/

echo "Installing production modules"
cmd /C "'$npm' i --production"

echo "Moving out of bin/"
cd ..

if (test-path $zipPath) {
    echo "Deleting old zip"
    rm $zipPath
}

echo "Creating new zip"
ZipFiles $zipPath bin/
