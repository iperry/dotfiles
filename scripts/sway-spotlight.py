#!/usr/bin/env python3
"""Set random Spotlight wallpapers on each monitor using swaybg."""

import argparse
import random
import shutil
import subprocess
import sys
from pathlib import Path

# Import from spotlight.py
from spotlight import fetch_spotlight_data, extract_image_info, download_image, get_image_hash, sanitize_filename


def kill_existing_swaybg():
    """Kill any running swaybg instances."""
    subprocess.run(["pkill", "-x", "swaybg"], capture_output=True)


def set_wallpaper(output: str, image_path: Path):
    """Start swaybg for a specific output."""
    subprocess.Popen(
        ["swaybg", "-o", output, "-i", str(image_path), "-m", "fill"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


def download_spotlight_images(cache_dir: Path, count: int, resolution: str) -> list[Path]:
    """Download spotlight images, returning paths to downloaded files."""
    cache_dir.mkdir(parents=True, exist_ok=True)

    images = []
    seen_urls = set()
    attempts = 0
    max_attempts = count * 5

    while len(images) < count and attempts < max_attempts:
        attempts += 1
        data = fetch_spotlight_data(resolution)
        img_list = extract_image_info(data)

        for img in img_list:
            if len(images) >= count:
                break

            url = img["url"]
            if url in seen_urls:
                continue
            seen_urls.add(url)

            # Only landscape
            if img["orientation"] != "landscape":
                continue

            title = sanitize_filename(img["title"])
            img_hash = get_image_hash(url)
            filename = f"{title}_l_{img_hash}.jpg"
            output_path = cache_dir / filename

            if not output_path.exists():
                if not download_image(url, output_path):
                    continue

            images.append(output_path)

    return images


def get_cached_images(cache_dir: Path) -> list[Path]:
    """Get list of cached images."""
    if not cache_dir.exists():
        return []
    return list(cache_dir.glob("*.jpg"))


def archive_image(image: Path, archive_dir: Path) -> Path:
    """Copy image to archive directory and remove from cache. Returns archive path."""
    archive_dir.mkdir(parents=True, exist_ok=True)
    dest = archive_dir / image.name
    shutil.copy(str(image), str(dest))
    image.unlink()
    return dest


def main():
    parser = argparse.ArgumentParser(
        description="Set Spotlight wallpapers on monitors using swaybg"
    )
    parser.add_argument(
        "outputs",
        nargs="+",
        help="Output names (e.g., DP-1 HDMI-A-1)",
    )
    parser.add_argument(
        "-c", "--cache",
        type=Path,
        default=Path.home() / ".cache" / "spotlight",
        help="Cache directory for images (default: ~/.cache/spotlight)",
    )
    parser.add_argument(
        "-r", "--resolution",
        default="3840x2160",
        help="Screen resolution (default: 3840x2160)",
    )
    parser.add_argument(
        "-f", "--fresh",
        action="store_true",
        help="Download fresh images instead of using cache",
    )
    parser.add_argument(
        "-n", "--count",
        type=int,
        default=10,
        help="Number of images to download when refreshing cache (default: 10)",
    )

    args = parser.parse_args()
    outputs = args.outputs

    print(f"Setting wallpapers for: {', '.join(outputs)}")

    # Get or download images
    cached = get_cached_images(args.cache)

    if args.fresh or len(cached) == 0:
        print(f"Downloading {args.count} image(s)...")
        download_spotlight_images(args.cache, args.count, args.resolution)
        cached = get_cached_images(args.cache)

    if len(cached) < len(outputs):
        print(f"Error: only {len(cached)} images available for {len(outputs)} outputs", file=sys.stderr)
        sys.exit(1)

    # Select random images for each output
    selected = random.sample(cached, len(outputs))

    # Archive images first, then start swaybg with archived paths
    archive_dir = args.cache / "archive"
    archived = [archive_image(img, archive_dir) for img in selected]

    # Kill existing swaybg and set new wallpapers
    kill_existing_swaybg()

    for output, image in zip(outputs, archived):
        print(f"{output}: {image.name}")
        set_wallpaper(output, image)

    print("Done.")


if __name__ == "__main__":
    main()
