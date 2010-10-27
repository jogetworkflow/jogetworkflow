set JAVA_HOME=C:\Program Files\Java\jdk1.6.0_19
set MAVEN_OPTS= -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,suspend=n,server=y,address=5115
start mvn -e tomcat:run

