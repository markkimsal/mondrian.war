Build mondrian.war
===

    docker build -t markkimsal/mondrian-war-build:latest .
    sh ./build-with-docker.sh

Build xmondrian.war
---

    docker build -t markkimsal/mondrian-war-build:latest .
    sh ./build-with-docker.sh xmondrian

Xmondrian.war does not currently build and may never will.  Some of the projects included in xmondrian 
assume a very specific packaging structure and URL structure that is not easy to duplicate.

History
---
Continuation of this project which did not provide the system to build the war.

http://rpbouman.blogspot.nl/2016/03/need-mondrian-war-checkout-xmondrian.html
