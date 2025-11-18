Write-Output "Convertendo D2Bridge.Lang.rc para D2Bridge.Lang.rc.laz..."
Get-Content "D2Bridge.Lang.rc" | ForEach-Object {
    if ($_ -match '^(.*?)\s+RCDATA\s+"(.*?)"$') {
        $id = $matches[1]
        $path = $matches[2] -replace '\\\\', '\'
        "$path=$id"
    }
} | Set-Content "D2Bridge.Lang.rc.laz"

Write-Output "Convertendo Prism\prism.rc para Prism\prism.rc.laz..."
Get-Content "Prism\prism.rc" | ForEach-Object {
    if ($_ -match '^(.*?)\s+RCDATA\s+"(.*?)"$') {
        $id = $matches[1]
        $path = $matches[2] -replace '\\\\', '\'
        "Prism\$path=$id"
    }
} | Set-Content "Prism\prism.rc.laz"
