"""
Volledige carousel-automatisering voor ZekerWet:
1. Uploadt PNG-slides naar imgbb (publieke URLs)
2. Plant de carousel in Buffer voor Instagram en Facebook
3. Voegt de caption toe

Gebruik:
    python scripts/post-carousel.py --carousel 1 --date "2026-08-25" --time "11:00"
    python scripts/post-carousel.py --carousel 2 --date "2026-08-28" --time "11:00"
"""

import argparse
import json
import os
import sys
from pathlib import Path
import requests

IMGBB_KEY = os.environ.get("IMGBB_API_KEY", "")
BUFFER_KEY = os.environ.get("BUFFER_API_KEY", "")

IG_CHANNEL  = "6a8a05baccaf649a67f8ca2e"
FB_CHANNEL  = "6a8a080accaf649a67f8d4e0"

VAULT = Path(__file__).parent.parent
CAROUSEL_DIR = VAULT / "Projects" / "ZekerWet" / "marketing" / "carousels"

CAPTIONS = {
    1: """Vijf ontslagfouten die werkgevers elke week geld kosten. En hoe je ze voorkomt.

Ontslag is in Nederland geen kwestie van "werknemer aanspreken en laten gaan." De wet stelt harde eisen aan dossieropbouw, procedure en timing. Wie dat negeert, staat met lege handen bij de rechter.

De vijf meest voorkomende fouten:

1. Geen verbeterplan (PIP) opgebouwd voor ontslag wegens disfunctioneren.
2. Aanzegplicht vergeten bij tijdelijke contracten van 6 maanden of langer.
3. Vaststellingsovereenkomst zonder wettelijke bedenktijd van 14 dagen.
4. Concurrentiebeding mondeling afgesproken in plaats van schriftelijk vastgelegd.
5. Verkeerde ontslagroute gekozen: UWV versus kantonrechter.

Elk van deze fouten is gebaseerd op BW boek 7 en de Wet Arbeidsmarkt in Balans (WAB).

ZekerWet heeft alle HR-documenten klaar: verbeterplan, aanzegbrief, vaststellingsovereenkomst. Getoetst aan Nederlands recht, klaar voor jurist-review.

Start gratis op zekerwet.nl

Laat juridisch belangrijke documenten altijd nakijken door een jurist voor ondertekening.

#zzp #mkb #ondernemen #ondernemerschap #arbeidsrecht #ontslag #hrmanagement #juridisch""",

    2: """De aanzegbrief vergeten kost je een volledig maandsalaris.

Veel werkgevers weten niet dat de aanzegtermijn wettelijk verplicht is bij tijdelijke contracten van 6 maanden of langer. Niet op tijd aanzeggen? Maximaal 1 maandsalaris boete. Helemaal vergeten? Dan betaal je de volledige vergoeding.

Dat staat zwart op wit in het Burgerlijk Wetboek, art. 7:668.

ZekerWet heeft een aanzegbrief-template die voldoet aan de WAB en het BW. In 2 minuten ingevuld.

Laat juridisch belangrijke documenten altijd nakijken door een jurist voor ondertekening.

Genereer jouw aanzegbrief op zekerwet.nl/documenten/aanzegbrief

#zzp #mkb #arbeidscontract #aanzegbrief #wetdba #juridisch #ondernemen #compliance"""
}


def upload_to_imgbb(image_path: Path) -> str:
    with open(image_path, "rb") as f:
        resp = requests.post(
            "https://api.imgbb.com/1/upload",
            params={"key": IMGBB_KEY},
            files={"image": (image_path.name, f, "image/png")},
            timeout=60,
        )
    result = resp.json()
    if not result.get("success"):
        raise RuntimeError(f"imgbb upload mislukt: {result}")
    url = result["data"]["url"]
    print(f"  Geupload: {image_path.name} -> {url}")
    return url


def schedule_buffer_carousel(channel_id: str, image_urls: list, caption: str, due_at: str, channel_name: str):
    assets = [{"image": {"url": url}} for url in image_urls]

    payload = {
        "channelId": channel_id,
        "schedulingType": "automatic",
        "mode": "customScheduled",
        "dueAt": due_at,
        "text": caption,
        "assets": assets,
        "metadata": {
            "instagram": {"type": "post", "shouldShareToFeed": True} if "instagram" in channel_name else None,
            "facebook": {"type": "post"} if "facebook" in channel_name else None,
        }
    }
    # Verwijder None-waarden uit metadata
    payload["metadata"] = {k: v for k, v in payload["metadata"].items() if v is not None}

    import subprocess
    import tempfile

    with tempfile.NamedTemporaryFile(mode="w", suffix=".json", delete=False, encoding="utf-8") as f:
        json.dump(payload, f, ensure_ascii=False)
        tmp = f.name

    try:
        env = os.environ.copy()
        env["BUFFER_API_KEY"] = BUFFER_KEY
        env["HOME"] = os.environ.get("USERPROFILE", os.environ.get("HOME", ""))

        tmp_escaped = tmp.replace("\\", "/")
        result = subprocess.run(
            ["powershell", "-ExecutionPolicy", "Bypass", "-Command",
             f"buffer posts create --input \"{tmp_escaped}\" --output json"],
            capture_output=True, text=True, env=env, shell=False
        )
        out = result.stdout.strip() or result.stderr.strip()
        first_line = out.split("\n")[0].strip()
        try:
            parsed = json.loads(first_line)
            status = parsed.get("post", {}).get("status") or parsed.get("error", {}).get("message", "ok")
        except Exception:
            status = first_line[:80]
        print(f"  Buffer ({channel_name}): {status}")
        return status
    finally:
        os.unlink(tmp)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--carousel", type=int, required=True, choices=[1, 2])
    parser.add_argument("--date", required=True, help="Datum YYYY-MM-DD")
    parser.add_argument("--time", required=True, help="Tijd HH:MM")
    args = parser.parse_args()

    prefix = f"carousel{args.carousel}_slide"
    slides = sorted(CAROUSEL_DIR.glob(f"{prefix}*.png"))

    if not slides:
        print(f"Geen slides gevonden voor carousel {args.carousel} in {CAROUSEL_DIR}")
        sys.exit(1)

    due_at = f"{args.date}T{args.time}:00+02:00"
    caption = CAPTIONS[args.carousel]

    print(f"\nCarousel {args.carousel} — {len(slides)} slides — ingepland op {due_at}")
    print("\nStap 1: slides uploaden naar imgbb...")

    image_urls = []
    for slide in slides:
        url = upload_to_imgbb(slide)
        image_urls.append(url)

    print(f"\nStap 2: posts inplannen in Buffer...")
    schedule_buffer_carousel(IG_CHANNEL, image_urls, caption, due_at, "instagram")
    schedule_buffer_carousel(FB_CHANNEL, image_urls, caption, due_at, "facebook")

    print(f"\nKlaar. Carousel {args.carousel} ingepland op {args.date} om {args.time}.")


if __name__ == "__main__":
    main()
