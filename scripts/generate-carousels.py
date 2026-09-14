"""
Genereert Instagram-carousels als PNG-bestanden (1080x1350px).
Week 3 — HR / Arbeidscontracten
"""

from PIL import Image, ImageDraw, ImageFont
import os
import textwrap

# Kleuren
BG = (10, 10, 10)
WHITE = (255, 255, 255)
EMERALD = (16, 185, 129)
GRAY = (163, 163, 163)

W, H = 1080, 1350
MARGIN = 80
LOGO_TEXT = "ZekerWet"

OUTPUT = os.path.join(os.path.dirname(__file__), "..", "Projects", "ZekerWet", "marketing", "carousels")
os.makedirs(OUTPUT, exist_ok=True)


def get_font(size, bold=False):
    font_names = [
        "arialbd.ttf" if bold else "arial.ttf",
        "Arial Bold.ttf" if bold else "Arial.ttf",
        "DejaVuSans-Bold.ttf" if bold else "DejaVuSans.ttf",
    ]
    for name in font_names:
        try:
            return ImageFont.truetype(name, size)
        except:
            pass
    return ImageFont.load_default()


def draw_slide(slide_num, total, title, body, accent_label=None, is_cta=False):
    img = Image.new("RGB", (W, H), BG)
    d = ImageDraw.Draw(img)

    # Logo linksboven
    logo_font = get_font(28, bold=True)
    d.text((MARGIN, MARGIN), LOGO_TEXT, font=logo_font, fill=EMERALD)

    # Slidenummer rechtsboven
    num_font = get_font(22)
    num_text = f"{slide_num}/{total}"
    num_w = d.textlength(num_text, font=num_font)
    d.text((W - MARGIN - num_w, MARGIN), num_text, font=num_font, fill=GRAY)

    # Emerald lijn onder logo
    d.rectangle([(MARGIN, MARGIN + 50), (W - MARGIN, MARGIN + 53)], fill=EMERALD)

    y = MARGIN + 90

    if accent_label:
        label_font = get_font(20, bold=True)
        d.text((MARGIN, y), accent_label.upper(), font=label_font, fill=EMERALD)
        y += 40

    # Titel
    title_font = get_font(58 if not is_cta else 64, bold=True)
    lines = textwrap.wrap(title, width=22)
    for line in lines:
        d.text((MARGIN, y), line, font=title_font, fill=WHITE)
        y += 75
    y += 20

    if not is_cta:
        # Body
        body_font = get_font(32)
        body_lines = textwrap.wrap(body, width=34)
        for line in body_lines:
            d.text((MARGIN, y), line, font=body_font, fill=GRAY)
            y += 46
    else:
        # CTA body en URL
        body_font = get_font(34)
        body_lines = textwrap.wrap(body, width=32)
        for line in body_lines:
            d.text((MARGIN, y), line, font=body_font, fill=WHITE)
            y += 50
        y += 30
        url_font = get_font(36, bold=True)
        d.text((MARGIN, y), "zekerwet.nl", font=url_font, fill=EMERALD)

    return img


# ─── CAROUSEL 1: Dinsdag 25 aug ─────────────────────────────────────────────
# "5 fouten bij ontslag" — 7 slides

slides_c1 = [
    {
        "title": "5 fouten bij ontslag die je duur betalen.",
        "body": "Werkgevers verliezen ontslagzaken niet door slechte bedoelingen. Ze verliezen ze door vermijdbare procedurefouten.",
    },
    {
        "label": "Fout 01",
        "title": "Geen dossier opgebouwd voor ontslag.",
        "body": "Ontslag zonder schriftelijk verbeterplan (PIP) is aanvechtbaar. De rechter vraagt bewijs van inspanning. BW art. 669.",
    },
    {
        "label": "Fout 02",
        "title": "Aanzegplicht vergeten bij tijdelijk contract.",
        "body": "Bij contracten van 6 maanden of langer: uiterlijk 1 maand voor einddatum aanzeggen. Vergeten? Boete van 1 maandsalaris (WAB, art. 7:668).",
    },
    {
        "label": "Fout 03",
        "title": "VSO zonder bedenktijd.",
        "body": "Werknemer heeft 14 dagen bedenktijd na ondertekening (BW art. 7:670b). Staat dit er niet in? De overeenkomst is vernietigbaar.",
    },
    {
        "label": "Fout 04",
        "title": "Concurrentiebeding niet schriftelijk.",
        "body": "Mondeling afgesproken: juridisch nul en nietig. BW art. 7:653 eist expliciete schriftelijke instemming. Geen handtekening? Het beding geldt niet.",
    },
    {
        "label": "Fout 05",
        "title": "Verkeerde ontslagroute gekozen.",
        "body": "UWV of kantonrechter? Bedrijfseconomisch ontslag via UWV. Disfunctioneren via de rechter. De keuze bepaalt de kosten en uitkomst. BW art. 669 lid 3.",
    },
    {
        "title": "Documenten klaar. Procedure correct.",
        "body": "ZekerWet heeft alle HR-documenten: verbeterplan, aanzegbrief, vaststellingsovereenkomst. Getoetst aan Nederlands recht, klaar voor jurist-review.",
        "cta": True,
    },
]

print("Carousel 1 (dinsdag 25 aug — 7 slides)...")
for i, s in enumerate(slides_c1, 1):
    img = draw_slide(
        slide_num=i,
        total=7,
        title=s["title"],
        body=s.get("body", ""),
        accent_label=s.get("label"),
        is_cta=s.get("cta", False),
    )
    path = os.path.join(OUTPUT, f"carousel1_slide{i:02d}.png")
    img.save(path, "PNG")
    print(f"  Slide {i}/7 opgeslagen: {path}")

# ─── CAROUSEL 2: Vrijdag 28 aug ─────────────────────────────────────────────
# "De aanzegbrief" — 5 slides

slides_c2 = [
    {
        "title": "De aanzegbrief: klein formulier, groot gevolg.",
        "body": "Vergeet je hem? Dan kost het je direct geld. Dit moet elke werkgever weten.",
    },
    {
        "label": "Definitie",
        "title": "Wat is een aanzegbrief?",
        "body": "Een schriftelijke mededeling aan je werknemer: zijn tijdelijk contract loopt af en wordt wel of niet verlengd. Verplicht per de WAB.",
    },
    {
        "label": "Wanneer verplicht",
        "title": "Wanneer ben je verplicht aan te zeggen?",
        "body": "Bij elk tijdelijk contract van 6 maanden of langer. Uiterlijk 1 maand voor de einddatum. BW art. 7:668.",
    },
    {
        "label": "De rekening",
        "title": "Te laat of vergeten? Dit is de rekening.",
        "body": "Te laat: maximaal 1 maandsalaris boete. Helemaal vergeten: volledige maandsalaris-vergoeding. De rechter wijkt hier zelden van af.",
    },
    {
        "title": "Aanzegbrief in 2 minuten klaar.",
        "body": "Juridisch correct, getoetst aan Nederlands recht, klaar voor jurist-review.",
        "cta": True,
    },
]

print("\nCarousel 2 (vrijdag 28 aug — 5 slides)...")
for i, s in enumerate(slides_c2, 1):
    img = draw_slide(
        slide_num=i,
        total=5,
        title=s["title"],
        body=s.get("body", ""),
        accent_label=s.get("label"),
        is_cta=s.get("cta", False),
    )
    path = os.path.join(OUTPUT, f"carousel2_slide{i:02d}.png")
    img.save(path, "PNG")
    print(f"  Slide {i}/5 opgeslagen: {path}")

print(f"\nAlle slides staan in: {os.path.abspath(OUTPUT)}")
