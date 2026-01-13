# Preserve Google Maps classes
-keep class com.google.android.gms.** { *; }
-keep interface com.google.android.gms.** { *; }
-keepnames class com.google.android.gms.**

# Keep GoogleMapsFlutter plugin classes
-keep class com.google.maps.android.** { *; }
-keep interface com.google.maps.android.** { *; }

# Keep Flutter WebView classes
-keep class com.google.android.webkit.** { *; }
-keep interface com.google.android.webkit.** { *; }

# Keep View classes
-keep public class android.view.** { *; }
-keep public class android.widget.** { *; }

# Keep Kotlin reflection
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

# Keep BuildConfig
-keep class **.BuildConfig { *; }

# Keep R classes
-keepclassmembers class **.R$* {
    public static <fields>;
}

# Preserve line numbers for debugging
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# Keep Main Activity
-keep public class com.example.new_project.MainActivity { *; }

# Do not warn about unused classes
-dontwarn com.google.android.gms.**
-dontwarn com.google.maps.android.**
-dontwarn sun.misc.Unsafe
