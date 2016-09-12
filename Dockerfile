
## 
## General Dev Image
##

# Pre-requirements
RUN mkdir -p /run/lock/subsys

RUN yum install -y libaio 
RUN yum clean all
RUN yum update -y

ADD lib/jdk-8u73-linux-x64.rpm  /tmp/jdk-8u73-linux-x64.rpm
RUN yum localinstall -y  /tmp/jdk-8u73-linux-x64.rpm

ADD lib/scala-2.11.8.rpm /tmp/scala-2.11.8.rpm
RUN yum localinstall -y /tmp/scala-2.11.8.rpm

RUN curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo
RUN yum install sbt -y

RUN yum install epel-release -y
RUN yum clean all
RUN yum update -y

RUN yum install nodejs -y
RUN yum install npm -y

RUN yum install ruby -y
RUN yum install gcc g++ make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel -y -t
RUN yum install rubygems -y

RUN npm install -g grunt-cli
RUN npm install grunt --save-dev

RUN yum install yum-utils bzip2 bzip2-devel wget curl tar -y -t
RUN yum groupinstall "Development Tools" -y -t

RUN npm install bower -g
RUN npm install gulp -g

RUN yum install cmake -y

RUN yum install zlib-devel -y
RUN yum install bzip2-devel -y
RUN yum install openssl-devel -y
RUN yum install ncurses-devel -y
RUN yum install sqlite-devel -y
RUN yum install golang

RUN yum install -y centos-release-SCL
RUN yum install -y python27

RUN yum install mysql -y

RUN yum clean all
RUN yum update -y

RUN yum -y install python-pip

RUN yum install git -y

RUN yum install golang -y

RUN pip install --upgrade setuptools
RUN pip install --upgrade pip

RUN yum install postgresql-server postgresql-contrib

RUN yum clean all
RUN yum update -y

RUN wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
RUN yum install apache-maven -y
RUN yum clean all
RUN yum update -y

RUN postgresql-setup initdb
RUN systemctl start postgresql
RUN systemctl enable postgresql

USER root
WORKDIR /
ADD lib/sudoers /
RUN chown -R root:root sudoers
#RUN groupadd dev
#RUN useradd -g devusr  devusr


RUN yum install sudo -y
RUN yum update -y
RUN yum clean all
RUN cp sudoers /etc/sudoers


# Run the rest of the commands as the ``postgres`` user created by the ``postgres-9.3`` package when it was ``apt-get installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker docker

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/9.3/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]



EXPOSE 9000
EXPOSE 8080
EXPOSE 80

USER root
#CMD git pull devproj
#CMD ./install_xe_docker.sh apply-hotfix alter_21700001
#CMD mysql --user=devusr --password='devpwd' --host=127.0.0.1 < /path/test.sql
#CMD /start.sh
#CMD ["/usr/bin/supervisord"]
















