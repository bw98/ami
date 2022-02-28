echo "Start to install dependencies, current time is:"  `date`
sudo yum -y update
cd /home/ec2-user/

# Python dependencies
sudo yum install -y python3
sudo yum install -y python3-pip
sudo yum install -y unzip
unzip webservice.zip
cd /home/ec2-user/webservice
sudo pip3 install -r requirements.txt
cd /home/ec2-user/

# Mysql dependencies
sudo yum install -y mariadb-server
sudo systemctl enable mariadb.service
sudo systemctl start mariadb.service
sudo mysqladmin -u root password 123456
sudo mysql -uroot -p123456 <<EOF
DROP DATABASE IF EXISTS webservice;
CREATE DATABASE webservice;
USE webservice;
DROP TABLE IF EXISTS user;
CREATE TABLE user (
  id char(50) NOT NULL, Constraint pk_User_id PRIMARY KEY (id),  # 待优化, 不应该拿非线性数据如字符串做索引
  first_name char(30) NOT NULL,
  last_name char(30) NOT NULL,
  username char(50) NOT NULL unique,
  password char(100) NOT NULL,
  account_created timestamp NOT NULL,
  account_updated timestamp NOT NULL
) ENGINE=InnoDB default charset=utf8;
EOF

# webservice
sudo cp webservice.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable webservice.service
sudo systemctl start webservice.service
# sudo systemctl stop webservice.service

