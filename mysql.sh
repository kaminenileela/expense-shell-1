#!/bin/bash

source ./common.sh

check_root

read -p "Enter DB Password: " PASSWORD
echo "$PASSWORD"
dnf install mysql-server -y &>> $LOGFILE
#VALIDATE $? "Installing MYSQL server"

systemctl enable mysqld  &>>$LOGFILE
#VALIDATE $? "Enabling MYSQL server"

systemctl start mysqld &>>$LOGFILE
#VALIDATE $? "Starting MYSQL server"


run_mysql_secure_installation() {
    mysql_secure_installation -h db.learningdevopsaws.online --set-root-pass "$PASSWORD" &>>$LOGFILE 
}

is_root_pass_set () {
    mysql -uroot -p$PASSWORD -h db.learningdevopsaws.online -e"select 1;" &>/dev/null
    if [[ $? -eq 0 ]];then
        return 0
    else
        return 1
    fi
}

is_root_pass_set || run_mysql_secure_installation 


# Run mysql_secure_installation
#run_mysql_secure_installation

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
   
   