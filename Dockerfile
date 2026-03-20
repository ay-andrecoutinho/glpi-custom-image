FROM glpi/glpi:latest

USER root

# NUCLEAR FIX: Remove MPM .so binaries so they can NEVER be loaded
# Even if symlinks get recreated at runtime, Apache can't load deleted modules
RUN rm -f /usr/lib/apache2/modules/mod_mpm_event.so \
         /usr/lib/apache2/modules/mod_mpm_worker.so \
    && rm -f /etc/apache2/mods-enabled/mpm_event.* \
             /etc/apache2/mods-enabled/mpm_worker.* \
             /etc/apache2/mods-available/mpm_event.* \
             /etc/apache2/mods-available/mpm_worker.* \
    && ln -sf /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load \
    && (ln -sf /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf 2>/dev/null || true)

# Pre-create /var/glpi with correct ownership
RUN mkdir -p /var/glpi && chown -R www-data:www-data /var/glpi

# Copy and enable the wrapper
COPY entrypoint-wrapper.sh /railway-entrypoint.sh
RUN chmod +x /railway-entrypoint.sh

ENTRYPOINT ["/railway-entrypoint.sh"]
