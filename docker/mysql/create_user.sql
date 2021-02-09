CREATE USER 'user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost' WITH GRANT OPTION;

CREATE USER 'user'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'user'@'%' WITH GRANT OPTION;


#CREATE USER 'X'@'localhost' IDENTIFIED BY 'X-';
#GRANT XX ON X.* TO 'X'@'localhost';