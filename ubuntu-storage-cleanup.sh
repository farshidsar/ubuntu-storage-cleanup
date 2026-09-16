#!/usr/bin/env bash

set -Eeuo pipefail

# ============================================================
# Ubuntu Storage Cleanup
# Repository: ubuntu-storage-cleanup
# Author: Farshid Sar
#
# A practical Ubuntu storage cleanup utility for:
# APT, systemd journal, rotated logs, temporary files,
# old Snap revisions, Docker unused resources, crash dumps,
# and user thumbnail caches.
#
# Run:
#   sudo bash ubuntu-storage-cleanup.sh
# or:
#   chmod +x ubuntu-storage-cleanup.sh
#   sudo ./ubuntu-storage-cleanup.sh
# ============================================================

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Run this script with sudo."
    exit 1
fi

# Configuration
JOURNAL_RETENTION="7d"
JOURNAL_MAX_SIZE="200M"
MIN_FREE_GB=5

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[+]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

run_optional() {
    "$@" || warn "Skipped: $*"
}

echo "============================================================"
echo " Ubuntu Storage Cleanup"
echo " Author: Farshid Sar"
echo "============================================================"

echo
echo "Disk usage BEFORE cleanup:"
df -h /

# ------------------------------------------------------------
# 1. APT package cache and unused packages
# ------------------------------------------------------------

log "Cleaning APT cache..."
apt-get clean
apt-get autoclean -y
apt-get autoremove -y

# ------------------------------------------------------------
# 2. Systemd journal logs
# Keep the last 7 days, maximum 200 MB
# ------------------------------------------------------------

log "Cleaning systemd journal logs..."
journalctl --vacuum-time="$JOURNAL_RETENTION"
journalctl --vacuum-size="$JOURNAL_MAX_SIZE"

# ------------------------------------------------------------
# 3. Rotated and compressed log files
# Do not delete active .log files
# ------------------------------------------------------------

log "Removing old rotated logs..."

find /var/log \
    -type f \
    \( -name "*.gz" -o -name "*.old" -o -name "*.1" \
       -o -name "*.2" -o -name "*.3" -o -name "*.4" \
       -o -name "*.5" -o -name "*.6" -o -name "*.7" \) \
    -delete 2>/dev/null || true

# Remove old empty log files
find /var/log \
    -type f \
    -empty \
    -delete 2>/dev/null || true

# truncate all old empty log files
sudo truncate -s 0 /var/log/syslog
sudo truncate -s 0 /var/log/mail.log

# ------------------------------------------------------------
# 4. Temporary files
# Only remove files older than 7 days
# ------------------------------------------------------------

log "Cleaning temporary files..."

find /tmp -mindepth 1 -xdev -mtime +7 -delete 2>/dev/null || true
find /var/tmp -mindepth 1 -xdev -mtime +7 -delete 2>/dev/null || true

# ------------------------------------------------------------
# 5. Snap old revisions
# ------------------------------------------------------------

if command -v snap >/dev/null 2>&1; then
    log "Removing disabled Snap revisions..."

    snap list --all 2>/dev/null |
    awk '/disabled/{print $1, $3}' |
    while read -r snapname revision; do
        if [[ -n "$snapname" && -n "$revision" ]]; then
            snap remove "$snapname" --revision="$revision" || true
        fi
    done
fi

# ------------------------------------------------------------
# 6. Docker cleanup
# Removes unused images, stopped containers, networks,
# and build cache. Volumes are preserved.
# ------------------------------------------------------------

if command -v docker >/dev/null 2>&1; then
    echo
    warn "Docker cleanup will remove unused images, stopped containers,"
    warn "unused networks, and build cache. Volumes will be preserved."

    docker system df

    read -r -p "Clean Docker unused resources? (y/N): " DOCKER_CONFIRM

    if [[ "$DOCKER_CONFIRM" =~ ^[Yy]$ ]]; then
        log "Cleaning Docker..."

        docker system prune -af
        docker builder prune -af

        log "Docker cleanup completed."
    else
        warn "Docker cleanup skipped."
    fi
fi

# ------------------------------------------------------------
# 7. Remove old crash dumps
# ------------------------------------------------------------

log "Cleaning old crash dumps..."

find /var/crash \
    -type f \
    -mtime +7 \
    -delete 2>/dev/null || true

# ------------------------------------------------------------
# 8. Clean thumbnail cache for users
# ------------------------------------------------------------

log "Cleaning thumbnail caches..."

for user_home in /home/*; do
    if [[ -d "$user_home/.cache/thumbnails" ]]; then
        rm -rf "$user_home/.cache/thumbnails/"*
    fi
done

# ------------------------------------------------------------
# 9. Remove old temporary package files
# ------------------------------------------------------------

log "Cleaning temporary package files..."

rm -rf /var/cache/debconf/*-old 2>/dev/null || true

# ------------------------------------------------------------
# 10. Final report
# ------------------------------------------------------------

echo
echo "============================================================"
echo " Cleanup completed"
echo "============================================================"

echo
echo "Disk usage AFTER cleanup:"
df -h /

echo
echo "Largest directories:"
du -xhd1 / 2>/dev/null | sort -h | tail -n 15

echo
echo "Docker disk usage:"
if command -v docker >/dev/null 2>&1; then
    docker system df
fi

echo
log "Done."
