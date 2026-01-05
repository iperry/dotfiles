#!/usr/bin/env python3
"""Download Microsoft Spotlight wallpapers."""

import argparse
import hashlib
import json
import os
import sys
from pathlib import Path
from urllib.request import urlopen, Request
from urllib.error import URLError, HTTPError

SPOTLIGHT_API = "https://arc.msn.com/v3/Delivery/Placement"

DEFAULT_PARAMS = {
    "pid": "338387",
    "fmt": "json",
    "rafb": "0",
    "ua": "WindowsShellClient/0",
    "cdm": "1",
    "disphorzres": "1920",
    "dispvertres": "1080",
    "lo": "80217",
    "pl": "en-US",
    "lc": "en-US",
    "ctry": "US",
}


def build_url(params: dict) -> str:
    """Build the API URL with query parameters."""
    query = "&".join(f"{k}={v}" for k, v in params.items())
    return f"{SPOTLIGHT_API}?{query}"


def fetch_spotlight_data(resolution: str = "1920x1080", locale: str = "en-US") -> dict:
    """Fetch spotlight metadata from Microsoft API."""
    width, height = resolution.split("x")
    params = DEFAULT_PARAMS.copy()
    params.update({
        "disphorzres": width,
        "dispvertres": height,
        "pl": locale,
        "lc": locale,
    })

    url = build_url(params)
    req = Request(url, headers={"User-Agent": "WindowsShellClient/0"})

    try:
        with urlopen(req, timeout=30) as resp:
            return json.loads(resp.read().decode("utf-8"))
    except (URLError, HTTPError) as e:
        print(f"Error fetching spotlight data: {e}", file=sys.stderr)
        sys.exit(1)


def extract_image_info(data: dict) -> list[dict]:
    """Extract image URLs and metadata from API response."""
    images = []

    try:
        batchrsp = data.get("batchrsp", {})
        items = batchrsp.get("items", [])

        for item in items:
            item_str = item.get("item", "")
            if not item_str:
                continue

            item_data = json.loads(item_str)
            ad = item_data.get("ad", {})

            # Get landscape image
            landscape_url = ad.get("image_fullscreen_001_landscape", {}).get("u")
            # Get portrait image
            portrait_url = ad.get("image_fullscreen_001_portrait", {}).get("u")

            title = ad.get("title_text", {}).get("tx", "Unknown")
            desc = ad.get("hs2_title_text", {}).get("tx", "")

            if landscape_url:
                images.append({
                    "url": landscape_url,
                    "title": title,
                    "description": desc,
                    "orientation": "landscape",
                })

            if portrait_url:
                images.append({
                    "url": portrait_url,
                    "title": title,
                    "description": desc,
                    "orientation": "portrait",
                })

    except (KeyError, json.JSONDecodeError) as e:
        print(f"Error parsing response: {e}", file=sys.stderr)

    return images


def download_image(url: str, output_path: Path) -> bool:
    """Download an image from URL to the specified path."""
    req = Request(url, headers={"User-Agent": "WindowsShellClient/0"})

    try:
        with urlopen(req, timeout=60) as resp:
            content = resp.read()
            output_path.write_bytes(content)
            return True
    except (URLError, HTTPError) as e:
        print(f"Error downloading {url}: {e}", file=sys.stderr)
        return False


def get_image_hash(url: str) -> str:
    """Generate a short hash from the image URL for unique naming."""
    return hashlib.md5(url.encode()).hexdigest()[:8]


def sanitize_filename(name: str) -> str:
    """Sanitize a string for use as a filename."""
    invalid_chars = '<>:"/\\|?*'
    for char in invalid_chars:
        name = name.replace(char, "_")
    return name.strip()[:100]


def main():
    parser = argparse.ArgumentParser(
        description="Download Microsoft Spotlight wallpapers"
    )
    parser.add_argument(
        "-o", "--output",
        type=Path,
        default=Path.cwd() / "spotlight",
        help="Output directory (default: ./spotlight)",
    )
    parser.add_argument(
        "-r", "--resolution",
        default="3840x2160",
        help="Screen resolution (default: 3840x2160)",
    )
    parser.add_argument(
        "-l", "--locale",
        default="en-US",
        help="Locale for images (default: en-US)",
    )
    parser.add_argument(
        "-n", "--count",
        type=int,
        default=10,
        help="Number of API requests to make (default: 10)",
    )
    parser.add_argument(
        "--portrait",
        action="store_true",
        help="Include portrait images (default: landscape only)",
    )
    parser.add_argument(
        "--portrait-only",
        action="store_true",
        help="Only download portrait images",
    )

    args = parser.parse_args()

    # Create output directory
    args.output.mkdir(parents=True, exist_ok=True)

    seen_urls = set()
    downloaded = 0

    print(f"Fetching Spotlight wallpapers...")
    print(f"Resolution: {args.resolution}")
    print(f"Output: {args.output}")
    print()

    for i in range(args.count):
        print(f"Request {i + 1}/{args.count}...", end=" ", flush=True)

        data = fetch_spotlight_data(args.resolution, args.locale)
        images = extract_image_info(data)

        new_count = 0
        for img in images:
            url = img["url"]

            if url in seen_urls:
                continue
            seen_urls.add(url)

            # Filter by orientation (default: landscape only)
            if args.portrait_only and img["orientation"] != "portrait":
                continue
            if not args.portrait and not args.portrait_only:
                if img["orientation"] != "landscape":
                    continue

            # Build filename
            title = sanitize_filename(img["title"])
            img_hash = get_image_hash(url)
            orientation = img["orientation"][0]  # 'l' or 'p'
            filename = f"{title}_{orientation}_{img_hash}.jpg"
            output_path = args.output / filename

            if output_path.exists():
                continue

            if download_image(url, output_path):
                downloaded += 1
                new_count += 1

        print(f"found {new_count} new image(s)")

    print()
    print(f"Downloaded {downloaded} new wallpaper(s) to {args.output}")


if __name__ == "__main__":
    main()
