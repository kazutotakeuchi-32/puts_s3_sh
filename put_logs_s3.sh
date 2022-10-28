!/bin/sh

# AWS/S3の設定
BUCKET_NAME="s3://バケット名"
YEAR=`date +%Y --date '1 day ago'`
MONTH=`date +%m --date '1 day ago'`
DAY=`date +%d --date '1 day ago'`

# EC2インスタンスID取得
INSTANCE_ID=`curl 169.254.169.254/latest/meta-data/instance-id`
SERVER_NAME="サーバー名"

DEST=$BUCKET_NAME/log/$YEAR/$MONTH/$DAY/$SERVER_NAME/$INSTANCE_ID
DIR=/var/log
PREVIOUS_DAY=`date +%Y%m%d --date '1 day ago'`

# 各種前日のログの配列を作成
logs=(nginx/access\.log\-$PREVIOUS_DAY\.gz nginx/error\.log\-$PREVIOUS_DAY\.gz messages\-$PREVIOUS_DAY secure\-$PREVIOUS_DAY cron\-$PREVIOUS_DAY)

# s3出力用のログ名の配列を作成
outputs=(access\.gz error\.gz messages\.gz secure\.gz cron\.gz)

# s3にアップロード
for ((i=0;i<${#logs[@]};i++))
do
echo  $DIR/${logs[i]}
aws s3 cp $DIR/${logs[i]} $DEST/${outputs[i]}
done

