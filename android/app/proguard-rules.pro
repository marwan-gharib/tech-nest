# Flutter Secure Storage - Keep all cipher implementations
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-keepclassmembers class com.it_nomads.fluttersecurestorage.** { *; }
-keepnames class com.it_nomads.fluttersecurestorage.** { *; }

# Keep cipher interfaces and implementations
-keep interface com.it_nomads.fluttersecurestorage.ciphers.** { *; }
-keep class com.it_nomads.fluttersecurestorage.ciphers.** { *; }
-keepclassmembers class com.it_nomads.fluttersecurestorage.ciphers.** { *; }

-keep class com.it_0.flutter_secure_storage.** { *; }


# Java security
-keep class javax.crypto.** { *; }
-keep class java.security.** { *; }
-dontwarn javax.crypto.**
-dontwarn java.security.**

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Flutter Local Notifications
-keep class com.dexterous.** { *; }

# FCM
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception