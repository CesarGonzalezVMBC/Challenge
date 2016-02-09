#Start all hadoop daemons
export HADOOP_HOME=/opt/hadoop-2.3.0-cdh5.0.1
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver
$HADOOP_HOME/sbin/yarn-daemon.sh start proxyserver

#Show started daemons
jps

#4588 SecondaryNameNode
#4033 NameNode
#3271 Main
#4795 ResourceManager
#5048 NodeManager
#5492 WebAppProxyServer
#5410 JobHistoryServer
#5562 Jps
#4278 DataNode
#3367 RemoteMavenServer
#/opt/hue-3/hue/build/env/bin/supervisor &
