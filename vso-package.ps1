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
cmd /C '"C:\Program Files\nodejs\npm.cmd"  i'

cp package.json src/

cd src/

cmd /C '"C:\Program Files\nodejs\npm.cmd" i --production'

cd ..

if (test-path $zipPath) {
    rm $zipPath
}

ZipFiles $zipPath src/
