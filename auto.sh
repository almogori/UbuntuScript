
if [ $# != 2 ]; then
	echo "Usage: sudo bash auto.sh <Your home IP> <Your username>"
	echo "The IP addresses are used to configure MongoDB."
	echo "The username will be created with sudo privileges."
	echo ""
	exit 1
fi

adduser $2
usermod -aG sudo $2
echo "User $2 has been created and added to the sudo group"

echo "Installing Node..."
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash - > /dev/null 2>&1
sudo apt-get install nodejs -y > /dev/null 2>&1

echo "Installing Nginx..."
sudo apt-get install nginx -y > /dev/null 2>&1

echo "Adding MongoDB repositories..."
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5 > /dev/null 2>&1
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list > /dev/null 2>&1

echo "Updating Ubuntu..."
sudo apt-get update > /dev/null 2>&1
sudo apt-get upgrade -y > /dev/null 2>&1
sudo apt-get autoremove -y > /dev/null 2>&1
sudo apt-get autoclean -y > /dev/null 2>&1

echo "Installing MongoDB..."
sudo apt-get install -y mongodb-org > /dev/null 2>&1
sudo systemctl start mongod > /dev/null 2>&1
sudo systemctl enable mongod > /dev/null 2>&1

echo "Installing PM2..."
sudo npm install -g pm2 > /dev/null 2>&1
pm2 startup | tail -1 > pm2start
sudo bash pm2start > /dev/null 2>&1
rm -f pm2start > /dev/null 2>&1

echo "Configuring UFW..."
sudo ufw allow from $1 to any port 27017 > /dev/null 2>&1
sudo ufw allow OpenSSH > /dev/null 2>&1
sudo ufw allow 'Nginx Full' > /dev/null 2>&1

echo Press "Y" and then "Enter" at the following prompt:
sudo ufw enable
sudo service nginx restart > /dev/null 2>&1

echo "Cleaning up..."
sudo apt-get update > /dev/null 2>&1
sudo apt-get upgrade -y > /dev/null 2>&1
sudo apt-get autoremove -y > /dev/null 2>&1
sudo apt-get autoclean -y > /dev/null 2>&1

echo ""
echo ""
echo ""
echo ""
echo ""
echo "Installation complete."
echo node `node -v`
echo PM2 `pm2 -V`
echo npm `npm -v`
nginx -v
mongo --version | head -1
mongod --version | head -1
pm2 status
sudo systemctl status mongod
echo Firewall
sudo ufw status