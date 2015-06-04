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

echo "Installing base npm modules"
cmd /C '"C:\Program Files\nodejs\npm.cmd"  i'

echo "Moving package.json"
cp package.json src/

echo "Moving into src/"
cd src/

echo "Installing base production modules"
cmd /C '"C:\Program Files\nodejs\npm.cmd" i --production'

echo "Moving out of src/"
cd ..

if (test-path $zipPath) {
    echo "Deleting old zip"
    rm $zipPath
}

echo "Creating new zip"
ZipFiles $zipPath src/
