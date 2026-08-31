# MaturinForAndroid

**Maturin binaries for Android and Termux.**

MaturinForAndroid provides prebuilt Maturin releases for ARM64 Android devices running Termux, making it easier to use Maturin directly on Android.

## Installation

Run the following command in Termux:

```bash
git clone https://github.com/19919rohit/MaturinForAndroid.git && cd MaturinForAndroid && bash install-maturin.sh
```

The installer will display the available releases and let you choose the Maturin version you want to install.

After installation, verify it with:

```bash
maturin --version
```

## Requirements

- Android device
- [Termux](https://termux.dev/)
- ARM64 / `aarch64` architecture
- Internet connection

Check your device architecture:

```bash
uname -m
```

For supported devices, the output should be:

```text
aarch64
```

## Usage

Once installed, Maturin can be used directly from the Termux shell.

Show the available commands:

```bash
maturin --help
```

Show the installed version:

```bash
maturin --version
```

### Create a Project

Create a new Maturin project:

```bash
maturin new my_project
cd my_project
```

### Build a Wheel

Build the project:

```bash
maturin build
```

The generated wheel will be placed in the project's `target/wheels/` directory.

### Development Installation

Install the project into the active Python environment:

```bash
maturin develop
```

## Releases

MaturinForAndroid provides prebuilt releases for Android/Termux.

[View Releases](https://github.com/19919rohit/MaturinForAndroid/releases)

Each release contains the corresponding Maturin build and release information.

## Architecture

MaturinForAndroid currently targets:

```text
Operating System: Android
Environment:      Termux
Architecture:     ARM64 (aarch64)
```

To check your architecture:

```bash
uname -m
```

## Why MaturinForAndroid?

Maturin is built around Rust and Python packaging. Building it directly on an Android device can require a substantial native build environment and compilation of Rust dependencies.

MaturinForAndroid provides ready-to-use Android binaries so Maturin can be installed and used directly from Termux.

This is particularly useful for Android-based development environments where compiling large native toolchains locally is inconvenient or impractical.

## Project Structure

```text
MaturinForAndroid/
├── install-maturin.sh
└── README.md
```

### `install-maturin.sh`

The installation script handles downloading and installing the selected Maturin release into the Termux environment.

## Updating Maturin

To install another available release, run the installer again:

```bash
cd MaturinForAndroid
bash install-maturin.sh
```

Select the desired release when prompted.

## Verify Your Installation

Use:

```bash
maturin --version
which maturin
```

You can also check your Python environment:

```bash
python --version
```

## Troubleshooting

If Maturin is not working as expected, collect the following information:

```bash
uname -m
python --version
maturin --version
which maturin
```

Make sure that:

1. You are running Termux on an ARM64 device.
2. The installation completed successfully.
3. `maturin` is available in your `PATH`.
4. Your Python environment is configured correctly.

## Contributing

Issues, improvements, and contributions are welcome.

If you find a problem with a release or the installation process, open an issue with your device architecture, Python version, Maturin version, and the command or error that caused the problem.

## License

MaturinForAndroid is a distribution project providing prebuilt Maturin binaries for Android/Termux.

Maturin itself is an open-source project developed and maintained by its respective contributors.

See the individual release and upstream project information for applicable licensing details.
