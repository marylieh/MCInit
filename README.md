# MCInit

MCInit is a command-line interface (CLI) tool designed to simplify the initialization of Minecraft server instances. With MCInit, you can easily set up and configure Minecraft servers using a single command.

## Features

- Support for multiple server types (e.g., Paper, Velocity).
- Flexible server version selection.
- Automatic EULA acceptance (if specified).
- Memory allocation for server instances.

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
- `-v`, `--version` (Required): The server version (e.g., `1.21.1`).
- `-e`, `--eula`: Accept the Mojang EULA (default: `false`).
- `-m`, `--memory`: Memory allocation in MiB (default: `1024`).

### Example Commands

1. Initialize a Paper server with 2 GB of memory:

   ```bash
   mcinit my-server -t Paper -v 1.21.1 -e -m 2048
   ```

2. Initialize a Velocity server with the default memory:

   ```bash
   mcinit my-proxy -t Velocity -v 1.21.1 -e
   ```

## How It Works

1. **Instance Initialization**: Creates a new directory for the server instance.
2. **Server Download**: Downloads the selected server type and version.
3. **EULA Acceptance**: Automatically writes the Mojang EULA file if accepted.
4. **Memory Configuration**: Configures the server with the specified memory allocation.

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request if you have ideas for improvements or additional features.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contact

If you have any questions or feedback, feel free to reach out or open an issue in the repository.
