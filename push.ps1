# Set console encoding to UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host '==========================================' -ForegroundColor Cyan
Write-Host '  Math Arcade Hub - Push naar GitHub Script' -ForegroundColor Cyan
Write-Host '==========================================' -ForegroundColor Cyan
Write-Host ''

# 1. Controleer of Git geïnitieerd is
if (-not (Test-Path '.git')) {
    Write-Host '[*] Git repository initialiseren...' -ForegroundColor Yellow
    git init
    # Configureer tijdelijke lokale gebruiker indien niet ingesteld
    git config --local user.name 'Math Arcade Developer'
    git config --local user.email 'dev@matharcade.hub'
    # Stel default branch in op main
    git branch -M main
} else {
    Write-Host '[✓] Git repository is al geïnitialiseerd.' -ForegroundColor Green
}

# 2. Vraag de GitHub URL
Write-Host ''
Write-Host 'Volg deze stappen als je dit nog niet gedaan hebt:' -ForegroundColor White
Write-Host '1. Ga naar https://github.com/ en log in.' -ForegroundColor White
Write-Host '2. Maak een nieuwe, lege repository aan (klik op ''+'' -> ''New repository'').' -ForegroundColor White
Write-Host '3. Geef het de naam ''MathArcadeHub'' en laat ''README'', ''gitignore'' en ''license'' uitgevinkt.' -ForegroundColor White
Write-Host '4. Kopieer de HTTPS repository URL (eindigend op .git).' -ForegroundColor White
Write-Host ''

$repoUrl = Read-Host 'Plak de GitHub HTTPS URL hier (bijv. https://github.com/GEBRUIKER/MathArcadeHub.git)'
if ($null -ne $repoUrl) {
    $repoUrl = $repoUrl.Trim()
}

if ([string]::IsNullOrEmpty($repoUrl)) {
    Write-Host '[!] Fout: Geen URL ingevoerd. Script afgebroken.' -ForegroundColor Red
    Exit
}

# Controleer of remote 'origin' al bestaat
$remotes = git remote
if ($remotes -contains 'origin') {
    Write-Host ('[*] Bestaande remote ''origin'' bijwerken naar: ' + $repoUrl) -ForegroundColor Yellow
    git remote set-url origin $repoUrl
} else {
    Write-Host '[*] Remote ''origin'' toevoegen...' -ForegroundColor Yellow
    git remote add origin $repoUrl
}

# 3. Bestanden toevoegen en committen
Write-Host ''
Write-Host '[*] Bestanden toevoegen aan Git staging...' -ForegroundColor Yellow
git add .

Write-Host '[*] Commit maken...' -ForegroundColor Yellow
git commit -m 'Configureer multi-game hub met GitHub Actions build'

# 4. Pushing naar GitHub
Write-Host ''
Write-Host '[*] Bestanden pushen naar GitHub (main branch)...' -ForegroundColor Yellow
Write-Host 'Let op: Mogelijk opent GitHub een inlogvenster in je browser om toestemming te geven.' -ForegroundColor Cyan
git push -u origin main -f

if ($LASTEXITCODE -eq 0) {
    Write-Host ''
    Write-Host '==========================================================' -ForegroundColor Green
    Write-Host '  [✓] HOERA! De bestanden zijn succesvol gepusht naar GitHub!' -ForegroundColor Green
    Write-Host '==========================================================' -ForegroundColor Green
    Write-Host ''
    Write-Host 'Wat nu?' -ForegroundColor White
    Write-Host '1. Open je repository in de browser.' -ForegroundColor White
    Write-Host '2. Klik op het tabblad ''Actions'' aan de bovenkant.' -ForegroundColor White
    Write-Host '3. Je ziet dat de workflow ''Build Android APK'' automatisch gestart is.' -ForegroundColor White
    Write-Host '4. Klik op de lopende build. Zodra deze klaar is (ongeveer 3 minuten),' -ForegroundColor White
    Write-Host '   scrol je naar ''Artifacts'' en download je ''MathArcadeHub-Android-APK''.' -ForegroundColor White
    Write-Host '5. Installeer het .apk bestand op je Android-apparaat.' -ForegroundColor White
} else {
    Write-Host ''
    Write-Host '[!] Fout bij het pushen naar GitHub. Controleer je internetverbinding, repository URL en rechten.' -ForegroundColor Red
}

Write-Host ''
Read-Host 'Druk op Enter om dit venster te sluiten...'
