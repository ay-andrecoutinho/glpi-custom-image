#!/bin/bash
set -e

# --- Fix 1: Railway MPM conflict ---
# Remove ALL MPM modules and re-enable only prefork
rm -f /etc/apache2/mods-enabled/mpm_event.load \
      /etc/apache2/mods-enabled/mpm_event.conf \
      /etc/apache2/mods-enabled/mpm_worker.load \
      /etc/apache2/mods-enabled/mpm_worker.conf \
      /etc/apache2/mods-enabled/mpm_prefork.load \
      /etc/apache2/mods-enabled/mpm_prefork.conf

ln -sf /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load
ln -sf /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf 2>/dev/null || true

# --- Fix 2: Volume permissions ---
# Ensure /var/glpi exists and is owned by www-data
mkdir -p /var/glpi
chown -R www-data:www-data /var/glpi

# --- Delegate to original entrypoint ---
exec /entrypoint.sh "$@"
