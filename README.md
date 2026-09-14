# Ubuntu Storage Cleanup

A practical Bash utility for reclaiming disk space on Ubuntu by cleaning APT cache, systemd journal data, rotated logs, old temporary files, disabled Snap revisions, unused Docker resources, crash dumps, and thumbnail caches.

**Author:** Farshid Sar  
**License:** MIT

> ⭐ If this project is useful to you, please give the repository a **Star**. It helps the project reach more people and gives me motivation to maintain and improve it.

## Languages

- English — this file
- [فارسی](README.fa.md)
- [العربية](README.ar.md)
- [Русский](README.ru.md)

## Features

- Shows disk usage before and after cleanup.
- Cleans APT package cache.
- Removes unused APT packages.
- Vacuums systemd journal logs.
- Removes rotated and compressed logs.
- Removes temporary files older than 7 days.
- Removes disabled Snap revisions when Snap is installed.
- Optionally cleans unused Docker resources after asking for confirmation.
- Preserves Docker volumes.
- Removes old crash dumps.
- Clears user thumbnail caches.
- Shows the largest top-level directories after cleanup.

## Requirements

- Ubuntu or a compatible Debian-based distribution
- Bash
- `sudo` / root privileges
- `systemd` for journal cleanup
- Snap is optional
- Docker is optional

## Installation

Clone the repository:

```bash
git clone https://github.com/farshidsar/ubuntu-storage-cleanup.git
cd ubuntu-storage-cleanup
```

Make the script executable:

```bash
chmod +x ubuntu-storage-cleanup.sh
```

## Usage

Recommended:

```bash
sudo ./ubuntu-storage-cleanup.sh
```

You can also run it directly with Bash:

```bash
sudo bash ubuntu-storage-cleanup.sh
```

The script refuses to run without root privileges.

## Docker cleanup

When Docker is installed, the script displays Docker disk usage and asks:

```text
Clean Docker unused resources? (y/N):
```

Docker cleanup only runs when you explicitly enter `y` or `Y`.

The script runs:

```bash
docker system prune -af
docker builder prune -af
```

This may remove unused images, stopped containers, unused networks, and build cache. **Docker volumes are preserved.**

## Configuration

These values are defined near the top of the script:

```bash
JOURNAL_RETENTION="7d"
JOURNAL_MAX_SIZE="200M"
MIN_FREE_GB=5
```

`JOURNAL_RETENTION` controls journal retention time, and `JOURNAL_MAX_SIZE` controls the journal vacuum size target.

> Note: `MIN_FREE_GB` is currently defined but is not yet used by the cleanup logic.

## Important warning

This script performs destructive cleanup operations. Review the script before using it on production servers or systems containing important data.

It removes files from locations including:

```text
/var/log
/tmp
/var/tmp
/var/crash
/home/*/.cache/thumbnails
/var/cache/debconf
```

The script also deletes empty files under `/var/log`, so review that behavior if your services rely on pre-created empty log files.

## Quick download/run workflow

After cloning:

```bash
cd ubuntu-storage-cleanup
chmod +x ubuntu-storage-cleanup.sh
sudo ./ubuntu-storage-cleanup.sh
```

## Project structure

```text
ubuntu-storage-cleanup/
├── ubuntu-storage-cleanup.sh
├── README.md
├── README.fa.md
├── README.ar.md
├── README.ru.md
└── LICENSE
```

## Contributing

Issues, suggestions, and Pull Requests are welcome. Improvements related to safety, portability, reporting, configuration, or cleanup behavior are especially appreciated.

## Support the project ⭐

If the script saved you time or disk space, please give the repository a **Star ⭐**.

A Star helps others discover the project and motivates me to keep fixing issues and adding useful improvements.

## License

Released under the [MIT License](LICENSE).

Copyright © 2026 Farshid Sar.
