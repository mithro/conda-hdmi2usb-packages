FROM travisci/ci-ubuntu-1804:packer-1566551110-e45a2919
RUN apt-get update
RUN apt-get install -qqy git coreutils rubygems ruby-dev
RUN chown travis /var/lib/gems/2.5.0 /usr/local/bin
USER travis
WORKDIR /home/travis/builds
RUN ls ; pwd
RUN git clone https://github.com/travis-ci/travis-build.git
WORKDIR /home/travis/builds/travis-build
RUN gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)"
#RUN gem install travis
#RUN travis && ls -l ~/.travis
RUN mkdir -p ~/.travis
RUN ln -s `pwd` ~/.travis/travis-build
RUN bundle install
RUN bundler add travis
RUN bundler binstubs travis
RUN ls -l ~/.travis/travis-build/bin/travis
RUN ~/.travis/travis-build/bin/travis compile --help
ENV PATH "/home/travis/.travis/travis-build/bin:$PATH"
RUN which travis
RUN travis compile --help
RUN travis compile
RUN cat /etc/passwd | grep travis
RUN id -u -r
WORKDIR /workspace
