# Flutter Local Notifications - Keep generic signatures for Gson
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Keep Gson classes and prevent TypeToken issues
-keep class com.google.gson.** { *; }
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keepclassmembers class * extends com.google.gson.reflect.TypeToken {
    *;
}

# Critical: Keep flutter_local_notifications plugin classes
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep interface com.dexterous.flutterlocalnotifications.** { *; }

# Keep h2.a class that's causing the issue
-keep class h2.** { *; }

# Keep notification model classes
-keep class * implements android.os.Parcelable {
    public static final ** CREATOR;
}

# Preserve generic type information for Gson serialization
-keepclassmembers,allowobfuscation class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep all classes that use TypeToken
-keep class * extends com.google.gson.reflect.TypeToken {
    *;
}

# General R8/ProGuard rules for Gson
-dontwarn com.google.gson.**

# Keep Flutter plugin registrant
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.common.** { *; }

# Keep notification related Android classes
-keep class androidx.core.app.NotificationCompat** { *; }
-keep class android.app.Notification** { *; }
