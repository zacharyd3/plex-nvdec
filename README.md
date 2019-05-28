# Plex NVDEC Unraid Version

This patch is designed to enable NVDEC functions on Linux installations of Plex Media Server version 1.15.1.791 and later. This is a stopgap patch to enable the feature until Plex officially supports the feature natively.

## Requirements

- Plex Media Server running on Unraid 
- Userscripts isn't needed, but is very helpful
- Plex Media Server must be a least version 1.15.1.791
- You must have a NVIDIA card and drivers installed with support for NVDEC (see https://developer.nvidia.com/video-encode-decode-gpu-support-matrix for a list of supported cards)

## Installation

To install this patch perform the following:
1. Copy this script into a userscripts script
2. *Optional: Setup a cron job to run this script daily, this way if Plex is updated, it will reinstall the patch*
3. *Optional: You may want to rename the directories that both EnableHardwareDecoding.sh and DisableHardwareDecoding.sh use as mine are stored in a Google drive sync on my server, you will need to create the directories yourself before using them.

Normally this patch needs to be run after everytime Plex updates, if you setup the cron job, you wont need to worry about that as the script checks to ensure the file isn't already patched and if it is, it stops the script as to not cause errors.
