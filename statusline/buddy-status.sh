#!/usr/bin/env bash
# Miko (capybara) status line — ASCII art + speech bubble, right-aligned
# Reads reaction text from reaction.json and displays it

STATE="$HOME/.claude-buddy/status.json"
COMPANION="$HOME/.claude-buddy/companion.json"
REACTION_FILE="$HOME/.claude-buddy/reaction.json"

[ -f "$COMPANION" ] || exit 0

MUTED=$(jq -r '.muted // false' "$STATE" 2>/dev/null)
[ "$MUTED" = "true" ] && exit 0

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

# Face based on state
case "$REASON" in
  error|test-fail) FACE='( ◕_◕ )' ;;
  large-diff)      FACE='( ◕o◕ )' ;;
  build-pass)      FACE='( ◕▽◕ )' ;;
  pet)             FACE='( ◕ω◕ )' ;;
  *)
    case $FRAME in
      0) FACE='( ◕.◕ )' ;;
      1) FACE='( ◕▽◕ )' ;;
      2) FACE='( ◕.◕ )' ;;
    esac ;;
esac

# Blink: replace eyes with ─ (only when idle)
if [ "$BLINK" -eq 1 ] && [ -z "$REASON" ]; then
  FACE='( ─.─ )'
fi

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

# Body + face based on state
case "$REASON" in
  build-pass|pet)
    BODY='\(  ♡   )/'
    FACE_LINE="${FACE}"
    ;;
  error)
    BODY='(  ♡   )'
    FACE_LINE="${FACE}>"
    ;;
  test-fail)
    BODY='(  ...  )'
    FACE_LINE="${FACE}"
    ;;
  *)
    BODY='(  ♡   )'
    FACE_LINE="${FACE}"
    ;;
esac


L_BT=$(pad_to "$BUB_T" "$TOTAL_W")
L_BM=$(pad_to "$BUB_M" "$TOTAL_W")
L_BB=$(pad_to "$BUB_B" "$TOTAL_W")
L_HEAD=$(pad_to " ╭────╮  " "$TOTAL_W")
L_FACE=$(pad_to "${FACE_LINE} " "$TOTAL_W")
L_BODY=$(pad_to "${BODY} " "$TOTAL_W")
L_BUTT=$(pad_to "(______) " "$TOTAL_W")
L_FEET=$(pad_to " ~~  ~~  " "$TOTAL_W")

# Right-align
PAD=$(( COLS - TOTAL_W - 4 ))
[ "$PAD" -lt 0 ] && PAD=0

SPACER=""
for (( i=0; i<PAD; i++ )); do SPACER="${SPACER}${B}"; done

echo "${SPACER}${DIM}${L_BT}${NC}"
echo "${SPACER}${DIM}${L_BM}${NC}"
echo "${SPACER}${DIM}${L_BB}${NC}"
echo "${SPACER}${C}${L_HEAD}${NC}"
echo "${SPACER}${C}${L_FACE}${NC}"
echo "${SPACER}${C}${L_BODY}${NC}"
echo "${SPACER}${C}${L_BUTT}${NC}"
echo "${SPACER}${C}${L_FEET}${NC}"

exit 0
