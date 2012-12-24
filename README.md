
## Get account

Register at http://littlesms.ru/, get login and API key.


## Install

Copy littlesms folder to TCL lib directory.


## Usage

    % package require "littlesms"
    0.1

    % set USER {user}
    
    % set KEY {key}
    
    % littlesms::balance $USER $KEY
    balance -1237.45 status success

    % littlesms::price $USER $KEY "Проверка" "964461xxxx,964462xxxx"
    recipients {964461xxxx 964462xxxx} blocked {} parts 1 price 0.6 balance -1238.05 status success

    % littlesms::send $USER $KEY "Проверка" "964461xxxx" ENERGOSBYT
    recipients 964461xxxx blocked {} messages_id 1293083000 count 1 parts 1 price 0.3 balance -1239.55 test 0 status success

    % littlesms::status $USER $KEY 1293083000
    messages {1293083000 delivered} status success
