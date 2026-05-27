import urllib.request
import gzip
import io
import tarfile

ARCH = "x86_64"
BASE_URL = f"https://packages.wolfi.dev/os/{ARCH}/"
INDEX_URL = f"{BASE_URL}APKINDEX.tar.gz"

def get_nodejs_urls():
    with urllib.request.urlopen(INDEX_URL) as response:
        content = response.read()
    with gzip.GzipFile(fileobj=io.BytesIO(content)) as f:
        with tarfile.open(fileobj=io.BytesIO(f.read())) as tar:
            index_file = tar.extractfile("APKINDEX")
            index_data = index_file.read().decode('utf-8')
    packages = index_data.split('\n\n')
    nodejs_links = []
    for pkg in packages:
        lines = pkg.split('\n')
        name = version = ""
        for line in lines:
            if line.startswith('P:'): name = line[2:]
            if line.startswith('V:'): version = line[2:]
        if name.startswith('nodejs-') and any(char.isdigit() for char in name):
            apk_url = f"{BASE_URL}{name}-{version}.apk"
            nodejs_links.append((name, version, apk_url))
    return nodejs_links

if __name__ == "__main__":
    links = get_nodejs_urls()
    for name, ver, url in sorted(links):
        print(f"{name}|{ver}|{url}")