FROM semcon/sc-base
MAINTAINER "Christoph Fabianek" christoph@ownyourdata.eu

WORKDIR /usr/src/app
COPY . .
RUN bundle install

CMD ["./script/run.sh"]

EXPOSE 3000