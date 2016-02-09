#!/bin/sh

#
# Users and Groups
# it is best to run the various daemons with separate accounts
#

# User which will own the HDFS services.
HDFS_USER=vagrant

# User which will own the YARN services.
YARN_USER=vagrant

# User which will own the MapReduce services.
MAPRED_USER=vagrant

# A common group shared by services.
HADOOP_GROUP=hadoop

# For Ubuntu
echo "Create group hadoop"
sudo groupadd $HADOOP_GROUP

#######################################################################
echo "Create user hdfs"
#sudo useradd -G $HADOOP_GROUP $HDFS_USER
echo "Create hdfs user home dir"
#sudo mkdir -p /home/hdfs
#sudo chmod -R 700 /home/hdfs
#sudo chown -R vagrant:hadoop /home/hdfs
cat << EOF | sudo -u vagrant ssh-keygen


EOF
sudo -u vagrant sh -c "cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys"
sudo chmod g+r /home/vagrant/.ssh/authorized_keys

sudo -u vagrant ssh-keyscan -t rsa 0.0.0.0 > /home/vagrant/.ssh/known_hosts
sudo -u vagrant ssh-keyscan -t rsa 127.0.0.1 >> /home/vagrant/.ssh/known_hosts
sudo -u vagrant ssh-keyscan -t rsa localhost >> /home/vagrant/.ssh/known_hosts


