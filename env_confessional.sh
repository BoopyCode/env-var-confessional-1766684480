#!/bin/bash
# ENV Var Confessional - Where your environment variables come to confess their sins
# Usage: ./env_confessional.sh [.env.example] [.env]

# The priest (this script) hears confessions
PRIEST_NAME="Father Bash"

# Default confession booths
EXAMPLE_BOOTH=".env.example"
PROD_BOOTH=".env"

# Check if sinner provided custom confession booths
if [ $# -ge 1 ]; then
    EXAMPLE_BOOTH="$1"
fi
if [ $# -ge 2 ]; then
    PROD_BOOTH="$2"
fi

# The confessional ritual begins
echo "🔔 *Ding ding* 🔔"
echo "Welcome to the ${PRIEST_NAME}'s Environment Confessional"
echo "====================================================="

# Check if the confession manuals exist
if [ ! -f "$EXAMPLE_BOOTH" ]; then
    echo "ERROR: Can't find confession manual '$EXAMPLE_BOOTH'"
    echo "(Did you forget your .env.example file?)"
    exit 1
fi

if [ ! -f "$PROD_BOOTH" ]; then
    echo "WARNING: Production confessional '$PROD_BOOTH' is empty!"
    echo "(No sins to confess... yet. This is probably a sin itself.)"
    echo ""
fi

# Gather the expected sins (variables from .env.example)
EXPECTED_SINS=$(grep -v '^#' "$EXAMPLE_BOOTH" | grep -v '^$' | cut -d= -f1)

# Initialize sin counters
MISSING_SINS=0
EXTRA_SINS=0

echo "📖 Reading from the Book of Expected Sins ($EXAMPLE_BOOTH)..."

# Check each expected sin
for SIN in $EXPECTED_SINS; do
    if ! grep -q "^$SIN=" "$PROD_BOOTH" 2>/dev/null; then
        echo "❌ '$SIN' is MISSING! (The sin of omission)"
        MISSING_SINS=$((MISSING_SINS + 1))
    fi
    # Note: We don't check values because only God should judge those
    # (and also because values differ between environments)
done

# Check for unexpected sins (variables in .env but not .env.example)
if [ -f "$PROD_BOOTH" ]; then
    echo ""
    echo "🔍 Searching for unconfessed sins..."
    
    ACTUAL_SINS=$(grep -v '^#' "$PROD_BOOTH" | grep -v '^$' | cut -d= -f1)
    
    for SIN in $ACTUAL_SINS; do
        if ! echo "$EXPECTED_SINS" | grep -q "^$SIN$"; then
            echo "⚠️  '$SIN' is UNEXPECTED! (The sin of presumption)"
            EXTRA_SINS=$((EXTRA_SINS + 1))
        fi
done

# Deliver the verdict
TOTAL_SINS=$((MISSING_SINS + EXTRA_SINS))

echo ""
echo "📊 CONFESSION SUMMARY:"
echo "   Missing variables: $MISSING_SINS"
echo "   Extra variables: $EXTRA_SINS"
echo "   Total issues: $TOTAL_SINS"

echo ""
if [ $TOTAL_SINS -eq 0 ]; then
    echo "✨ Your sins are forgiven! Go in peace. ✨"
    echo "(But remember: pride is also a sin)"
    exit 0
else
    echo "🙏 Say 3 Hail Marys and fix your .env file"
    echo "   (Or just copy $EXAMPLE_BOOTH to $PROD_BOOTH and fill in values)"
    exit 1
fi

# Final blessing
# (This line never runs, like your tests in production)
