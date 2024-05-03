#!/bin/bash

source ./common.sh

check_root

echo "Enter Password:"
read PASSWORD


dnf module disable nodejs -y &>>$LOGFILE
#VALIDATE $? "Disabling default nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
#VALIDATE $? "Enabling nodejs version 20"

dnf install nodejs -y &>>$LOGFILE
#VALIDATE $? "Installing nodejs"

useradd(){

    useradd expense
}

is_user_expense_exist(){
    id expense
    if [[ $? -eq 0 ]];then
        return 0
    else
        return 1
    fi
}

is_user_expense_exist || useradd

# id expense &>>$LOGFILE

# if [ $? -ne 0 ]
# then
#     useradd expense &>>$LOGFILE
#     VALIDATE $? "creating expense user"
# else
#      echo -e "Expense user already created ... $Y SKIPPING $N"
# fi

mkdir -p /app &>>$LOGFILE
#VALIDATE $? "creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
#VALIDATE $? "downloading backend code"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
#VALIDATE $? "Extracted backend code"

npm install &>>$LOGFILE
#VALIDATE $? "installing nodejs dependencies"

cp /home/ec2-user/expense-shell-1/backend.service /etc/systemd/system/backend.service
#VALIDATE $? "copied backend service"

systemctl daemon-reload &>>$LOGFILE
#VALIDATE $? "Daemon Reload"
systemctl start backend &>>$LOGFILE
systemctl enable backend &>>$LOGFILE
#VALIDATE $? "Starting and Enabling backend"

dnf install mysql -y &>>$LOGFILE
#VALIDATE $? "Installing mysql client"


mysql -h db.learningdevopsaws.online -uroot -p$PASSWORD < /app/schema/backend.sql &>>$LOGFILE
#VALIDATE $? "Schema loading"


systemctl restart backend &>>$LOGFILE
#VALIDATE $? "restaring backend"
echo "System restarted"