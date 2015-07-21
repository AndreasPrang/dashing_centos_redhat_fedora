FROM centos
MAINTAINER Andreas W. Prang Andras.Prang@bild.de

# install Dashing
# - setup requirements
RUN yum update -y
RUN yum install -y gcc gcc-c++ patch readline readline-devel zlib zlib-devel
RUN yum install -y libyaml-devel libffi-devel openssl-devel make
RUN yum install -y bzip2 autoconf automake libtool bison iconv-devel
RUN yum install -y ruby-devel

# - install ruby version manager
# RUN command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
# RUN curl -L http://get.rvm.io | bash -s stable
# RUN source /etc/profile.d/rvm.sh
# RUN /etc/profile.d/rvm.sh install 1.9.3
# RUN /etc/profile.d/rvm.sh 1.9.3 --default
RUN yum install -y rubygems

# - setup dashing
RUN gem install dashing
RUN mkdir -p /opt/dashing
RUN cd /opt/dashing && dashing new monitor
RUN gem uninstall -aIx eventmachine
RUN gem install bundle
RUN cd /opt/dashing/monitor && bundle install

RUN cd /opt/dashing/monitor && bundle

RUN cd /usr/local/share/gems*/gems/thin-*/lib && ln -s ../ext/thin_parser/thin_parser.so .
RUN gem install therubyracer
RUN echo "" >> /opt/dashing/monitor/Gemfile
RUN echo "gem 'execjs'" >> /opt/dashing/monitor/Gemfile
RUN echo "gem 'therubyracer', :platforms => :ruby" >> /opt/dashing/monitor/Gemfile

EXPOSE 3030

CMD cd /opt/dashing/monitor && exec 2>&1 && exec dashing start
