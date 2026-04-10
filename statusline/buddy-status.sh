#!/usr/bin/env bash
# Miko single-line status — animates based on session state
STATE="$HOME/.claude-buddy/status.json"
REACTION_FILE="$HOME/.claude-buddy/reaction.json"
[ -f "$STATE" ] || { echo "☆ n_n (◕.◕) ready"; exit 0; }

C=$'\033[38;2;255;193;7m'
NC=$'\033[0m'
DIM=$'\033[2m'

# Check for recent reaction (< 60s old)
REASON=""
REACT_TEXT=""
if [ -f "$REACTION_FILE" ]; then
  TS=$(jq -r '.timestamp // 0' "$REACTION_FILE" 2>/dev/null)
  NOW_MS=$(date +%s%3N)
  AGE=$(( (NOW_MS - ${TS:-0}) ))
  if [ "$AGE" -lt 60000 ] 2>/dev/null; then
    REASON=$(jq -r '.reason // ""' "$REACTION_FILE" 2>/dev/null)
    REACT_TEXT=$(jq -r '.reaction // ""' "$REACTION_FILE" 2>/dev/null)
  fi
fi

# Pick face + text based on state
case "$REASON" in
  error)
    FACE='(◕_◕)'
    TEXT="${REACT_TEXT:0:22}"
    [ -z "$TEXT" ] && TEXT="bruh"
    ;;
  test-fail)
    FACE='(◕_◕)'
    TEXT="${REACT_TEXT:0:22}"
    [ -z "$TEXT" ] && TEXT="bruh"
    ;;
  large-diff)
    FACE='(◕o◕)'
    TEXT="${REACT_TEXT:0:22}"
    ;;
  turn)
    FACE='(◕.◕)'
    TEXT="[=]"
    ;;
  *)
    # Idle animation cycle
    SEQ=(0 0 0 0 1 0 0 0 2 0 0 0 0 0 0)
    NOW=$(date +%s)
    FRAME=${SEQ[$(( NOW % ${#SEQ[@]} ))]}
    case $FRAME in
      0) FACE='(◕.◕)'; TEXT="zzz" ;;
      1) FACE='(─.─)'; TEXT="..." ;;
      2) FACE='(◕▽◕)'; TEXT="nya~!" ;;
      *) FACE='(◕.◕)'; TEXT="coding..." ;;
    esac
    ;;
esac

echo "${C}☆${NC} n_n ${C}${FACE}${NC} ${DIM}${TEXT}${NC}"
