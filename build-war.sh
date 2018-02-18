#!/bin/sh
echo $1


if [ $1 == 'xmondrian' ];then
XMONDRIAN=1
WARNAME=xmondrian.war
else
XMONDRIAN=0
WARNAME=mondrian.war
fi

WARTMP=/app/wartmp
WARSKL=/war-skeleton
WARSXL=/xwar-skeleton
OUTPUT=/app/dist
cd /app
mkdir -p build
mkdir -p $OUTPUT
cd build
git clone https://github.com/pentaho/maven-parent-poms.git
cd maven-parent-poms/pentaho-ce-parent-pom/pentaho-ce-jar-parent-pom/
git clone https://github.com/pentaho/mondrian.git
cd mondrian/mondrian

#mvn -DrunIT integration-test -Pload-foodmart
#mvn help:active-profiles

#
##TODO: switch branches
mvn -DrunIT install

cp target/mondrian-*.jar $OUTPUT
cp ../workbench/target/workbench-*.jar $OUTPUT
cp ../assemblies/psw-ce/target/psw-ce-*.zip $OUTPUT
#cp ../assemblies/psw-ce/target/lib/*.jar $OUTPUT
cd /app


#initialize tmp dir for organizing war files
rm -Rf $WARTMP
if [ $XMONDRIAN -eq 1 ];then
    echo "initializing x-mondrian add-ons"
    git clone https://github.com/rpbouman/xmla4js $WARSXL/xmla4js
    rm -Rf  $WARSXL/xmla4js/.git/
    cp -R $WARSXL $WARTMP
else
    cp -R $WARSKL $WARTMP
fi

mkdir -p $WARTMP/WEB-INF/lib
unzip $OUTPUT/psw-ce-*.zip -d $WARTMP/
mv    $WARTMP/schema-workbench/* $WARTMP/WEB-INF/
rmdir $WARTMP/schema-workbench
#mv log4j.xml
mv $WARTMP/WEB-INF/log4j.xml $WARTMP/WEB-INF/classes/

jar cf $WARNAME -C $WARTMP .
