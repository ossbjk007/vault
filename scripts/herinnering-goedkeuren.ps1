# Wekelijks, zondag 18:00. De goedkeuringsronde uit cadence.md.
$b = @"
Weekbatch goedkeuren. Ongeveer tien minuten.

  npm run mkt:approve

in de ZekerWet-repo. Je krijgt de batch, de X-teksten om te plakken, en een biolink alleen
als die is veranderd.

Niets goedkeuren is een geldige uitkomst, maar dan gaat die week leeg de deur uit en staat dat
zo in het rapport. Stilte telt niet als ja.
"@
& "C:\Users\acerd\OneDrive\Documenten\vault\scripts\notify.ps1" -Titel "Weekbatch goedkeuren" -Bericht $b
