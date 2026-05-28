Here is a highly professional, technically precise `README.md` for your **FCK-FIPS Buildpacks** (`fckfips-cnb`) project. It accurately describes what was custom-built, what relies on Paketo, the FIPS cryptographic integration, and all the variables used.

***

# FCK-FIPS Buildpacks (`fckfips-cnb`)

High-Assurance, FIPS 140-3 Compliant Node.js Cloud Native Buildpacks on Wolfi OS.

This project provides a secure, production-hardened containerization pipeline for Node.js applications. It combines a custom Wolfi-based Node.js engine with FIPS 140-3 validated cryptography and Paketo's structural lifecycle buildpacks.

---

## Architectural Layout

The ecosystem is built on a split responsibility model:

```
[ Your Application ]
       │
       ▼ (Packaged by)
[ fckfips/nodejs ] (Meta-Buildpack / API 0.10)
       │
       ├─► [ fckfips/wolfi-node-engine ] (Custom Node FIPS Engine)
       │
       └─► [ paketo-buildpacks/* ] (Ecosystem Lifecycles / Sourced from GHCR)
```

### 1. Custom Components (Built by Us)
*   **`fckfips/wolfi-node-engine` (API 0.10):** A custom, lightweight buildpack that dynamically fetches Node.js (minimal/full), npm, and yarn packages directly from the secure Wolfi OS APK repository. It embeds custom memory optimization and debugger hooks.
*   **Custom Stack Base Images (`io.fckfips.stacks.wolfi`):**
    *   **Build Image (`wolfi-build-base`):** Features the Python compilers, PyInstaller, and development headers required to compile the custom buildpack engine.
    *   **Run Image (`wolfi-run-base`):** A minimalist, highly secure runtime environment stripped of development dependencies, shells, and compilers.

### 2. Ecosystem Components (Paketo Integration)
*   **`fckfips/nodejs` (Meta-Buildpack / API 0.10):** A composite buildpack that defines the order groups. It bundles our custom Wolfi engine with official Paketo buildpacks (such as `ca-certificates`, `watchexec`, `npm-install`, `node-start`, and `procfile`).
*   **Multi-Arch GHCR Migration:** All external Paketo dependencies are explicitly declared using their modern, multi-architecture (`amd64`/`arm64`) releases pulled from the official GitHub Container Registry (`ghcr.io/paketo-buildpacks`).

---

## Cryptographic Foundation (FIPS 140-3)

The underlying cryptographic strength of both the build and runtime environments is powered by:

👉 **[taha2samy/openssl_fips](https://github.com/taha2samy/openssl_fips)**

This community-tested, hardened foundation provides:
*   A production-ready OpenSSL 3.x environment compiled specifically for Wolfi.
*   Strict FIPS 140-3 boundary validation using automated POST (Power-On Self-Tests) and KAT (Known Answer Tests).
*   Automatic module mapping via `/usr/lib/ossl-modules/fips.so` linked natively into the system directories.

---

## Configuration Variables

### Build-Time Variables
These variables are passed during the `pack build` process:

| Variable | Default | Description |
|---|---|---|
| `BP_NODE_VERSION` | `20` | Determines the major version of Node.js fetched from Wolfi (e.g., `22`). |
| `BP_NODE_OPTIMIZE_MEMORY` | `false` | When set to `true`, enables the custom memory-optimizer script. |
| `NODE_ENV` | `development` | Setting this to `production` instructs the lifecycle to prune development dependencies. |

### Runtime Variables
These variables control the execution environment of the running container:

| Variable | Value / Example | Description |
|---|---|---|
| `NODE_OPTIONS` | `--enable-fips` | Instructs the V8 engine to strictly enforce OpenSSL FIPS-compliant cryptography. |
| `OPTIMIZE_MEMORY` | `true` | Triggers the `0-optimize-memory` helper to auto-configure maximum old space size. |
| `MEMORY_AVAILABLE` | `512` | Manually overrides the memory limit parsed from cgroups (in MB). |

