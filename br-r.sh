#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install apache2 mariadb-server libapache2-mod-php7.4
sudo apt install php7.4-gd php7.4-json php7.4-mysql php7.4-curl php7.4-mbstring php7.4-intl php7.4-xml php7.4-zip -y
sudo mysql_secure_installation


DB_NAME="nextcloud"
DB_USER="nextclouduser"
DB_PASS="password"
MYSQL_ROOT_PASS="your_mysql_root_password"

# Создание базы данных и пользователя
mysql -u root -p$MYSQL_ROOT_PASS <<EOF
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF

echo "База данных и пользователь для Nextcloud успешно созданы."


cd /tmp
wget https://download.nextcloud.com/server/releases/nextcloud-23.0.0.zip
unzip nextcloud-23.0.0.zip
sudo mv nextcloud /var/www/html/

sudo chown -R www-data:www-data /var/www/html/nextcloud/
sudo chmod -R 755 /var/www/html/nextcloud/

cp /home/andr/next/mysql /etc/apache2/sites-available/nextcloud.conf

sudo a2ensite nextcloud.conf
sudo a2enmod rewrite headers env dir mime
sudo systemctl restart apache2