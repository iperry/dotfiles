#!/usr/bin/env python3
"""Set X11 background to a random Microsoft Spotlight wallpaper using feh."""

import argparse
import random
import subprocess
import sys
import time
from pathlib import Path

from spotlight import fetch_spotlight_data, extract_image_info, download_image, get_image_hash, sanitize_filename

DEFAULT_DIR = Path.home() / ".local/share/spotlight"
MAX_AGE_SECONDS = 86400  # 1 day


def get_existing_images(directory: Path) -> list[Path]:
    """Get all jpg images in the spotlight directory."""
    if not directory.exists():
        return []
    return list(directory.glob("*.jpg"))


def images_are_stale(directory: Path) -> bool:
    """Check if the newest image is older than MAX_AGE_SECONDS."""
    images = get_existing_images(directory)
    if not images:
        return True
    newest = max(img.stat().st_mtime for img in images)
    return (time.time() - newest) > MAX_AGE_SECONDS


def archive_images(directory: Path):
    """Move all current images to the archive subdirectory."""
    archive_dir = directory / "archive"
    archive_dir.mkdir(parents=True, exist_ok=True)
    for img in get_existing_images(directory):
        img.rename(archive_dir / img.name)


def fetch_new_image(directory: Path, resolution: str) -> Path | None:
    """Fetch a new spotlight image and return its path."""
    directory.mkdir(parents=True, exist_ok=True)

    data = fetch_spotlight_data(resolution)
    images = extract_image_info(data)

    # Filter to landscape only
    landscapes = [img for img in images if img["orientation"] == "landscape"]
    if not landscapes:
        return None

    random.shuffle(landscapes)

    for img in landscapes:
        title = sanitize_filename(img["title"])
        img_hash = get_image_hash(img["url"])
        filename = f"{title}_l_{img_hash}.jpg"
        output_path = directory / filename

        if output_path.exists():
            return output_path

        if download_image(img["url"], output_path):
            return output_path

    return None


def get_monitor_count() -> int:
    """Detect the number of connected monitors via xrandr."""
    result = subprocess.run(
        ["xrandr", "--query"],
        capture_output=True, text=True, check=True,
    )
    return sum(1 for line in result.stdout.splitlines() if " connected" in line)


def set_backgrounds(image_paths: list[Path]):
    """Set X11 backgrounds using feh, one image per monitor."""
    subprocess.run(["feh", "--bg-scale"] + [str(p) for p in image_paths], check=True)


def pick_images(directory: Path, resolution: str, count: int, fetch: bool) -> list[Path]:
    """Pick `count` distinct images, fetching if needed."""
    images = []

    if fetch:
        for _ in range(count):
            img = fetch_new_image(directory, resolution)
            if img and img not in images:
                images.append(img)

    if len(images) < count:
        existing = get_existing_images(directory)
        random.shuffle(existing)
        for img in existing:
            if img not in images:
                images.append(img)
            if len(images) >= count:
                break

    # Still not enough — fetch more
    while len(images) < count:
        img = fetch_new_image(directory, resolution)
        if not img:
            break
        if img not in images:
            images.append(img)

    return images


def main():
    parser = argparse.ArgumentParser(description="Set X11 background to a Spotlight wallpaper")
    parser.add_argument(
        "-d", "--directory",
        type=Path,
        default=DEFAULT_DIR,
        help=f"Spotlight image directory (default: {DEFAULT_DIR})",
    )
    parser.add_argument(
        "-r", "--resolution",
        default="3840x2160",
        help="Screen resolution (default: 3840x2160)",
    )
    parser.add_argument(
        "--fetch", action="store_true",
        help="Fetch new images before selecting",
    )

    args = parser.parse_args()

    monitor_count = get_monitor_count()
    if monitor_count < 1:
        print("No connected monitors detected.", file=sys.stderr)
        sys.exit(1)

    fetch = args.fetch
    if images_are_stale(args.directory):
        archive_images(args.directory)
        fetch = True

    images = pick_images(args.directory, args.resolution, monitor_count, fetch)

    if not images:
        print("No images available.", file=sys.stderr)
        sys.exit(1)

    set_backgrounds(images)
    for img in images:
        print(img.name)


if __name__ == "__main__":
    main()
