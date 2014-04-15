# DOCKER-NGINX-MYSQL-RAILS-CENTOS6.4
#
# VERSION       1

FROM centos:6.4

MAINTAINER koudaiii "cs006061@gmail.com"

ENV PATH $PATH:/usr/bin
RUN yum -y update

#Dev tools for all Docker
RUN yum -y install git vim

RUN yum -y install passwd openssh openssh-server openssh-clients sudo


# useradd user,name to koudaiii

RUN useradd koudaiii
RUN passwd -f -u koudaiii
RUN mkdir -p /home/koudaiii/.ssh;chown koudaiii /home/koudaiii/.ssh; chmod 700 /home/koudaiii/.ssh
ADD ./authorized_keys /home/koudaiii/.ssh/authorized_keys
RUN chown koudaiii /home/koudaiii/.ssh/authorized_keys;chmod 600 /home/koudaiii/.ssh/authorized_keys

# setup sudoers
RUN echo "koudaiii ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/koudaiii
RUN chmod 440 /etc/sudoers.d/koudaiii

# setup sshd
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config
RUN rpm -i http://dl.fedoraproject.org/pub/epel/6/x86_64/pwgen-2.06-5.el6.x86_64.rpm

# setup TimeZone
RUN mv /etc/localtime /etc/localtime.org
RUN cp /usr/share/zoneinfo/Japan /etc/localtime

# expose for sshd
EXPOSE 22
 
########################################## Nginx ##############################################


# make sure the package repository is up to date
RUN rpm -i http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
RUN yum install -y nginx

# Setup Nginx
RUN mkdir -p /var/www
RUN mkdir -p /etc/nginx/sites-enabled
ADD ./index.html /var/www/index.html
ADD ./default /etc/nginx/sites-available/default
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
RUN rm /etc/nginx/nginx.conf
ADD ./nginx.conf /etc/nginx/nginx.conf

# Attach volumes.
#VOLUME /var/log/nginx

# Set working directory.
#WORKDIR /etc/nginx

# Expose ports for nginx.
EXPOSE 80

#######################################  Supervisord  ########################################

RUN wget http://peak.telecommunity.com/dist/ez_setup.py;python ez_setup.py;easy_install distribute;
RUN wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py;python get-pip.py;
RUN pip install supervisor

ADD ./supervisord.conf /etc/supervisord.conf


CMD ["/usr/bin/supervisord"]



#######################################  Ruby  ########################################
#for capybara-webkit
ADD qt.repo /etc/yum.repos.d/qt.repo

# Set ruby
ADD set_ruby.sh /root/set_ruby.sh
# Set nvm
ADD set_nvm.sh /root/set_nvm.sh 

RUN chmod +x /root/set_ruby.sh; chmod +x /root/set_nvm.sh 
RUN /bin/sh /root/set_ruby.sh
RUN /bin/sh /root/set_nvm.sh

RUN usermod -G koudaiii,rbenv,nvm koudaiii

#######################################  Deployy  ########################################

ADD deploy.sh /root/deploy.sh
ADD database.yml /root/database.yml
RUN chmod +x /root/deploy.sh;chmod +x /root/database.yml
RUN /bin/sh /root/deploy.sh

#puma run
ADD pumarun /usr/local/bin/pumarun
RUN chmod +x /usr/local/bin/pumarun

CMD ["/usr/local/bin/pumarun"]


#############
# Supervisor
CMD ["/usr/bin/supervisord"]

