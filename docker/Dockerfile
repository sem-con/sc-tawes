FROM semcon/sc-base
MAINTAINER "Christoph Fabianek" christoph@ownyourdata.eu

WORKDIR /usr/src/app
COPY . .
RUN bundle install && \
	rake db:migrate

CMD ["./script/run.sh"]

EXPOSE 3000