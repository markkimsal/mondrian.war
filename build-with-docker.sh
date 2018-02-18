docker run --rm \
 -v $PWD:/app \
 -v $PWD/war-skeleton:/war-skeleton \
 -v $PWD/xwar-skeleton:/xwar-skeleton \
 -v $PWD/m2:/root/.m2/ \
 markkimsal/mondrian-war-build \
 /app/build-war.sh $@
