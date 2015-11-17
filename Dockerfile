FROM python:3.5-onbuild

ENV DEBIAN_FRONTEND noninteractive

RUN /bin/bash -c "apt-get update && \
                  apt-get install locales unzip -y && \
                  apt-get clean && \
                  wget -q https://github.com/taigaio/taiga-back/archive/master.zip -O master.zip && \
                  unzip master.zip && \
                  mv taiga-back-master /taiga"

COPY docker-settings.py /taiga/settings/local.py
COPY locale.gen /etc/locale.gen

RUN echo "LANG=en_US.UTF-8" > /etc/default/locale
RUN echo "LC_TYPE=en_US.UTF-8" > /etc/default/locale
RUN echo "LC_MESSAGES=POSIX" >> /etc/default/locale
RUN echo "LANGUAGE=en" >> /etc/default/locale

RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

ENV LANG en_US.UTF-8
ENV LC_TYPE en_US.UTF-8
ENV API_NAME localhost

# RUN (cd /taiga && python manage.py collectstatic --noinput)

VOLUME ["/taiga/static","/taiga/media"]

WORKDIR /taiga

EXPOSE 8000

RUN locale -a

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
