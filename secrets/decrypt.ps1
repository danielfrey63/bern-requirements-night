param(
  [Parameter(Mandatory=$true)][string]$InFile,          # z.B. secrets.zip.aes
  [string]$OutDir = ".\out"                             # Zielordner
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (!(Test-Path -LiteralPath $InFile)) { throw "InFile nicht gefunden: $InFile" }
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$tmpZip = Join-Path (Resolve-Path -LiteralPath $OutDir).Path ("tmp_" + [Guid]::NewGuid().ToString("N") + ".zip")

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

  Expand-Archive -LiteralPath $tmpZip -DestinationPath $OutDir -Force
  Write-Host "OK: entpackt nach $OutDir"
}
finally {
  if (Test-Path -LiteralPath $tmpZip) { Remove-Item -LiteralPath $tmpZip -Force }
}
