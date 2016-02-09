#Start all hadoop daemons
export HADOOP_HOME=/opt/hadoop-2.3.0-cdh5.0.1
$HADOOP_HOME/sbin/stop-dfs.sh
$HADOOP_HOME/sbin/stop-yarn.sh
$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh stop historyserver
$HADOOP_HOME/sbin/yarn-daemon.sh stop proxyserver

#Show daemons
$JAVA_HOME/bin/jps
