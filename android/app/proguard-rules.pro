# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Keep Google Play services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Keep Kotlin metadata
-keep class kotlin.Metadata { *; }
-keepclassmembers class ** {
    @kotlin.Metadata *;
}

# Keep serialized/deserialized model classes
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Do not warn about javax annotations
-dontwarn javax.annotation.**
