param(
  [Parameter(Mandatory=$true)][string]$InFile,          # z.B. secrets.zip.aes
  [string]$OutDir = ".\out"                             # Zielordner oder Output-Datei
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (!(Test-Path -LiteralPath $InFile)) { throw "InFile nicht gefunden: $InFile" }

$outExists = Test-Path -LiteralPath $OutDir
$outIsDir = $false
if ($outExists) {
  $outIsDir = (Test-Path -LiteralPath $OutDir -PathType Container)
}

$outLooksLikeFile = (-not [string]::IsNullOrWhiteSpace([IO.Path]::GetExtension($OutDir)))
$treatAsFile = ($outLooksLikeFile -and (-not $outIsDir))

if ($treatAsFile) {
  $outFilePath = [IO.Path]::GetFullPath($OutDir, (Get-Location).Path)
  $outFileDir = Split-Path -Parent $outFilePath
  if ([string]::IsNullOrWhiteSpace($outFileDir)) { throw "Ungueltiger OutDir/OutFile: $OutDir" }
  if (!(Test-Path -LiteralPath $outFileDir)) { New-Item -ItemType Directory -Force -Path $outFileDir | Out-Null }

  $extractDir = Join-Path ([IO.Path]::GetTempPath()) ("decrypt_" + [Guid]::NewGuid().ToString("N"))
  New-Item -ItemType Directory -Force -Path $extractDir | Out-Null
  $tmpZip = Join-Path $extractDir ("tmp_" + [Guid]::NewGuid().ToString("N") + ".zip")
}
else {
  New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
  $extractDir = (Resolve-Path -LiteralPath $OutDir).Path
  $tmpZip = Join-Path $extractDir ("tmp_" + [Guid]::NewGuid().ToString("N") + ".zip")
}

try {
  $pw = Read-Host "Passwort" -AsSecureString

  $inFs = [IO.File]::OpenRead((Resolve-Path -LiteralPath $InFile))
  $salt = New-Object byte[] 16
  if ($inFs.Read($salt, 0, 16) -ne 16) { throw "Ungueltiges File (Salt fehlt/zu kurz)." }

  $kdf = New-Object Security.Cryptography.Rfc2898DeriveBytes($pw, $salt, 200000, [Security.Cryptography.HashAlgorithmName]::SHA256)
  $aes = [Security.Cryptography.Aes]::Create()
  $aes.Mode = [Security.Cryptography.CipherMode]::CBC
  $aes.Padding = [Security.Cryptography.PaddingMode]::PKCS7
  $aes.Key = $kdf.GetBytes(32)
  $aes.IV  = $kdf.GetBytes(16)

  $cs = New-Object Security.Cryptography.CryptoStream($inFs, $aes.CreateDecryptor(), [Security.Cryptography.CryptoStreamMode]::Read)
  $outFs = [IO.File]::Open($tmpZip, [IO.FileMode]::Create, [IO.FileAccess]::Write, [IO.FileShare]::None)

  $buf = New-Object byte[] (1024*1024)
  while (($n = $cs.Read($buf, 0, $buf.Length)) -gt 0) { $outFs.Write($buf, 0, $n) }

  $outFs.Dispose(); $cs.Dispose(); $inFs.Dispose()

  Expand-Archive -LiteralPath $tmpZip -DestinationPath $extractDir -Force

  if ($treatAsFile) {
    $items = Get-ChildItem -LiteralPath $extractDir -File -Recurse
    if ($items.Count -ne 1) {
      throw "Archiv enthaelt $($items.Count) Dateien; kann nicht eindeutig nach '$outFilePath' schreiben."
    }

    Move-Item -LiteralPath $items[0].FullName -Destination $outFilePath -Force
    Write-Host "OK: geschrieben nach $outFilePath"
  }
  else {
    Write-Host "OK: entpackt nach $extractDir"
  }
}
finally {
  if (Test-Path -LiteralPath $tmpZip) { Remove-Item -LiteralPath $tmpZip -Force }
  if ($treatAsFile -and (Test-Path -LiteralPath $extractDir)) { Remove-Item -LiteralPath $extractDir -Recurse -Force }
}
