# Shrewdeye Bash CLI 🚀

![Shrewdeye](/assets/shrewdeye.gif)

## What is Shrewdeye Bash?

Shrewdeye Bash is a bash wrapper of [Shrewdeye](https://shrewdeye.app/) designed to streamline the subdomain enumeration process for security researchers. Their services are highly effective, providing you with accurate and quick results for testing purposes.

📢 We'd love to hear from you! For updates and discussion follow us on Twitter/X:[@ArmanSameer95](https://twitter.com/ArmanSameer95) & [@drunkrhin0](https://twitter.com/drunkrhin0)

Help us make Shrewdeye-bash even better and submit a PR!🌐

Enjoy streamlined subdomain enumeration!

## Usage

On a Linux host:

1. Clone this repo: `git clone https://github.com/tess-ss/shrewdeye-bash.git`
2. Navigate to the folder: `cd shrewdeye-bash`
3. Make the script executable: `chmod +x shrewdeye.sh`
4. Execute the script with your chosen options `./shrewdeye.sh -d www.website.com`

### Options

```bash
Usage: shrewdeye.sh [OPTIONS]
Options:
  -d, --domain    Specify a single domain to process
  -l, --list      Specify a space-separated list of domains to process
  -f, --file      Specify a text file containing a list of domains to process (One domain per line)
  -h, --help      Show this help message and exit
```
