#!/bin/bash

source ./common.sh

check_root

read -p "Enter DB Password: " PASSWORD

dnf install mysql-server -y &>> $LOGFILE
#VALIDATE $? "Installing MYSQL server"

systemctl enable mysqld  &>>$LOGFILE
#VALIDATE $? "Enabling MYSQL server"

systemctl start mysqld &>>$LOGFILE
#VALIDATE $? "Starting MYSQL server"


run_mysql_secure_installation() {
    mysql_secure_installation --set-root-pass $PASSWORD &>>$LOGFILE || true
}

# Run mysql_secure_installation
run_mysql_secure_installation

echo -e "MySQL secure installation completed"

#mysql_secure_installation --set-root-pass $PASSWORD &>>$LOGFILE
#VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature
#mysql -h db.learningdevopsaws.online -uroot -p$PASSWORD -e 'SHOW DATABASES;' &>>$LOGFILE

# if [ $? -ne 0 ]
# then
#    mysql_secure_installation --set-root-pass $PASSWORD &>>$LOGFILE
#    #VALIDATE $? "Setting up root password"

# else
#     echo -e "Mysql password already setup... $Y SKIPPING $N"
# fi
   
   