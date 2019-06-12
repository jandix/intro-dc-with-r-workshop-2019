# define base image
FROM trestletech/plumber

# install apt dependencies
RUN apt-get update -qq && apt-get install -y \
  python \
  python-pip \
  python-virtualenv

# install r packages
COPY requirements.R requirements.R
RUN Rscript ./requirements.R
RUN rm ./requirements.R

# copy files
COPY server.R server.R
COPY classify_image.R classify_image.R

# open port 9910
EXPOSE 9910

# define entrypoint
ENTRYPOINT ["Rscript", "server.R"]