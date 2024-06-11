#!/bin/bash
apt install software-properties-common
add-apt-repository ppa:ondrej/php
apt install bind9 
apt install apache2 mariadb-server libapache2-mod-php7.4 
apt install php7.4-gd php7.4-mysql php7.4-curl php7.4-mbstring php7.4-intl php7.4-xml php7.4-zip 
mysql_secure_installation

echo -e "\$TTL\t604800\n@\tIN\tSOA\tns1.andrvsh.org. root.andrvsh.org. (\n\t\t\t\t3\t; serial\n\t\t\t\t604800\t\t; refresh\n\t\t\t\t86400 )\t\t; retry\n\t\t\t\t2419200\t\t; expire\n\t\t\t\t604800\t\t; Negative Cache TTL\n\n@\tIN\tNS\tns1.andrvsh.org.\nns1\tIN\tA\t192.168.100.1" >/etc/bind/db.andrvsh.org
echo -e 'zone "andrvsh.org" {\n\ttype master;\n\tfile "/etc/bind/db.andrvsh.org";\n};' >> /etc/bind/named.conf.local

MYSQL_ROOT_PASS="toor"

# Создание базы данных и пользователя
mysql -u root -p$MYSQL_ROOT_PASS <<EOF
CREATE DATABASE nextcloud;
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'toor';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'admin'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF

echo "База данных и пользователь для Nextcloud успешно созданы."

cd /tmp
wget https://download.nextcloud.com/server/releases/nextcloud-23.0.0.zip
unzip nextcloud-23.0.0.zip
sudo mv nextcloud /var/www/

sudo chown -R www-data:www-data /var/www/nextcloud/
sudo chmod -R 755 /var/www/nextcloud/

cp /home/andr/next/mysql /etc/apache2/sites-available/nextcloud.conf

sudo a2ensite nextcloud.conf
sudo a2enmod rewrite headers env dir mime
sudo systemctl restart apache2



a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime