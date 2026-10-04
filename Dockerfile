FROM python:3.14-alpine

COPY --from=ghcr.io/astral-sh/uv:0.12.23 /uv /uvx /bin/

RUN apk add --no-cache bash curl dcron supervisor tzdata

ENV TZ=Madrid/Europe

WORKDIR /usr/src/app

COPY pyproject.toml uv.lock ./

RUN uv export --locked --no-dev --no-default-groups --no-emit-project \
        --no-header --no-annotate --format requirements.txt \
        --output-file /tmp/requirements.txt \
    && if [ -s /tmp/requirements.txt ]; then uv pip sync --system /tmp/requirements.txt; fi \
    && rm /tmp/requirements.txt

COPY app/ /usr/src/app/

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN touch /var/log/cron.log

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]