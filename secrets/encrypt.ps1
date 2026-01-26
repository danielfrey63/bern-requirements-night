param(
  [Parameter(Mandatory=$true)][string]$SourcePath,          # Datei oder Ordner
  [string]$OutFile = "secrets.zip.aes"                      # Output (Ciphertext)
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (!(Test-Path -LiteralPath $SourcePath)) { throw "SourcePath nicht gefunden: $SourcePath" }

# Temp-ZIP im gleichen Ordner wie Output (vermeidet komische relative Pfade)
$outDirRaw = Split-Path -Parent $OutFile
if ([string]::IsNullOrWhiteSpace($outDirRaw)) {
  $outFull = (Get-Location).Path
} else {
  $outFull = [IO.Path]::GetFullPath($outDirRaw, (Get-Location).Path)
  if (!(Test-Path -LiteralPath $outFull)) { New-Item -ItemType Directory -Force -Path $outFull | Out-Null }
}
$outLeaf = Split-Path -Leaf $OutFile
$outPath = Join-Path $outFull $outLeaf

$tmpZip = Join-Path $outFull ("tmp_" + [Guid]::NewGuid().ToString("N") + ".zip")

try {
  # 1) ZIP erstellen
  $srcItem = Get-Item -LiteralPath $SourcePath
  if ($srcItem.PSIsContainer) {
    Compress-Archive -Path (Join-Path $SourcePath "*") -DestinationPath $tmpZip -Force
  } else {
    Compress-Archive -Path $SourcePath -DestinationPath $tmpZip -Force
  }

  # 2) AES-256 verschluesseln (Salt im Header der Ausgabedatei)
  $pw   = Read-Host "Passwort" -AsSecureString
  $salt = New-Object byte[] 16
  [Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($salt)

  $kdf = $null
  $aes = $null
  $inFs = $null
  $outFs = $null
  $cs = $null
  try {
    $kdf = New-Object Security.Cryptography.Rfc2898DeriveBytes($pw, $salt, 200000, [Security.Cryptography.HashAlgorithmName]::SHA256)
    $aes = [Security.Cryptography.Aes]::Create()
    $aes.Mode = [Security.Cryptography.CipherMode]::CBC
    $aes.Padding = [Security.Cryptography.PaddingMode]::PKCS7
    $aes.Key = $kdf.GetBytes(32)
    $aes.IV  = $kdf.GetBytes(16)

    $inFs  = [IO.File]::OpenRead($tmpZip)
    $outFs = [IO.File]::Open($outPath, [IO.FileMode]::Create, [IO.FileAccess]::Write, [IO.FileShare]::None)

    # Header: 16B Salt, danach Ciphertext
    $outFs.Write($salt, 0, $salt.Length)
    $cs = New-Object Security.Cryptography.CryptoStream($outFs, $aes.CreateEncryptor(), [Security.Cryptography.CryptoStreamMode]::Write)

    $buf = New-Object byte[] (1024*1024)
    while (($n = $inFs.Read($buf, 0, $buf.Length)) -gt 0) { $cs.Write($buf, 0, $n) }

    $cs.FlushFinalBlock()
  }
  finally {
    if ($cs) { $cs.Dispose() }
    if ($outFs) { $outFs.Dispose() }
    if ($inFs) { $inFs.Dispose() }
    if ($aes) { $aes.Dispose() }
    if ($kdf) { $kdf.Dispose() }
  }

  Write-Host "OK: $outPath"
}
finally {
  if (Test-Path -LiteralPath $tmpZip) { Remove-Item -LiteralPath $tmpZip -Force }
}
