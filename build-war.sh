#!/bin/bash
echo $1


if [ "$1" == 'xmondrian' ];then
XMONDRIAN=1
WARNAME="xmondrian.war"
else
XMONDRIAN=0
WARNAME="mondrian.war"
fi

WARTMP=/app/wartmp
WARSKL=/war-skeleton
WARSXL=/xwar-skeleton
OUTPUT=/app/dist
cd /app
mkdir -p build
mkdir -p $OUTPUT

function copy_jars() {
	cd build/maven-parent-poms/pentaho-ce-parent-pom/pentaho-ce-jar-parent-pom/mondrian/
	cp mondrian/target/mondrian-*.jar $OUTPUT
	cp ./workbench/target/workbench-*.jar $OUTPUT
	cp ./assemblies/psw-ce/target/psw-ce-*.zip $OUTPUT
	#cp ./assemblies/psw-ce/target/lib/*.jar $OUTPUT
	cd /app
}

function organize_war() {
	#initialize tmp dir for organizing war files
	rm -Rf $WARTMP/*
	if [ $XMONDRIAN -eq 1 ];then
	    cp -R $WARSXL/* $WARTMP
	else
	    cp -R $WARSKL/* $WARTMP
	fi

	mkdir -p $WARTMP/WEB-INF/lib
	mkdir -p $WARTMP/WEB-INF/classes
	mkdir -p $WARTMP/ROOT


	unzip $OUTPUT/psw-ce-*.zip -d $WARTMP/
	#mv    $OUTPUT/mondrian-*.jar $WARTMP/WEB-INF/lib/
	#mv    $WARTMP/schema-workbench/lib/* $WARTMP/WEB-INF/lib/
	#mv    $WARTMP/schema-workbench/log4j.xml $WARTMP/WEB-INF/classes/
	#rmdir $WARTMP/schema-workbench
	#mv log4j.xml
	#mv $WARTMP/WEB-INF/log4j.xml $WARTMP/WEB-INF/classes/
}

function build_maven() {

	cd build
	if [ ! -d 'maven-parent-poms' ]; then
		git clone https://github.com/pentaho/maven-parent-poms.git
	fi
	cd maven-parent-poms/pentaho-ce-parent-pom/pentaho-ce-jar-parent-pom/
	if [ ! -d 'mondrian' ]; then
		git clone https://github.com/pentaho/mondrian.git
	fi
	cd mondrian/

	#mvn -DrunIT integration-test -Pload-foodmart
	#mvn help:active-profiles

	#
	##TODO: switch branches
        #build/maven-parent-poms/pentaho-ce-parent-pom/pentaho-ce-jar-parent-pom/mondrian/mondrian/target/
	if ls mondrian/target/mondrian-*.jar 2&>1 > /dev/null; then
		echo " ** SKIPPING maven install"
		echo " ** to force maven rebuild remove the build directory or: "
		echo " ** rm build/maven-parent-poms/pentaho-ce-parent-pom/pentaho-ce-jar-parent-pom/mondrian/mondrian/target/*.jar"
	else
		echo "running maven install..."
		mvn -DrunIT install
	fi

	cd /app
}

build_maven
copy_jars
organize_war

#install xmla4js
if [ $XMONDRIAN -eq 1 ];then
    echo "initializing x-mondrian add-ons ..."
    echo "cloning xmla4js"
    git clone https://github.com/rpbouman/xmla4js $WARTMP/xmla4js
    rm -Rf  $WARTMP/xmla4js/.git/

    echo "downloading xavier"
    if [ ! -f $WARTMP/xavier.zip ]; then
        wget -O $WARTMP/xavier.zip "https://github.com/rpbouman/xavier/raw/master/dist/xavier.zip"
        cd $WARTMP/
        unzip xavier.zip
        cd ..
    fi
fi


jar cf $WARNAME -C $WARTMP .
