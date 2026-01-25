# CLAUDE.md - AI Assistant Guide for docker-smokeping

## Project Overview

This repository contains the **LinuxServer.io Docker image for Smokeping**, a network latency monitoring and graphing application. Smokeping tracks network latency for various hosts and presents data visually through a web interface.

- **Application**: [Smokeping](http://oss.oetiker.ch/smokeping/)
- **Maintainer**: LinuxServer.io
- **Docker Hub**: [linuxserver/smokeping](https://hub.docker.com/r/linuxserver/smokeping/)
- **Base Image**: `lsiobase/alpine:3.6`

## Repository Structure

```
docker-smokeping/
├── Dockerfile                    # Container image definition
├── README.md                     # User documentation
├── CLAUDE.md                     # This file - AI assistant guide
├── .github/
│   ├── ISSUE_TEMPLATE.md         # Issue reporting template
│   └── PULL_REQUEST_TEMPLATE.md  # PR submission guidelines
└── root/                         # Files copied into container at build
    ├── defaults/
    │   ├── smokeping.conf        # Default Apache site configuration
    │   └── smoke-conf/           # Default Smokeping application configs
    │       ├── Alerts            # Alert configuration for packet loss
    │       ├── Database          # RRD database settings
    │       ├── General           # Owner, contact, CGI URL settings
    │       ├── Presentation      # Web UI templates and charts
    │       ├── Probes            # Probe definitions (FPing)
    │       ├── Slaves            # Distributed slave probe settings
    │       ├── Targets           # Hosts/URLs to monitor
    │       ├── pathnames         # File path configuration
    │       └── smtp.conf         # SSMTP/sendmail configuration
    └── etc/
        ├── apache2/httpd.conf    # Apache web server configuration
        ├── smokeping/config      # Main config (includes from /config)
        ├── cont-init.d/
        │   └── 30-config         # Container initialization script
        └── services.d/
            ├── apache/run        # Apache service supervisor script
            └── smokeping/run     # Smokeping daemon supervisor script
```

## Key Architecture Concepts

### Container Runtime Flow

1. **Initialization** (`root/etc/cont-init.d/30-config`):
   - Creates required directories (`/config/site-confs`, `/run/apache2`, `/var/cache/smokeping`)
   - Copies default configs from `/defaults/smoke-conf/` to `/config/` (first run only)
   - Creates symlinks for web application and cache
   - Sets permissions for `abc` user

2. **Service Management** (s6 overlay):
   - **Apache**: Serves web UI on port 80 with CGI support
   - **Smokeping**: Runs as daemon under `abc` user

### LinuxServer.io Conventions

- **User `abc`**: Standard unprivileged user for running services
- **PUID/PGID**: Environment variables for host permission mapping
- **Volume separation**: `/config` for configuration, `/data` for persistent data
- **First-run defaults**: Configs copied only if not present (preserves customizations)

## Dockerfile Anatomy

```dockerfile
FROM lsiobase/alpine:3.6              # Alpine base with s6 overlay

# Packages: apache2, smokeping, ssmtp, curl, sudo, ttf-dejavu
# Special: abc user gets sudo access to traceroute
# Fix: cropper.js path correction in basepage.html

COPY root/ /                          # Copy all configs and scripts
EXPOSE 80                             # Web UI port
VOLUME /config /data                  # Persistent storage
```

## Development Guidelines

### Making Changes

1. **Dockerfile changes**: Keep minimal, consolidate RUN layers
2. **Default configs** (`root/defaults/`): Update for new features
3. **Init scripts** (`root/etc/cont-init.d/`): Use `#!/usr/bin/with-contenv bash`
4. **Service scripts** (`root/etc/services.d/`): Run with `exec` for proper signal handling

### Testing Locally

```bash
# Build the image
docker build -t smokeping-test .

# Run for testing
docker run -d \
  --name smokeping-test \
  -p 8080:80 \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  -e TZ=America/New_York \
  -v $(pwd)/test-config:/config \
  -v $(pwd)/test-data:/data \
  smokeping-test

# Access at http://localhost:8080/smokeping/smokeping.cgi
```

### Configuration Files

| File | Purpose | User Editable |
|------|---------|---------------|
| `/config/Targets` | Hosts to monitor | Yes |
| `/config/General` | Owner, contact info | Yes |
| `/config/Alerts` | Alert rules | Yes |
| `/config/Database` | RRD settings | Yes |
| `/config/Presentation` | Web UI theming | Yes |
| `/config/Probes` | Probe binaries | Rarely |
| `/config/site-confs/smokeping.conf` | Apache config | Advanced |

### Image Tags

- **`latest`**: Standard version with IPv6 support
- **`unraid`**: IPv6-disabled variant for older Unraid (pre-6.3x)

## Code Conventions

### Shell Scripts

- Use `#!/usr/bin/with-contenv bash` for s6 environment access
- Service scripts must use `exec` to replace shell process
- Check for existence before creating files/symlinks: `[[ ! -e path ]] && ...`

### Git Workflow

- Create feature branches for changes
- Reference issues in PR descriptions: `closes #<issue number>`
- Follow LinuxServer.io commit message style (lowercase, concise)

### Commit History Patterns

Recent commits show:
- Base image updates: "Rebase to alpine X.X"
- Feature additions: "Add <package> for <reason>"
- Bug fixes: "Fix <issue>, thanks <contributor>"
- Documentation: "Update README"

## Important Paths (Inside Container)

| Path | Purpose |
|------|---------|
| `/config` | User configuration (mounted volume) |
| `/data` | RRD databases and graphs (mounted volume) |
| `/etc/smokeping/config` | Main config that includes from /config |
| `/usr/share/webapps/smokeping` | Web application files |
| `/var/cache/smokeping` | Smokeping cache directory |
| `/var/www/localhost/smokeping` | Symlink to web app |

## Environment Variables

| Variable | Purpose | Example |
|----------|---------|---------|
| `PUID` | User ID for file ownership | `1000` |
| `PGID` | Group ID for file ownership | `1000` |
| `TZ` | Timezone | `Europe/London` |

## Troubleshooting

### Common Issues

1. **Permission errors**: Check PUID/PGID match host user owning volumes
2. **IPv6 failures**: Use `:unraid` tag on hosts without IPv6
3. **Config not loading**: Ensure config files exist in `/config/`
4. **Graphs not generating**: Wait 10+ minutes, check `/data` permissions

### Debugging Commands

```bash
# View container logs
docker logs -f smokeping

# Shell into running container
docker exec -it smokeping /bin/bash

# Check version
docker inspect -f '{{ index .Config.Labels "build_version" }}' smokeping
```

## CI/CD

- Builds handled by LinuxServer.io CI pipeline
- Images tagged with `build_version` label containing version and build date
- Published to Docker Hub automatically

## Contributing

1. Fork the repository
2. Create a feature branch (not from master)
3. Make changes following conventions above
4. Submit PR referencing any related issues
5. Include links to patches/files used in PR description
