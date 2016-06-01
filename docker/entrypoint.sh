#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}
USERSWITCH_SOURCE=/tmp/userswitch.c
USERSWITCH_BIN=/usr/local/bin/userswitch

cat <<EOF > $USERSWITCH_SOURCE
#include <unistd.h>
int main(int argc, char *const *argv)
{
    setuid($USER_ID);
    execvp( "tox", argv);
}
EOF

gcc -o $USERSWITCH_BIN $USERSWITCH_SOURCE

echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
export HOME=/home/user
echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
exec $USERSWITCH_BIN $@
