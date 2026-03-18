#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Ignore missing Play Core classes (not used in this app)
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Additional Flutter rules
-keep class io.flutter.embedding.** { *; }

-optimizationpasses 3 
-overloadaggressively 
-repackageclasses '' 
-allowaccessmodification
-adaptresourcefilenames    **.properties,**.gif,**.jpg 
-adaptresourcefilecontents **.properties,META-INF/MANIFEST.MF