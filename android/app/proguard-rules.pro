# android/app/proguard-rules.pro
# قواعد بسيطة آمنة مع Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.**
