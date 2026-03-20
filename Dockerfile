FROM glpi/glpi:latest

# Fix Railway MPM conflict
RUN a2dismod mpm_event mpm_worker 2>/dev/null || true \
    && a2enmod mpm_prefork
