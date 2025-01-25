# MCInit

MCInit is a command-line interface (CLI) tool designed to simplify the initialization of Minecraft server instances. With MCInit, you can easily set up and configure Minecraft servers using a single command.

## Features

- Support for multiple server types (e.g., Paper, Velocity).
- Flexible server version selection (default is the latest version).
- Automatic EULA acceptance (if specified).
- Memory allocation for server instances.
- No GUI mode to disable the server GUI.
- Specify a server operator during initialization.
- Add players to the server whitelist.
- Configure server default gamemode (creative, adventure, survival, spectator).
- Configure server difficulty (peaceful, easy, normal, hard).
- Set a custom Message of the Day (MotD).

## Requirements

- macOS or Linux with Swift installed.
- Internet connection for downloading server files.

## Installation

1. Clone the repository:

   ```bash
   git clone https://gitlab.marylieh.social/md-public/mcinit.git
   cd mcinit
   ```

2. Build the project using the Swift Package Manager or simply download from the releases page:

   ```bash
   swift build -c release
   ```

3. Run the executable:

   ```bash
   .build/release/mcinit
   ```

## Usage

MCInit provides a simple interface to initialize a Minecraft server instance. Below are the available arguments and options:

### Arguments

- `name` (Required): The name of the new server instance.

### Options

- `-t`, `--type` (Required): The server type (e.g., `Paper`, `Velocity`).
- `-v`, `--version`: The server version (default: `latest`).
- `-e`, `--eula`: Accept the Mojang EULA (default: `false`).
- `-m`, `--memory`: Memory allocation in MiB (default: `1024`).
- `-n`, `--nogui`: Disable the server GUI (default: `false`).
- `-o`, `--operator`: Set the initial server operator (only one player can be set).
- `-w`, `--whitelist`: Add players to the server whitelist (comma-separated).
- `-g`, `--gamemode`: Set the server default gamemode (`creative`, `adventure`, `survival`, `spectator`).
- `-d`, `--difficulty`: Set the server difficulty (`peaceful`, `easy`, `normal`, `hard`).
- `--motd`: Set the server Message of the Day (MotD).

### Example Commands

1. Initialize a Paper server with 2 GB of memory and a custom operator:

   ```bash
   mcinit my-server -t Paper -v 1.21.1 -e -m 2048 -o PlayerName
   ```

2. Initialize a Velocity server with the default memory and a whitelist:

   ```bash
   mcinit my-proxy -t Velocity -e -w Player1,Player2
   ```

3. Initialize a server with a custom gamemode, difficulty, and MotD:

   ```bash
   mcinit custom-server -t Paper -e -g survival -d hard --motd "Welcome to my server!"
   ```

## How It Works

1. **Instance Initialization**: Creates a new directory for the server instance.
2. **Server Download**: Downloads the selected server type and version.
3. **EULA Acceptance**: Automatically writes the Mojang EULA file if accepted.
4. **Memory Configuration**: Configures the server with the specified memory allocation.
5. **Custom Configuration**: Applies additional configurations like operators, whitelist, gamemode, difficulty, and MotD.

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request if you have ideas for improvements or additional features.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contact

If you have any questions or feedback, feel free to reach out or open an issue in the repository.
