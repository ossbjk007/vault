# Bewaakt de supportinbox van ZekerWet en meldt via Telegram.
#
# Waarom: op 4 september 2026 mailde een betalende Business-klant naar
# support@zekerwet.nl dat inloggen niet lukte. Die mail lag tien dagen
# ongelezen tussen 128 andere in de Gmail-box. Alles aan @zekerwet.nl komt via
# ImprovMX in zekerwet@gmail.com binnen, en niemand keek.
#
# Twee meldingen:
#   1. Direct: elke nieuwe mail aan support@ of info@zekerwet.nl, één keer.
#   2. Dagelijks om 09:00 (eerste run erna): alles aan @zekerwet.nl dat ouder
#      is dan 24 uur, nog in de inbox staat en nog geen antwoord heeft.
#      Archiveren in Gmail = afgehandeld. Beantwoorden vanuit Gmail = afgehandeld.
#
# Wordt aangeroepen door check-support-inbox.ps1, dat de secrets als
# omgevingsvariabelen meegeeft. Alleen leesverkeer naar Gmail via IMAP.
#
#   --dry-run    toon wat er gemeld zou worden, stuur niets, schrijf geen state

import email
import imaplib
import json
import os
import sys
import urllib.parse
import urllib.request
from datetime import datetime, timedelta, timezone
from email.header import decode_header, make_header
from email.utils import parseaddr, parsedate_to_datetime
from pathlib import Path

HERE = Path(__file__).resolve().parent
STATE = HERE / ".support-inbox-alerts"
FAILLOG = HERE / ".notify-failures.log"
WATCHED = ("support@zekerwet.nl", "info@zekerwet.nl")
NAG_HOUR = 9
NAG_AGE_HOURS = 24
LOOKBACK_DAYS = 30
STATE_TTL_DAYS = 60

DRY = "--dry-run" in sys.argv

# De Windows-console staat op cp1252 en struikelt over emoji in de dry-run-uitvoer.
for stream in (sys.stdout, sys.stderr):
    try:
        stream.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass


def env(name):
    v = os.environ.get(name, "").strip()
    if not v:
        print(f"check-support-inbox: {name} ontbreekt in secrets.local.ps1", file=sys.stderr)
        sys.exit(2)
    return v


def telegram(text):
    if DRY:
        print("--- zou sturen ---\n" + text + "\n")
        return
    data = urllib.parse.urlencode({
        "chat_id": env("TELEGRAM_CHATID"), "text": text, "parse_mode": "HTML",
    }).encode()
    try:
        urllib.request.urlopen(
            f"https://api.telegram.org/bot{env('TELEGRAM_TOKEN')}/sendMessage", data, timeout=20
        ).read()
    except Exception as e:  # een alarmkanaal dat stil faalt is geen alarmkanaal
        with FAILLOG.open("a", encoding="utf-8") as f:
            f.write(f"{datetime.now().isoformat()}\tsupport-inbox\t{e}\n")
        print(f"check-support-inbox: Telegram niet afgeleverd - {e}", file=sys.stderr)
        sys.exit(1)


def esc(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def hdr(msg, name):
    raw = msg.get(name, "")
    try:
        return str(make_header(decode_header(raw)))
    except Exception:
        return raw


def load_state():
    st = {"alerted": {}, "last_nag": ""}
    if STATE.exists():
        try:
            st.update(json.loads(STATE.read_text(encoding="utf-8")))
        except Exception:
            pass
    return st


def save_state(st):
    if DRY:
        return
    cutoff = (datetime.now(timezone.utc) - timedelta(days=STATE_TTL_DAYS)).isoformat()
    st["alerted"] = {k: v for k, v in st["alerted"].items() if v >= cutoff}
    STATE.write_text(json.dumps(st, indent=1), encoding="utf-8")


def to_watched(msg):
    """True als een van de bewaakte adressen in To/Cc/Delivered-To staat."""
    fields = []
    for h in ("To", "Cc", "Delivered-To", "X-Forwarded-To"):
        fields.extend(str(v) for v in msg.get_all(h, []))
    joined = " ".join(fields).lower()
    return any(a in joined for a in WATCHED)


def fetch(imap, uid):
    typ, data = imap.uid("fetch", uid, "(FLAGS BODY.PEEK[HEADER])")
    if typ != "OK" or not data or data[0] is None:
        return None, ""
    flags = data[0][0].decode(errors="replace")
    msg = email.message_from_bytes(data[0][1])
    return msg, flags


def main():
    user, pw = env("GMAIL_USER"), env("GMAIL_APP_PASSWORD")
    st = load_state()
    now = datetime.now(timezone.utc)
    since = (now - timedelta(days=LOOKBACK_DAYS)).strftime("%d-%b-%Y")

    imap = imaplib.IMAP4_SSL("imap.gmail.com")
    imap.login(user, pw)
    imap.select("INBOX", readonly=True)

    # Eén IMAP-zoekopdracht per bewaakt adres; Gmail's OR-syntax is wispelturig.
    uids = set()
    for addr in WATCHED:
        typ, data = imap.uid("search", None, f'(SINCE {since} TO "{addr}")')
        if typ == "OK" and data and data[0]:
            uids.update(data[0].split())

    new, open_items = [], []
    for uid in sorted(uids, key=int):
        msg, flags = fetch(imap, uid.decode())
        if msg is None or not to_watched(msg):
            continue
        mid = msg.get("Message-ID", "").strip() or f"uid:{uid.decode()}"
        try:
            sent = parsedate_to_datetime(msg.get("Date"))
            if sent.tzinfo is None:
                sent = sent.replace(tzinfo=timezone.utc)
        except Exception:
            sent = now
        name, addr = parseaddr(hdr(msg, "From"))
        item = {
            "mid": mid, "from": name or addr, "addr": addr,
            "subject": hdr(msg, "Subject") or "(geen onderwerp)",
            "sent": sent, "answered": "\\Answered" in flags,
        }
        if mid not in st["alerted"]:
            new.append(item)
        if not item["answered"] and (now - sent) > timedelta(hours=NAG_AGE_HOURS):
            open_items.append(item)
    imap.logout()

    local = datetime.now()
    for it in new:
        age = now - it["sent"]
        hours = int(age.total_seconds() // 3600)
        oud = f" (al {hours // 24} dagen oud)" if hours >= 48 else (f" (al {hours} uur oud)" if hours >= 2 else "")
        telegram(
            f"📩 <b>Nieuwe mail voor ZekerWet-support</b>{esc(oud)}\n\n"
            f"Van: {esc(it['from'])} &lt;{esc(it['addr'])}&gt;\n"
            f"Onderwerp: {esc(it['subject'])}\n"
            f"Ontvangen: {it['sent'].astimezone().strftime('%d-%m-%Y %H:%M')}\n\n"
            f"Beantwoorden vanuit Gmail als support@zekerwet.nl. Archiveren als het geen klantvraag is."
        )
        st["alerted"][it["mid"]] = now.isoformat()

    today = local.strftime("%Y-%m-%d")
    if open_items and local.hour >= NAG_HOUR and st.get("last_nag") != today:
        lines = []
        for it in sorted(open_items, key=lambda x: x["sent"]):
            days = (now - it["sent"]).days
            lines.append(f"• {esc(it['from'])}: {esc(it['subject'])} ({days} d)")
        telegram(
            f"⏰ <b>{len(open_items)} supportmail(s) zonder antwoord</b>\n\n" + "\n".join(lines) +
            "\n\nOuder dan 24 uur, nog in de inbox, niet beantwoord vanuit Gmail. Beantwoorden of archiveren."
        )
        st["last_nag"] = today

    save_state(st)
    print(f"check-support-inbox: {len(uids)} bekeken, {len(new)} nieuw gemeld, {len(open_items)} open")


if __name__ == "__main__":
    main()
