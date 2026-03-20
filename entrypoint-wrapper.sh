#!/bin/bash
set -e

echo "[railway-wrapper] Fixing Apache MPM..."
rm -f /etc/apache2/mods-enabled/mpm_event.load \
      /etc/apache2/mods-enabled/mpm_event.conf \
      /etc/apache2/mods-enabled/mpm_worker.load \
      /etc/apache2/mods-enabled/mpm_worker.conf \
      /etc/apache2/mods-enabled/mpm_prefork.load \
      /etc/apache2/mods-enabled/mpm_prefork.conf

ln -sf /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load
ln -sf /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf 2>/dev/null || true
echo "[railway-wrapper] MPM fixed: only prefork enabled"

echo "[railway-wrapper] Fixing volume permissions..."
mkdir -p /var/glpi
chown -R www-data:www-data /var/glpi
echo "[railway-wrapper] Permissions fixed"

# Find and call the ORIGINAL entrypoint
# The official glpi/glpi image uses /entrypoint.sh or /docker-entrypoint.sh
if [ -f /docker-entrypoint.sh ]; then
    echo "[railway-wrapper] Delegating to /docker-entrypoint.sh"
    exec /docker-entrypoint.sh "$@"
elif [ -f /entrypoint.sh ]; then
    echo "[railway-wrapper] Delegating to /entrypoint.sh"
    exec /entrypoint.sh "$@"
elif [ -f /usr/local/bin/entrypoint.sh ]; then
    echo "[railway-wrapper] Delegating to /usr/local/bin/entrypoint.sh"
    exec /usr/local/bin/entrypoint.sh "$@"
else
    echo "[railway-wrapper] No entrypoint found, starting supervisord directly"
    exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
fi
