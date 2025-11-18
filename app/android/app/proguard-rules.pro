# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# Protect Firebase configuration from reverse engineering
# Obfuscate Firebase-related classes and methods
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep Firebase initialization
-keep class me.micheltlutz.bankstatement.MainActivity { *; }

# Prevent decompilation of sensitive data
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Obfuscate all code except native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelables
-keep class * implements android.os.Parcelable {
    public static final ** CREATOR;
}

# Keep Serializable classes
-keepnames class * implements java.io.Serializable
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

