# set same java home for all users
JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64" # get java home from current user's environment
sudo mkdir /opt/jdk1.7.0_15
sudo cp -R /usr/lib/jvm/java-7-openjdk-amd64/* /opt/jdk1.7.0_15
echo "Setting Java Home:> $JAVA_HOME"
echo export JAVA_HOME=$JAVA_HOME > /vagrant/users-and-dirs/java2.sh
sudo mv /vagrant/users-and-dirs/java2.sh /etc/profile.d/java.sh
#To make sure JAVA_HOME is defined for this session, source the new script:
source /etc/profile.d/java.sh