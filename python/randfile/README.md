# randfile
---

## Summary
---

This is a Python script that will take the input of any directory path and
provide the absolute path of a random file in that directory.

This can be useful for randomized backgrounds in Sway and i3wm.

## Obtaining The Script
---

On Linux / Unix one useful way to pull the file from this repository is the
following if you don't want to download the full repository. This will ouput the
file to the current directory. If you would like to add this to your personal
scripts directory or something similar. Please specify it's path in the command.

```sh
curl -o randfile https://raw.githubusercontent.com/n3s0/scripts/refs/heads/main/python/randfile/randfile
```

## Setup
---

Move the file into your desired directory after download and make it executable.

```sh
chmod +x randfile
```

## Usage
---

The following command will ingest the files in a directory and output the
absolute path of a random file.

```sh
python3 randfile /directory/path/
```
