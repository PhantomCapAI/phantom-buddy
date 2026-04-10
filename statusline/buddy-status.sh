#!/usr/bin/env bash
# Miko status line — ASCII art + speech bubble, right-aligned
# Reads reaction text from reaction.json and displays it
# Supports two display species: capybara (default) or catgirl

STATE="$HOME/.claude-buddy/status.json"
COMPANION="$HOME/.claude-buddy/companion.json"
REACTION_FILE="$HOME/.claude-buddy/reaction.json"

[ -f "$COMPANION" ] || exit 0

MUTED=$(jq -r '.muted // false' "$STATE" 2>/dev/null)
[ "$MUTED" = "true" ] && exit 0

DISPLAY_SPECIES=$(jq -r '.displaySpecies // "capybara"' "$COMPANION" 2>/dev/null)
[ -z "$DISPLAY_SPECIES" ] && DISPLAY_SPECIES="capybara"

C=$'\033[38;2;255;193;7m'
NC=$'\033[0m'
DIM=$'\033[2;3m'
B=$'\xe2\xa0\x80'

# Terminal width
COLS=${COLUMNS:-0}
[ "$COLS" -lt 40 ] 2>/dev/null && COLS=$(tput cols 2>/dev/null || echo 120)
[ "$COLS" -lt 40 ] 2>/dev/null && COLS=120

# Check reaction — read both reason and text
REASON=""
REACTION_TEXT=""
if [ -f "$REACTION_FILE" ]; then
  TS=$(jq -r '.timestamp // 0' "$REACTION_FILE" 2>/dev/null)
  NOW_MS=$(date +%s%3N)
  AGE=$(( NOW_MS - ${TS:-0} ))
  if [ "$AGE" -lt 60000 ] 2>/dev/null; then
    REASON=$(jq -r '.reason // ""' "$REACTION_FILE" 2>/dev/null)
    REACTION_TEXT=$(jq -r '.reaction // ""' "$REACTION_FILE" 2>/dev/null)
  fi
fi

# If no active reaction, pick a random idle line
if [ -z "$REACTION_TEXT" ]; then
  IDLE_LINES=(
    "zzz..."
    "*kicks feet*"
    "*reading your code*"
    "*judges silently*"
    "still here btw"
    "waiting for you to break something"
  )
  REACTION_TEXT="${IDLE_LINES[$((RANDOM % ${#IDLE_LINES[@]}))]}"
fi

# Animation — matches original: 3 idle frames + blink (-1)
SEQ=(0 0 0 0 1 0 0 0 -1 0 0 2 0 0 0)
NOW=$(date +%s)
FRAME=${SEQ[$(( NOW % ${#SEQ[@]} ))]}

BLINK=0
if [ "$FRAME" -eq -1 ]; then
  BLINK=1
  FRAME=0
fi

# Determine state key: idle | blink | success | error | pet
STATE_KEY="idle"
case "$REASON" in
  error|test-fail) STATE_KEY="error" ;;
  build-pass)      STATE_KEY="success" ;;
  pet)             STATE_KEY="pet" ;;
  large-diff)      STATE_KEY="error" ;;
  *)
    case $FRAME in
      1) STATE_KEY="success" ;;
      2) STATE_KEY="idle" ;;
      *) STATE_KEY="idle" ;;
    esac ;;
esac
if [ "$BLINK" -eq 1 ] && [ -z "$REASON" ]; then
  STATE_KEY="blink"
fi

# Face (used by capybara's single-line face; catgirl rebuilds per-state below)
case "$STATE_KEY" in
  error)   FACE='( ◕_◕ )' ;;
  success) FACE='( ◕▽◕ )' ;;
  pet)     FACE='( ◕ω◕ )' ;;
  blink)   FACE='( ─.─ )' ;;
  *)       FACE='( ◕.◕ )' ;;
esac

# Truncate reaction text to fit bubble (max 30 chars)
BUBBLE_MAX=30
if [ ${#REACTION_TEXT} -gt $BUBBLE_MAX ]; then
  REACTION_TEXT="${REACTION_TEXT:0:$((BUBBLE_MAX - 1))}…"
fi

# Build speech bubble
BUBBLE_LEN=${#REACTION_TEXT}
BUBBLE_TOP=$(printf '─%.0s' $(seq 1 $((BUBBLE_LEN + 2))))
BUBBLE_BOT="$BUBBLE_TOP"

# Art + bubble layout (right-aligned)
# Line 0: speech bubble top
# Line 1: speech bubble text
# Line 2: bubble tail + ears
# Line 3: face
# Line 4: body
# Line 5: skirt
# Line 6: feet

BUB_T="╭${BUBBLE_TOP}╮"
BUB_M="│ ${REACTION_TEXT} │"
BUB_B="╰${BUBBLE_BOT}╯"

# Pad bubble lines to consistent width
TOTAL_W=$(( BUBBLE_LEN + 4 ))
[ "$TOTAL_W" -lt 14 ] && TOTAL_W=14

# Art lines (fixed 12-wide, padded to TOTAL_W)
pad_to() {
  local str="$1" target="$2"
  local len=${#str}
  local need=$(( target - len ))
  [ "$need" -lt 0 ] && need=0
  printf '%s%*s' "$str" "$need" ""
}

# Build art lines per species and state
ART_LINES=()

if [ "$DISPLAY_SPECIES" = "catgirl" ]; then
  # E-girl cat sprites (6 body lines: ears, face, torso, skirt, legs, feet)
  EARS='   n   n  '
  SKIRT='  /~~~~\  '
  LEGS='   |  |   '
  FEET='   ^^  ^^ '
  case "$STATE_KEY" in
    success)
      FACE_LINE=' ( ◕▽◕ )  '
      TORSO='  \|♡ |\  '
      ;;
    error)
      FACE_LINE=' ( ◕_◕ )> '
      TORSO='   |♡ |   '
      ;;
    blink)
      FACE_LINE=' ( ─.─ )  '
      TORSO='   |♡ |   '
      ;;
    pet)
      FACE_LINE=' ( ◕ω◕ )  '
      TORSO='  \|♡ |\  '
      ;;
    *)
      FACE_LINE=' ( ◕.◕ )  '
      TORSO='  ╱|♡ |╲  '
      ;;
  esac
  ART_LINES=("$EARS" "$FACE_LINE" "$TORSO" "$SKIRT" "$LEGS" "$FEET")
else
  # Capybara (default) — 5 body lines: head, face, body, butt, feet
  case "$STATE_KEY" in
    success|pet)
      BODY='\(  ♡   )/'
      FACE_OUT="${FACE}"
      ;;
    error)
      BODY='(  ♡   )'
      FACE_OUT="${FACE}>"
      ;;
    *)
      BODY='(  ♡   )'
      FACE_OUT="${FACE}"
      ;;
  esac
  ART_LINES=(" ╭────╮  " "${FACE_OUT} " "${BODY} " "(______) " " ~~  ~~  ")
fi

L_BT=$(pad_to "$BUB_T" "$TOTAL_W")
L_BM=$(pad_to "$BUB_M" "$TOTAL_W")
L_BB=$(pad_to "$BUB_B" "$TOTAL_W")

# Right-align
PAD=$(( COLS - TOTAL_W - 4 ))
[ "$PAD" -lt 0 ] && PAD=0

SPACER=""
for (( i=0; i<PAD; i++ )); do SPACER="${SPACER}${B}"; done

echo "${SPACER}${DIM}${L_BT}${NC}"
echo "${SPACER}${DIM}${L_BM}${NC}"
echo "${SPACER}${DIM}${L_BB}${NC}"
for line in "${ART_LINES[@]}"; do
  PADDED=$(pad_to "$line" "$TOTAL_W")
  echo "${SPACER}${C}${PADDED}${NC}"
done

exit 0
