#!/bin/bash
source ./common.sh

check_root

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Installing ngnix"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabling ngnix"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Starting ngnix"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "Removing existing content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading frontend code"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Extracting frontend code"

cp /home/ec2-user/expense-project-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "copied expense.conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "restarting ngnix"



