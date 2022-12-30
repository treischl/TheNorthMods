param (
  [string]$Password
)

rm TheNorthMods.7z
rm -Recurse -Force ./dist
mkdir ./dist

(cat ./mods.json | ConvertFrom-Json).mods | % {
  if ($_.type -eq "zip") {
    curl.exe -L -o "$($_.name).zip" $_.url
    if ($_.extractToPlugins -eq $true) {
      Expand-Archive -LiteralPath ./$($_.name).zip -DestinationPath ./dist/BepInEx/plugins
    }
    else {
      Expand-Archive -LiteralPath ./$($_.name).zip -DestinationPath ./dist
    }
    rm "$($_.name).zip"
  }

  if ($_.type -eq "nexus") {
    cp "./nexus/$($_.dllName)" ./dist/BepInEx/plugins
  }
}

cp ./valheim_plus.cfg ./dist/BepInEx/config

& "$env:ProgramFiles/7-zip/7z.exe" a -t7z "-p$($Password)" ./TheNorthMods.7z ./dist/*
