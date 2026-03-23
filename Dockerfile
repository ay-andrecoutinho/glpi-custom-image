FROM glpi/glpi:latest

USER root

# Fix Railway MPM conflict
RUN rm -f /usr/lib/apache2/modules/mod_mpm_event.so \
         /usr/lib/apache2/modules/mod_mpm_worker.so \
    && rm -f /etc/apache2/mods-enabled/mpm_event.* \
             /etc/apache2/mods-enabled/mpm_worker.* \
             /etc/apache2/mods-available/mpm_event.* \
             /etc/apache2/mods-available/mpm_worker.* \
    && ln -sf /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load \
    && (ln -sf /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf 2>/dev/null || true)

RUN mkdir -p /var/glpi && chown -R www-data:www-data /var/glpi

# Logos customizados
COPY logo.png /var/www/glpi/public/pics/logo.png
COPY logo-mini.png /var/www/glpi/public/pics/logo-mini.png
RUN chown www-data:www-data /var/www/glpi/public/pics/logo.png /var/www/glpi/public/pics/logo-mini.png

COPY entrypoint-wrapper.sh /railway-entrypoint.sh
RUN chmod +x /railway-entrypoint.sh

ENTRYPOINT ["/railway-entrypoint.sh"]
