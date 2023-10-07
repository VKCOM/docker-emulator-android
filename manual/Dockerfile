# Вместо %emulator_version%:%docker.image.tag% следует указать версию эмулятора и тег образа, которые мы хотим обновить вручную
FROM docker/android-emulators/android-%emulator_version%:%docker.image.tag%

ENV EXTRA_EMULATOR_OPTS="-data /data/userdata-qemu.img.qcow2 -encryption-key /data/encryptionkey.img"
ENV EMULATOR_OPTS="-screen multi-touch -no-boot-anim -noaudio -nojni -netfast -verbose -skip-adb-auth -snapshot default -no-snapshot-save"
ENV QEMU_OPTS="-cpu host"
ENV ANDROID_CONFIG="abi.type=x86_64;hw.cpu.arch=x86_64;hw.cpu.ncore=6;hw.ramSize=7684;disk.dataPartition.size=10000M;hw.camera.back=virtualscene;hw.camera.front=emulated;"

COPY userdata-qemu.img.qcow2  /data/userdata-qemu.img.qcow2
COPY encryptionkey.img  /data/encryptionkey.img
CMD /opt/sdk/start.sh