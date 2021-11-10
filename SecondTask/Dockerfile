FROM ruby
RUN apt-get update -qq \
&& apt-get install -y nodejs postgresql
ADD . /SecondTask
WORKDIR /SecondTask
RUN bundle install
EXPOSE 3000
CMD ["bash"]