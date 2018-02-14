#!/usr/bin/env python
import os
import cgi
import requests
import sys
import rds_config
import pymysql

#rds settings
rds_host  = rds_config.db_host
name = rds_config.db_username
password = rds_config.db_password
db_name = rds_config.db_name

try:
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
except:
    sys.exit()

curs=conn.cursor()

print "Content-type:text/plain\n\n";

form = cgi.FieldStorage()
querystring = form.getvalue("querystring")
if querystring != None:
   queryval = "%" + querystring + "%"
   select = "SELECT * FROM clients WHERE name LIKE '" + queryval + "'"
else:
   select = "SELECT * FROM clients"

num_rows = curs.execute(select)
db_result = curs.fetchall()

for row in db_result:
   if len(row) == 4:
      for item in row:
        print item,'|'
      print "#"

curs.close()
conn.close()
