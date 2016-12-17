#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
function perm_change_uid(){
    [[ $1 ]] || { echo "Use: $FUNCNAME username_need_change new_uid "; return 1; }
    echo "Changing..."
    old_uid=`id $1 | grep -oEe "uid=[0-9]+" | grep -oEe "[0-9]+"`
    [[ $old_uid == $2 ]] && return 0
    time {
        usermod -u $2 $1
        find / -user $old_uid -exec chown -h $2 {} \;        
    }
}

function perm_change_gid(){
    [[ $1 ]] || { echo "Use: $FUNCNAME group_need_change new_gid "; return 1; }
    echo "Changing..."
    old_gid=`id $1 | grep -oEe "gid=[0-9]+" | grep -oEe "[0-9]+"`
    [[ $old_gid == $2 ]] && return 0
    time {
        groupmod -g $2 $1
        find / -group $old_gid -exec chgrp -h $1 {} \;
    }
}

function perm_change_ugid(){
    [[ $1 ]] || { echo "Use: $FUNCNAME ugid_need_change new_ugid "; return 1; }
    perm_change_uid $1 $2
    perm_change_gid $1 $2
}

function perm_get_home(){
   [[ $1 ]] || { echo "Use: $FUNCNAME user"; return 1; }
   echo $(getent passwd $1 )| cut -d : -f 6
}
