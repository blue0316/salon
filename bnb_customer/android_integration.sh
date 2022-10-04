pushd android
# # flutter build generates files in android/ for building the app
flutter build apk
./gradlew app:assembleAndroidTest
./gradlew app:assembleDebug -Ptarget=integration_test/app_test.dart
popd

gcloud auth activate-service-account --key-file=bowandbeautiful-dev-3d69dd3d9a3e.json
gcloud --quiet config set project bowandbeautiful-dev

gcloud firebase test android run --type instrumentation \
  --app build/app/outputs/apk/debug/app-debug.apk \
  --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
  --use-orchestrator \
  --timeout 3m \
  # --results-bucket=gs://integration_results_mjcoffee \
  # --results-dir=tests/firebase

# pushd android
# flutter build apk
# ./gradlew app:assembleAndroidTest
# ./gradlew app:assembleDebug -Ptarget=integration_test/app_test.dart
# popd
#   gcloud auth activate-service-account --key-file=testing-10f26-9ec9037ab274.json
#   gcloud --quiet config set project testing-10f26
#   gcloud firebase test android run --type instrumentation \
#   --app build/app/outputs/apk/debug/app-debug.apk \
#   --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
#   --use-orchestrator \
#   --device-ids=blueline,OnePlusST,xiq,redfin,flame \
#   --os-version-ids=25,26,27,28,29,30 \
#   --locales=en_GB,es \
#   --orientations=potrait \
#   --timeout 3m \

