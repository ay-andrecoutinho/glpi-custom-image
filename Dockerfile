FROM glpi/glpi:latest

USER root

# Fix Railway MPM conflict — physically remove conflicting modules
# so they can't be re-enabled at runtime
RUN rm -f /etc/apache2/mods-enabled/mpm_event.load \
         /etc/apache2/mods-enabled/mpm_event.conf \
         /etc/apache2/mods-enabled/mpm_worker.load \
         /etc/apache2/mods-enabled/mpm_worker.conf \
    && a2enmod mpm_prefork 2>/dev/null || true
