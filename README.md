# Docker Emulator for Android

`docker-emulator-android` is an essential component of the android-farm project. It empowers you to run an Android emulator with hardware acceleration within a Docker container.

## Key Features

- **High-Performance Configuration:** `docker-emulator-android` employs a high-performance default vCPU and RAM configuration based on recommendations from [this presentation](https://heisenbug.ru/talks/2f486c767b6b99e6a9a2188ace7460d9/) and [this presentation](https://heisenbug.ru/talks/4cbf30da4f9c48ea9f76cf3abfec76f7/) on performance.

- **Preparatory Manipulations via ADB:** The project performs necessary preparatory manipulations with the Android device using the Android Debug Bridge (ADB), ensuring readiness to work with settings and applications.

- **Predefined Values:** All required values and configurations are predefined in the `config.ini` file, simplifying the setup process.

- **Structured Setup Steps:** All necessary steps for configuration and project launch are structured as Bash scripts, making deployment and management straightforward.

- **Liveness Probe:** `docker-emulator-android` includes a liveness probe mechanism, ensuring reliable and automatic detection of the container and emulator's state.

## Current android tools

**commandlinetools linux** - `10406996`

## Building

To build the project, follow these steps:

Clone the project

```console
git clone https://github.com/VKCOM/docker-emulator-android.git
```

Go to the project directory

```console
cd docker-emulator-android/build/
```

Make an image build

```console
docker build -t docker-emulator-android-30 .
```

## Usage

To illustrate, here's how to run the default emulator settings with Android API 30:

```console
docker run --rm --privileged -e ANDROID_ARCH="x86" -v /dev/kvm:/dev/kvm docker-emulator-android-30:1
```

For a comprehensive list of available options, please refer to the [official documentation](https://developer.android.com/studio/run/emulator-commandline.html).

## License

`docker-emulator-android` is an open-source project and is made available under the [Apache License, Version 2.0](LICENSE).

Please note that Android SDK components are governed by the [Android Software Development Kit License](https://developer.android.com/studio/terms.html).
