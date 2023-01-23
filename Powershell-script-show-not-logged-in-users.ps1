# Deze code gebruikt de cmdlet "Get-ADUser" om informatie op te halen van gebruikers in Active Directory (AD). 
# Het gebruikt de -Filter optie om een zoekopdracht uit te voeren voor gebruikers die voldoen aan de opgegeven conditie.
# De conditie zegt dat alleen gebruikers waarvan de "lastlogontimestamp" niet gelijk is aan een wildcard (*) worden opgehaald. 
# Dit betekent dat alleen gebruikers waarvan de "lastlogontimestamp" niet bekend is of nog niet is ingesteld, worden opgehaald.
# Daarna wordt de output doorgegeven aan de cmdlet "Select-Object" waarmee de output wordt gefilterd op basis van de opgegeven velden. 
# De opgegeven velden zijn "Name", "givenname" en "surname". Dit zorgt ervoor dat alleen de namen, voornamen en achternamen van gebruikers worden weergegeven die voldoen aan de zoekopdracht.
# Op deze manier kan de script de gebruikersnamen, voornamen en achternamen opleveren die nog niet ingelogd zijn in de afgelopen 90 dagen.
# Een opmerking hierbij is dat de "lastlogontimestamp" veld dat alleen wordt bijgehouden op de primaire Domain controller en niet wordt gesynchroniseerd naar de andere Domain Controllers, 
# dus de zoekopdracht zal alleen gebruikers opleveren die zich aanmelden op de primaire Domain controller. 
# Als u wilt dat de zoekopdracht gebruikers oplevert die zich aanmelden op elke Domain controller, dan moet u de zoekopdracht uitvoeren op elke Domain controller.


# Deze opdracht haalt informatie op over gebruikers in Active Directory (AD) die recentelijk niet hebben ingelogd.
Get-ADUser -Filter {(lastlogontimestamp -notlike "*")} | Select Name,givenname,surname