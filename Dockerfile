FROM python:3.14-alpine

RUN apk add --no-cache bash curl dcron supervisor tzdata

ENV TZ=Madrid/Europe

WORKDIR /usr/src/app

COPY app/ /usr/src/app/

RUN pip install --no-cache-dir -r requirements.txt

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN touch /var/log/cron.log

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]