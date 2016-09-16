FILE_DIR=`dirname $0`
BASE_DIR=`readlink -f $FILE_DIR/../`

PROJECT_NAME=resource-adaptor
NETWORK=platform
NET_ALIAS=$PROJECT_NAME
IMAGE_NAME=smart-cities/$PROJECT_NAME
EXPOSED_PORT=3002

verify () {
  if [ $? != 0 ]; then
    echo $1
    exit 2
  fi
}

if [ "$1" = "start" ]; then
  echo "Starting service $PROJECT_NAME"
  sudo docker run -v $BASE_DIR:/$PROJECT_NAME/ --net=$NETWORK \
    --net-alias=$NET_ALIAS -p $EXPOSED_PORT:3000 $IMAGE_NAME
fi

if [ "$1"  = "stop" ]; then
  echo "Stoping service $PROJECT_NAME"
else
  echo "Command not found."
fi
