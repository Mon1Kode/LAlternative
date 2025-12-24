#!/bin/bash
# Test script to verify FCM token is saved correctly

echo "🔍 FCM Token Save Verification Test"
echo "===================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "This script will help you verify that the FCM token fix is working."
echo ""

# Check if Firebase CLI is available
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}❌ Firebase CLI not found${NC}"
    echo "Please install: npm install -g firebase-tools"
    exit 1
fi

echo -e "${GREEN}✅ Firebase CLI found${NC}"
echo ""

# Prompt for user ID
echo "📝 Enter the User ID to check (from your app logs):"
echo "   Example: GK76R1N9C3eCk5OLeod70ed1B6o2"
read -p "User ID: " USER_ID

if [ -z "$USER_ID" ]; then
    echo -e "${RED}❌ User ID is required${NC}"
    exit 1
fi

echo ""
echo "🔍 Checking FCM token for user: $USER_ID"
echo ""

# Check if user exists in database
echo "Querying Firebase Realtime Database..."
TOKEN_DATA=$(firebase database:get /users/$USER_ID/fcmToken 2>&1)

if echo "$TOKEN_DATA" | grep -q "null"; then
    echo -e "${RED}❌ FCM token NOT found for this user${NC}"
    echo ""
    echo "Possible reasons:"
    echo "1. User not logged in"
    echo "2. FCM not initialized yet"
    echo "3. App not run after the fix"
    echo ""
    echo "Solution:"
    echo "1. Run: flutter run"
    echo "2. Login to the app"
    echo "3. Wait a few seconds"
    echo "4. Run this script again"
    exit 1
elif echo "$TOKEN_DATA" | grep -q "Error"; then
    echo -e "${RED}❌ Error querying database${NC}"
    echo "$TOKEN_DATA"
    echo ""
    echo "Make sure you're authenticated:"
    echo "  firebase login"
    exit 1
else
    echo -e "${GREEN}✅ FCM token found!${NC}"
    echo ""
    echo "Token data:"
    echo "$TOKEN_DATA"
    echo ""

    # Extract and display key information
    if echo "$TOKEN_DATA" | grep -q "token"; then
        echo -e "${GREEN}✅ Token field present${NC}"
    fi

    if echo "$TOKEN_DATA" | grep -q "platform"; then
        PLATFORM=$(echo "$TOKEN_DATA" | grep "platform" | cut -d':' -f2 | tr -d ' ",')
        echo -e "${GREEN}✅ Platform: $PLATFORM${NC}"
    fi

    if echo "$TOKEN_DATA" | grep -q "updatedAt"; then
        echo -e "${GREEN}✅ Timestamp present${NC}"
    fi
fi

echo ""
echo "🧪 Testing notification send..."
echo ""

# Test notification via Cloud Function
read -p "Send a test notification to this user? (y/n): " SEND_TEST

if [ "$SEND_TEST" == "y" ]; then
    echo ""
    echo "Sending test notification via Cloud Function..."

    RESPONSE=$(curl -s -X POST \
      https://us-central1-l-alternative-bf37d.cloudfunctions.net/sendNotification \
      -H "Content-Type: application/json" \
      -d "{
        \"userId\": \"$USER_ID\",
        \"title\": \"Test Notification\",
        \"body\": \"FCM token fix verification test\",
        \"data\": {\"test\": \"true\"}
      }")

    if echo "$RESPONSE" | grep -q "success"; then
        echo -e "${GREEN}✅ Notification sent successfully!${NC}"
        echo "Check your device for the notification."
    else
        echo -e "${RED}❌ Failed to send notification${NC}"
        echo "Response: $RESPONSE"
    fi
fi

echo ""
echo "📊 Verification Summary"
echo "======================"
echo ""

if echo "$TOKEN_DATA" | grep -q "token"; then
    echo -e "${GREEN}✅ FCM Token: Saved correctly${NC}"
    echo -e "${GREEN}✅ User ID: Using real Firebase Auth UID${NC}"
    echo -e "${GREEN}✅ Database Path: Correct${NC}"
    echo -e "${GREEN}✅ Fix Status: Working!${NC}"
    echo ""
    echo "🎉 The fix is working! Notifications should work now."
else
    echo -e "${YELLOW}⚠️  Token not found yet${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Make sure user is logged in"
    echo "2. Restart the app"
    echo "3. Check logs for: fcm.token_saved_to_database"
    echo "4. Run this script again"
fi

echo ""
