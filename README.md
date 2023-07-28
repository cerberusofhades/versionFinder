# versionFinder

The `versionFinder.sh` script is a simple tool that compares the local version of a file with versions hosted on a GitHub repository. It does this by computing the MD5 checksums of the local file and each version of the file in the repository, and reports whether they match. This can be useful in situations where you want to determine which version of a file you have locally.

## Usage

```
Usage: ./versionFinder.sh <local_file> <repo_name> [-r]
```

- `local_file`: The path to the local file that you want to compare. 
- `repo_name`: The name of the GitHub repository in the format `username/repository`. The script assumes that the file exists in the repository under the path `/lib/<file_name>`.
- `-r`: An optional flag. If included, the script will check versions in reverse order (from newest to oldest).

## Output

The script will output the result of the comparison for each version of the file in the repository. The output will be in the format `Version X.Y.Z => match` if the local file matches that version, or `Version X.Y.Z => not match` if it doesn't. Matched versions will be printed in green, and unmatched versions in red.

If the `-r` flag is used, versions will be checked in reverse order (from newest to oldest).

## Prerequisites

- `git`
- `curl`
- `md5sum`
- `awk`
- `grep`
- `sort`

These utilities must be installed and available in your `PATH`.
