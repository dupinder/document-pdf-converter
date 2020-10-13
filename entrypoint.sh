#!/bin/bash

if [ ! -z $MAX_HEAP_SIZE ]; then
  export JAVA_OPTS="$JAVA_OPTS -Xmx${MAX_HEAP_SIZE}m"
fi

if [ ! -z $INITIAL_HEAP_SIZE ]; then
  export JAVA_OPTS="$JAVA_OPTS -Xms${INITIAL_HEAP_SIZE}m"
fi

if [ ! -z $DEBUG ] && [ $DEBUG = true ]; then
  export JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000 $JAVA_OPTS"
fi


exec "$@"