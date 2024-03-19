#!/bin/bash

set -ex -o pipefail

EMULATOR_ROOT="${ANDROID_HOME}/emulator"
PATH="$PATH:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/emulator"
EMULATOR_OPTS="-screen multi-touch -no-boot-anim -verbose -qt-hide-window -skip-adb-auth -writable-system -debug-init -logcat '*:v'"

# Export library paths
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${EMULATOR_ROOT}/lib64/qt/lib:${EMULATOR_ROOT}/lib64/libstdc++:${EMULATOR_ROOT}/lib64:${EMULATOR_ROOT}/lib64/gles_swiftshader
export LIBGL_DEBUG=verbose


# Start the emulator
${EMULATOR_ROOT}/emulator \
  -avd x86_64 \
  -gpu swiftshader_indirect \
  -no-window \
  -timezone Europe/Moscow \
  -ports ${CONSOLE_PORT},${ADB_PORT} \
  ${EMULATOR_OPTS} &

EMULATOR_PID=$!

adb wait-for-device
boot_completed=`adb -e shell getprop sys.boot_completed 2>&1`
timeout=0
until [ "X${boot_completed:0:1}" = "X1" ]; do
    sleep 5
    boot_completed=`adb shell getprop sys.boot_completed 2>&1 | head -n 1`
    echo "Read boot_completed property: <$boot_completed>"
    let "timeout += 1"
    if [ $timeout -gt 300 ]; then
         echo "Failed to start emulator"
         exit 1
    fi
done
echo "Setup emulator settings throw shell manipulation."
adb shell su 0 'settings put system system_locales ru-RU &&
settings put secure immersive_mode_confirmations confirmed &&
settings put global window_animation_scale 0.0 &&
settings put global transition_animation_scale 0.0 &&
settings put global animator_duration_scale 0.0 &&
settings put secure long_press_timeout 1800 &&
settings put secure show_ime_with_hard_keyboard 1 &&
settings put secure spell_checker_enabled 0 &&
settings put secure autofill_service null &&
settings put global hidden_api_policy 1 &&
settings put system pointer_location 1 &&
settings put system show_touches 1 &&
echo "chrome --disable-fre --no-default-browser-check --no-first-run" > /data/local/tmp/chrome-command-line &&
am set-debug-app —persistent com.android.chrome'
sleep 2
#adb install /opt/apks/com.google.android.tts.apk
#adb install /opt/apks/Google.apk
#adb install /opt/apks/GMaps.apk
echo "Rebooting emulator after shell manipulation."
adb reboot
adb wait-for-device
#adb shell setprop debug.emulator.pod $HOSTNAME
#adb shell setprop debug.emulator.node $NODE_NAME
adb shell setprop debug.emulator.type $EMULATOR_TYPE


ip=$(ip addr list eth0|grep "inet "|cut -d' ' -f6|cut -d/ -f1)

redir --laddr=$ip --lport=9999 --caddr=127.0.0.1 --cport=5037 &
redir --laddr=$ip --lport=${CONSOLE_PORT} --caddr=127.0.0.1 --cport=${CONSOLE_PORT} &
redir --laddr=$ip --lport=${ADB_PORT} --caddr=127.0.0.1 --cport=${ADB_PORT} &

echo "Emulator preparation finished"
wait ${EMULATOR_PID}
python3 /opt/crashlytics.py