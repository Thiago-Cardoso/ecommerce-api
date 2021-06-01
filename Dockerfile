FROM ruby:2.7.1

# install dependencies
RUN apt-get update && apt-get install -qq -y --no-install-recommends \
build-essential curl libpq-dev imagemagick git-all \
git-core zlib1g-dev build-essential libssl-dev libreadline-dev \
libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev \
libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn

# set path
ENV INSTALL_PATH /ecommerce-api
# create directory
RUN mkdir -p $INSTALL_PATH
# set path with principal directory
WORKDIR $INSTALL_PATH
# copy gemfile inside container
COPY Gemfile ./
# set path for gems
ENV BUNDLE_PATH /app-gems
COPY . .