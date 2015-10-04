#!/bin/sh

#  build-tomcat.sh
#  jimiopen-shell-project
#
#  Created by yuanlang on 10/4/15.
#
#################定义变量#######################
instance="tomcat_demo";
tomcat_progrm="/opt/tomcat_demo";
bak_dir="/mnt/bak";
target_home="/home/www";
################延时函数########################
function running(){
b=''
for ((i=0;i<=100;i+=2))
do
printf "progress:[%-50s]%d%%\r" $b $i
sleep 0.2s
b=#$b
done
echo
}
echo "#############开始更新svn##############";
svn up;

echo "############开始执行ant打包##############";
ant dist;

echo "########开始杀死tomcat进程，请等候5秒####################" ;
ps aux | grep $instance | grep -v grep | awk '{print "kill ",$2|"bash"}' ;
running ;
ps aux | grep $instance | grep -v grep;

echo "###########开始备份###################";
mv ${tomcat_progrm}/webapps/TinyCMS.war ${bak_dir}/TinyCMS__$(date "+%Y%m%d_%H%M").war;
rm -rf ${tomcat_progrm}/webapps/TinyCMS* ;

echo "#################开始部署程序###################";
cp ${target_home}/TinyCMS/dist/*.war ${tomcat_progrm}/webapps/TinyCMS.war

echo "####重启tomcat...." ;
echo ${tomcat_progrm}/bin/startup.sh ;
${tomcat_progrm}/bin/startup.sh;

echo "###########查看启动日志#########" ;
running;
tail -f ${tomcat_progrm}/logs/catalina.out ;