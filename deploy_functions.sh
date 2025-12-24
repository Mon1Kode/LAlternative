#!/bin/bash
# Firebase Cloud Functions Deployment Script
# After upgrading to Node.js 20

echo "🚀 Firebase Cloud Functions Deployment"
echo "========================================"
echo ""

# Check if we're in the right directory
if [ ! -f "firebase.json" ]; then
    echo "❌ Error: firebase.json not found. Please run this from the project root."
    exit 1
fi

# Check if functions directory exists
if [ ! -d "functions" ]; then
    echo "❌ Error: functions directory not found."
    exit 1
fi

echo "✅ Project structure verified"
echo ""

# Check Node.js version
NODE_VERSION=$(node --version)
echo "📦 Local Node.js version: $NODE_VERSION"
echo ""

# Check Firebase CLI
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI not found. Please install it first:"
    echo "   npm install -g firebase-tools"
    exit 1
fi

echo "✅ Firebase CLI found"
echo ""

# Check authentication
echo "🔐 Checking Firebase authentication..."
if ! firebase projects:list &> /dev/null; then
    echo "⚠️  Not authenticated. Running login..."
    firebase login --reauth
else
    echo "✅ Already authenticated"
fi
echo ""

# Show current project
echo "📋 Current Firebase project:"
firebase use
echo ""

# Deploy functions
echo "🚀 Deploying Cloud Functions with Node.js 20 runtime..."
echo ""
firebase deploy --only functions

# Check deployment status
if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Deployment successful!"
    echo ""
    echo "📝 Next steps:"
    echo "   1. Copy the function URLs from above"
    echo "   2. Update lib/src/features/notifications/services/cloud_functions_service.dart"
    echo "   3. Replace 'YOUR_REGION-YOUR_PROJECT_ID' with actual values"
    echo ""
else
    echo ""
    echo "❌ Deployment failed. Check the error messages above."
    echo ""
    echo "💡 Common solutions:"
    echo "   1. Run: firebase login --reauth"
    echo "   2. Check your Firebase project billing status"
    echo "   3. Verify you have permissions to deploy"
    echo ""
fi
