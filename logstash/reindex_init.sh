#!/bin/sh
reindex_init () {
    PIDTEMP=`ps ux | grep logstash | grep java | awk '{ print $2 }'`
    if [ "x$PIDTEMP" = "x" ]; then
        echo "Logstash not found"
    else
         echo "Killing logstash processes ..."
         sudo kill -9 $PIDTEMP
    fi

    echo "Removing logstash data files ..."
    sudo rm /workspace/logstash/logstash-7.13.2/products_data/plugins/inputs/file/.sincedb_*
    echo "Removing indices ..."
    sudo sh delete-indexes.sh
    echo "Indexing data ..."
    sudo sh index-data.sh

}


reindex_init