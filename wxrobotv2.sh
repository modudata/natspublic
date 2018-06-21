#!/bin/bash

echo $robotId
echo $robotArea
echo $controllerAddr
echo $flag
echo $downloadUrl

if [ "$downloadUrl" == "" ]; then
    echo "[安装]没有bin文件下载地址" 
fi

if [ ! -f "/home/wxrobot3" ]; then
    echo "[安装]下载bin文件"
    curl $downloadUrl -o /home/wxrobot3
fi

if [ ! -f "/home/wxrobot3" ]; then
    echo "[安装]失败，找不到安装文件。可能未上传文件至服务器"
    exit
fi

chmod +x /home/wxrobot3

if [ "$flag" == "setup" ]; then

    binPath=~/$robotId
    binFile=~/$robotId/wxrobot3

    echo $binPath
    echo $binFile

    if [ "$robotId" == "" ];then
        echo "[安装]错误，robotId为空"
        exit
    fi

    echo "[安装]正在关闭进程和删除旧版bin文件..."

    ps -ef | grep $binFile | grep -v grep | awk '{print $2}' | xargs kill -9

    rm -rf $binPath

    mkdir $binPath

    cp /home/wxrobot3 $binPath

    if [ -f $binFile ]; then
        cd $binPath
        nohup $binFile -i=$robotId -a=$robotArea -c=$controllerAddr > $binPath/logs.txt 2>&1 &
        echo "[安装]WX终端: <$robotId> 启动成功！"
        echo "[安装]大吉大利，今晚吃鸡"
        echo $robotId >> /home/wxids.txt
        exit
    fi

    echo "[安装]安装失败..."
    exit

fi


if [ "$flag" == "update" ] ; then
    echo "[更新]更新终端..."
    
    if [ "$robotId" == "" ];then
      uniq /home/wxids.txt > /home/wxids.txt.uniq
      cat /home/wxids.txt.uniq | while read line
      do
      echo "[更新]正在关闭~/$line/wxrobot3进程和删除旧版bin文件..."

      ps -ef | grep ~/$line/wxrobot3 | grep -v grep | awk '{print $2}' | xargs kill -9

      rm -rf ~/$line
      mkdir ~/$line

      cp /home/wxrobot3 ~/$line

      if [ -f ~/$line/wxrobot3 ]; then
          cd ~/$line
          nohup ~/$line/wxrobot3 -i=$line -a=$robotArea -c=$controllerAddr > ~/$line/logs.txt 2>&1 &
        echo ~/$line,$robotArea
        echo "[更新]WX终端: <$line> 启动成功！"
          echo "[更新]大吉大利，今晚吃鸡"
      else
          echo "[更新]WX终端: <$line> 失败！"
      fi
      done
      rm -rf /home/wxids.txt.uniq
      exit
    else
      echo "[更新]正在关闭~/$robotId/wxrobot3进程和删除旧版bin文件..."
      ps -ef | grep ~/$robotId/wxrobot3 | grep -v grep | awk '{print $2}' | xargs kill -9
      rm -rf ~/$robotId
      mkdir ~/$robotId
      cp /home/wxrobot3 ~/$robotId
      if [ -f ~/$robotId/wxrobot3 ]; then
          cd ~/$robotId
          nohup ~/$robotId/wxrobot3 -i=$robotId -a=$robotArea -c=$controllerAddr > ~/$robotId/logs.txt 2>&1 &
        echo "[更新]WX终端: <$robotId> 启动成功！"
          echo "[更新]大吉大利，今晚吃鸡"
      else
          echo "[更新]WX终端: <$robotId> 失败！"
      fi
      exit
    fi
fi


if [ "$flag" == "delete" ]; then

    binPath=~/$robotId
    binFile=~/$robotId/wxrobot3

    echo $binPath
    echo $binFile

    echo "[更新]正在关闭 $binFile 进程和删除旧版bin文件..."

    ps -ef | grep $binFile | grep -v grep | awk '{print $2}' | xargs kill -9

    rm -rf $binPath

    uniq /home/wxids.txt > /home/wxids.txt.uniq
    cat /home/wxids.txt.uniq | while read line
    do

        if [ "$line" != "$robotId" ]; then
            echo $line >> /home/new_wxids.txt
        fi

    done
    rm -f /home/wxids.txt
    mv /home/new_wxids.txt /home/wxids.txt
    echo "[删除]大吉大利，今晚吃鸡"
    exit
fi

if [ "$flag" == "deleteall" ]; then

    uniq /home/wxids.txt > /home/wxids.txt.uniq

    cat /home/wxids.txt.uniq | while read line
    do
        echo "[删除全部]正在卸载~/$line/wxrobot3..."

        ps -ef | grep ~/$line/wxrobot3 | grep -v grep | awk '{print $2}' | xargs kill -9

        rm -rf ~/$line

    done

    echo "[删除全部]大吉大利，今晚吃鸡"

    rm -rf /home/wxids.txt.uniq
    rm -rf /home/wxids.txt
    exit

fi