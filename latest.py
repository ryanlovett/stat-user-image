import requests

# List of packages
packages = [
    "countdown", "fivethirtyeight", "gapminder", "ggrepel", "ggthemes", "gt",
    "infer", "janitor", "kableExtra", "latex2exp", "markdown", "openintro",
    "pagedown", "palmerpenguins", "patchwork", "plotly", "quarto", "reshape2",
    "rsample", "showtext", "swirl", "tidycensus", "tidymodels", "tigris",
    "unvotes", "xaringanthemer", "IRkernel"
]

# R version and OS codename
r_version = "4.4"
os_codename = "noble"

# Base URL for Posit Package Manager
base_url = f"https://packagemanager.posit.co/cran/__linux__/{os_codename}/latest/bin/linux/{r_version}-{os_codename}/contrib/{r_version}/"

def get_package_versions(base_url, packages):
    url = base_url + "PACKAGES"
    response = requests.get(url)
    if response.status_code != 200:
        print("Failed to retrieve package index.")
        return
    content = response.text
    versions = {}
    current_pkg = None
    for line in content.splitlines():
        if line.startswith("Package: "):
            current_pkg = line.split("Package: ")[1].strip()
        elif line.startswith("Version: ") and current_pkg:
            version = line.split("Version: ")[1].strip()
            if current_pkg in packages:
                versions[current_pkg] = version
    for pkg in packages:
        print(f"{pkg:<18} {versions.get(pkg, 'not available as binary for this platform')}")

get_package_versions(base_url, packages)

