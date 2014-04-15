#!bin/bash
#source /etc/profile.d/rbenv.sh 
export RBENV_ROOT=/usr/local/rbenv
export PATH=/usr/local/rbenv/bin:$PATH
eval "$(rbenv init -)"

cd /usr ; /usr/bin/mysqld_safe &  > /dev/null

# for deploy
cd /var/www/
git clone https://github.com/koudaiii/twitter-bootswatch-rails-demo.git app

# set database.yml for docker

if [ -f /var/www/app/config/database.yml ]; then
  mv /var/www/app/config/database.yml /var/www/app/config/database.yml.original
fi
cp /root/database.yml /var/www/app/config/database.yml

# deploy

cd /var/www/app
bundle install
bundle exec rake db:create RAILS_ENV=production; bundle exec  rake db:migrate RAILS_ENV=production; bundle exec rake db:seed RAILS_ENV=production;
bundle exec puma -e production -d -b unix:///var/run/app.sock -S /var/run/app.state
