#!/bin/bash
# Quick Deploy Script for Scheduled Notification Feature
# Run this after the code changes are complete

echo "🚀 Deploying Scheduled Notification Feature"
echo "=========================================="
echo ""

# Check if we're in the right directory
if [ ! -f "firebase.json" ]; then
    echo "❌ Error: Please run this from the project root directory"
    exit 1
fi

echo "📦 Step 1: Installing dependencies..."
cd functions
npm install
cd ..
echo "✅ Dependencies installed"
echo ""

echo "🔐 Step 2: Checking Firebase authentication..."
if ! firebase projects:list &> /dev/null; then
    echo "⚠️  Not authenticated. Please run: firebase login --reauth"
    exit 1
fi
echo "✅ Authenticated"
echo ""

echo "☁️  Step 3: Deploying Cloud Functions..."
echo "This may take a few minutes..."
firebase deploy --only functions

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Deployment successful!"
    echo ""
    echo "📝 IMPORTANT: Next steps:"
    echo ""
    echo "1. Copy the function URL from above (look for 'scheduleNotification')"
    echo "   Example: https://us-central1-l-alternative-bf37d.cloudfunctions.net"
    echo ""
    echo "2. Update lib/src/features/notifications/services/cloud_functions_service.dart"
    echo "   Line 12: Replace 'YOUR_REGION-YOUR_PROJECT_ID' with the URL above"
    echo ""
    echo "3. Test the feature:"
    echo "   - Run: flutter run"
    echo "   - Go to Profile tab"
    echo "   - Scroll to DEBUG ZONE"
    echo "   - Press 'Add Notifs' button"
    echo "   - Kill the app"
    echo "   - Wait 10 seconds for notification!"
    echo ""
    echo "🎊 All done! Ready to test notifications when app is killed!"
else
    echo ""
    echo "❌ Deployment failed"
    echo ""
    echo "Common fixes:"
    echo "1. Run: firebase login --reauth
    "
    echo "2. Check billing is enabled (Blaze plan required for Cloud Functions)"
    echo "3. Check functions/package.json has Node.js 20"
    echo ""
fi
