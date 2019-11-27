FROM odoo:12.0


# Run commands as root
USER "root"

RUN apt-get update && apt-get upgrade -y && apt-get install -y  \
    git \
    python3-venv \
    python3-pip \
    sudo \
    && apt-get autoremove -y \
    && apt-get clean \
    && pip3 install pytest-odoo pytest-cov \
    && git clone --single-branch --branch "12.0" https://github.com/OCA/server-tools.git /mnt/odoo/OCA/server-tools \
    && git clone --single-branch --branch "12.0" https://github.com/OCA/web.git /mnt/odoo/OCA/web \
    && git clone --single-branch --branch "12.0" https://github.com/OCA/sale-workflow.git /mnt/odoo/OCA/sale-workflow \
    && git clone --single-branch --branch "12.0" https://github.com/OCA/pos.git /mnt/odoo/OCA/pos \
    && git clone --single-branch --branch "12.0" https://github.com/OCA/partner-contact.git /mnt/odoo/OCA/partner-contact \
    && git clone --single-branch --branch "12.0" https://github.com/OCA/e-commerce.git /mnt/odoo/OCA/e-commerce \
    && git clone --single-branch --branch "12.0" https://github.com/OCA/report-print-send.git /mnt/odoo/OCA/report-print-send \
    && git clone --single-branch --branch "12.0" https://github.com/OCA/project.git /mnt/odoo/OCA/project \
    && git clone --single-branch --branch "12.0" https://github.com/OCA/crm.git /mnt/odoo/OCA/crm \
    && chown odoo: -R /mnt/odoo/OCA

COPY ./run_odoo_tests.sh  /
RUN chmod +x ./run_odoo_tests.sh

