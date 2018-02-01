
@echo off

if [ $# != 2 ]; then
	echo "Usage: sudo bash auto.sh <Your home IP> <Server IP>"
	echo "The IP addresses are used to configure MongoDB."
	exit 1
fi

echo "Installing Node..."
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash - > /dev/null
sudo apt-get install nodejs -y > /dev/null

echo "Installing Nginx..."
sudo apt-get install nginx -y > /dev/null

echo "Adding MongoDB repositories..."
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5 > /dev/null
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list > /dev/null

echo "Updating Ubuntu..."
sudo apt-get update > /dev/null
sudo apt-get upgrade -y > /dev/null
sudo apt-get autoremove -y > /dev/null
sudo apt-get autoclean -y > /dev/null

echo "Installing MongoDB..."
sudo apt-get install -y mongodb-org > /dev/null

echo "Configuring MongoDB..."
#sudo cp mongoconf /etc/systemd/system/mongodb.service
#sudo sed -e '24s/$/,'$2'/' /etc/mongod.conf > /etc/temp_file
#sudo cp /etc/temp_file /etc/mongod.conf
#sudo rm /etc/temp_file
sudo systemctl start mongodb
sudo systemctl enable mongodb

echo "Installing PM2..."
sudo npm install -g pm2
pm2 startup | tail -1 > pm2start
sudo bash pm2start
rm -f pm2start
clear

echo "Configuring UFW..."
sudo ufw allow from $1 to any port 27017 > /dev/null
sudo ufw allow OpenSSH > /dev/null
sudo ufw allow 'Nginx Full' > /dev/null

clear
echo Press "Y" and then "Enter" at the following prompt:
sudo ufw enable
sudo service nginx restart > /dev/null

echo "Cleaning up..."
sudo apt-get update > /dev/null
sudo apt-get upgrade -y > /dev/null
sudo apt-get autoremove -y > /dev/null
sudo apt-get autoclean -y > /dev/null

#mkdir website
#mv express website/server.js
#cd website
#sudo npm install express
echo "Installation complete.\n"

echo node `node -v`
git --version
echo PM2 `pm2 -V`
echo npm `npm -v`
nginx -v
echo Firewall
sudo ufw status
#sudo systemctl status mongodb
#sudo pm2 start server.js