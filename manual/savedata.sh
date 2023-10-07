docker exec -w /data android-%emulator_version% /usr/bin/qemu-img commit userdata-qemu.img.qcow2
docker exec -w /data android-%emulator_version% /usr/bin/qemu-img commit encryptionkey.img.qcow2
docker stop ${'$'}(docker ps -a -q)
docker rm ${'$'}(docker ps -a -q)
qemu-img convert -O qcow2 /data/android-%emulator_version%/userdata-qemu.img /data/android-%emulator_version%/userdata-qemu.img.qcow2
cp /data/android-%emulator_version%/userdata-qemu.img.qcow2 .
cp /data/android-%emulator_version%/encryptionkey.img .