Write-Host "Dit script maakt gebruikers aan in Active Directory en enabled het account direct. 
Het script zorgt er ook voor dat de gebruiker bij het eerstvolgende inloggen het wachtwoord moet veranderen."

# Aantal gebruikers tellen in csv-bestand
$userFile = "C:\users.csv"
$userCount = (Import-Csv $userFile).count
Write-Host "Er zullen $userCount gebruikers aangemaakt worden."

# Vraag de gebruiker of hij wil doorgaan met het script
$choice = Read-Host "Wilt u doorgaan? (ja/nee)"

# array's aanmaken om aangemaakte gebruikers op te slaan
$createdUsers = @()
$notcreatedUsers = @()

# Stel de voorkeur voor foutacties in om stil door te gaan voor een specifiek gedeelte van het script. 
# Op deze manier krijg je alleen de door dit scipt geprogammeerde foutmeldingen te zien. Zet een # voor het onderstaande commando -
# om deze functie uit te zetten zodat powershell cmdlets fouten weer laat zien.
$ErrorActionPreference = "SilentlyContinue"

if ($choice -eq "ja") {
    # Variabelen maken die de namen van de gebruikers opslaan
    Import-CSV $userFile | ForEach-Object {
        $firstname = $_.Firstname
        $lastname = $_.lastname
        $samaccountname = $_.samaccountname

        #Aanmaken van de users
        New-ADUser -Name $samaccountname `
            -GivenName $firstname `
            -Surname $lastname `
            -SamAccountName $samaccountname `
            -Enabled $true `
            -AccountPassword (ConvertTo-SecureString -AsPlainText "Password1" -Force) `
            -ChangePasswordAtLogon $true `

        # Controleren of aanmaken van user gelukt is
        if ($?) {
            Write-Host "Useraccount $samAccountName is succesfully created" -ForegroundColor Green

            # Aangemaakte users toevoegen aan de arraylist createdUsers.
            $createdUsers += $firstname + " " + $lastname
        }
        else {
            Write-Host "Useraccount $samAccountName is NOT created" -ForegroundColor Red

            #Niet aangemaakte users toevoegen aan de arraylist notcreatedUsers.
            $notcreatedUsers += $firstname + " " + $lastname
        }
    }

    #output in de console wat overzichtelijker maken
    Write-Host "-"
    Write-Host "-"
    Write-Host "-"

    # Totaal aantal gemaakte en niet gemaakte gebruikersaccounts
    $SucceededUserCount = $createdUsers.Length
    Write-Host "Er zijn $SucceededUserCount nieuwe users aangemaakt"

    $notSucceededUserCount = $notcreatedUsers.Length
    Write-Host "Er zijn $notSucceededUserCount users die niet gemaakt zijn"

    # file maken met daarin de aangemaakte users.
    Write-Host "-------------------------------------------------------"
    $createdUsers | Out-File "C:\Script_output-files\created_users.txt"
    Write-Host "Een tekstbestand met de namen van de aangemaakte gebruikers is aangemaakt op C:\Script_output-files\created_users.txt"
   
    # file maken met daarin de niet-aangemaakte users.
    $notcreatedUsers | Out-File "C:\Script_output-files\notcreated_users.txt"
    Write-Host "Een tekstbestand met de namen van de niet aangemaakte gebruikers is aangemaakt op C:\Script_output-files\notcreated_users.txt"
}
else {
    # Script wordt afgebroken als de user iets anders dan 'ja' ingevuld heeft.
    Write-Host "Script afgebroken"
}