#!/bin/sh
 
 
alert_path=/var/www/html/myalert
mkdir -p $alert_path
 
gen_html() {
    echo """<html>
    <body>
    <h1>Alert</h1>
    <pre>
    """
    echo "SENDTO:$1"
    echo "SUBJECT:$2"
    echo "MESSAGE:$3"
    echo """
    </pre>
    </body>
    </html>"""
}
 
gen_html $@ > $alert_path/1.html
chmod -R 755 $alert_path
