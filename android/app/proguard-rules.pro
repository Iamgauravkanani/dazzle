# Add project-specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified in proguard-android-optimize.txt.

# Keep Razorpay classes and annotations
-keep class com.razorpay.** { *; }
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }
-dontwarn com.razorpay.**
-dontwarn proguard.annotation.**

# Keep CachedNetworkImage classes
-keep class com.baseflow.flutter.image.** { *; }
-dontwarn com.baseflow.flutter.image.**

# FlutterFire (Firebase) rules
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Flutter-specific rules
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**
-keep class androidx.** { *; }
-dontwarn androidx.**

# Prevent R8 from removing Kotlin metadata
-keep class kotlin.** { *; }
-dontwarn kotlin.**
-keep class kotlin.Metadata { *; }

# Keep JSON serialization classes (if used, e.g., for Firestore)
-keep class com.fasterxml.jackson.** { *; }
-dontwarn com.fasterxml.jackson.**

# Prevent obfuscation of classes used in reflection
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod

# Optimize by removing unused logging
-assumenosideeffects class android.util.Log {
    public static *** v(...);
    public static *** d(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}

# Keep line numbers for debugging stack traces
-keepattributes SourceFile,LineNumberTable

# Optimize for performance
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*
-optimizationpasses 5