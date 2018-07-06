FROM ruby:2.5.1-slim

# Instalando dependencias
RUN apt-get update && apt-get install -qq -y --no-install-recommends \
    build-essential libpq-dev

# Setando o path
ENV INSTALL_PATH /app

# Criando diretorio
RUN mkdir -p $INSTALL_PATH

# Setando o nosso path como diretorio principal
WORKDIR $INSTALL_PATH

# Copiando o Gemfile
COPY Gemfile ./

# Instalando as Gems
RUN bundle install

# Copiando o codigo para o container
COPY . .

# Rodando o servidor
CMD ["rackup", "config.ru", "-o", "0.0.0.0"]