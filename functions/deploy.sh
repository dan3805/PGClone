#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
deploypgblitz () {
  deployblitzstartcheck # At Bottom - Ensure Keys Are Made

# RCLONE BUILD
echo "#------------------------------------------" > /pg/var/rclone/blitz.conf
echo "#RClone Rewrite | Visit https://pgblitz.com" >> /pg/var/rclone/blitz.conf
echo "#------------------------------------------" >> /pg/var/rclone/blitz.conf

cat /pg/var/.gdrive >> /pg/var/rclone/blitz.conf

if [[ $(cat "/pg/var/.gcrypt") != "NOT-SET" ]]; then
echo ""
cat /pg/var/.gcrypt >> /pg/var/rclone/blitz.conf; fi

cat /pg/var/.tdrive >> /pg/var/rclone/blitz.conf

if [[ $(cat "/pg/var/.tcrypt") != "NOT-SET" ]]; then
echo ""
cat /pg/var/.tcrypt >> /pg/var/rclone/blitz.conf; fi

cat /pg/var/.keys >> /pg/var/rclone/blitz.conf

deploydrives
}

deploypgmove () {
# RCLONE BUILD
echo "#------------------------------------------" > /pg/var/rclone/blitz.conf
echo "#RClone Rewrite | Visit https://pgblitz.com" >> /pg/var/rclone/blitz.conf
echo "#------------------------------------------" >> /pg/var/rclone/blitz.conf

cat /pg/var/.gdrive > /pg/var/rclone/blitz.conf

if [[ $(cat "/pg/var/.gcrypt") != "NOT-SET" ]]; then
echo ""
cat /pg/var/.gcrypt >> /pg/var/rclone/blitz.conf; fi
deploydrives
}

deploydrives () {
  fail=0
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Conducting RClone Mount Checks ~ pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

if [ -e "/pg/var/.drivelog" ]; then rm -rf /pg/var/.drivelog; fi
touch /pg/var/.drivelog

  if [[ "$transport" = "mu" ]]; then
    gdrivemod
    multihdreadonly
  elif [[ "$transport" == "me" ]]; then
    gdrivemod
    gcryptmod
    multihdreadonly
  elif [[ "$transport" == "bu" ]]; then
    gdrivemod
    tdrivemod
    gdsamod
    multihdreadonly
  elif [[ "$transport" == "be" ]]; then
    gdrivemod
    tdrivemod
    gdsamod
    gcryptmod
    tcryptmod
    gdsacryptmod
    multihdreadonly
  fi

cat /pg/var/.drivelog
logcheck=$(cat /pg/var/.drivelog | grep "Failed")

if [[ "$logcheck" == "" ]]; then

  if [[ "$transport" == "mu" || "$transport" == "me" ]]; then executemove; fi
  if [[ "$transport" == "bu" || "$transport" == "be" ]]; then executeblitz; fi

else

  if [[ "$transport" == "me" || "$transport" == "be" ]]; then
  emessage="
  NOTE1: User forgot to share out GDSA E-Mail to Team Drive
  NOTE2: Conducted a blitz key restore and keys are no longer valid
  "; fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 RClone Mount Checks - Failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CANNOT DEPLOY!

POSSIBLE REASONS:
1. GSuite Account is no longer valid or suspended
2. Client ID and/or Secret are invalid and/or no longer exist
$emessage
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
clonestart
fi
}

########################################################################################
gdrivemod ()
{
  initial=$(rclone lsd --config /pg/var/rclone/blitz.conf gdrive: | grep -oP plexguide | head -n1)

  if [[ "$initial" != "plexguide" ]]; then
    rclone mkdir --config /pg/var/rclone/blitz.conf gdrive:/plexguide
    initial=$(rclone lsd --config /pg/var/rclone/blitz.conf gdrive: | grep -oP plexguide | head -n1)
  fi

  if [[ "$initial" == "plexguide" ]]; then echo "GDRIVE :  Passed" >> /pg/var/.drivelog; else echo "GDRIVE :  Failed" >> /pg/var/.drivelog; fi
}
tdrivemod ()
{
  initial=$(rclone lsd --config /pg/var/rclone/blitz.conf tdrive: | grep -oP plexguide | head -n1)

  if [[ "tinitial" != "plexguide" ]]; then
    rclone mkdir --config /pg/var/rclone/blitz.conf gdrive:/plexguide
    initial=$(rclone lsd --config /pg/var/rclone/blitz.conf tdrive: | grep -oP plexguide | head -n1)
  fi

  if [[ "$initial" == "plexguide" ]]; then echo "TDRIVE :  Passed" >> /pg/var/.drivelog; else echo "TDRIVE :  Failed" >> /pg/var/.drivelog; fi
}
gcryptmod ()
{
  c1initial=$(rclone lsd --config /pg/var/rclone/blitz.conf gdrive: | grep -oP encrypt | head -n1)
  c2initial=$(rclone lsd --config /pg/var/rclone/blitz.conf gcrypt: | grep -oP plexguide | head -n1)

  if [[ "$c1initial" != "encrypt" ]]; then
    rclone mkdir --config /pg/var/rclone/blitz.conf gdrive:/encrypt
    c1initial=$(rclone lsd --config /pg/var/rclone/blitz.conf gdrive: | grep -oP encrypt | head -n1)
  fi
  if [[ "$c2initial" != "plexguide" ]]; then
    rclone mkdir --config /pg/var/rclone/blitz.conf gcrypt:/plexguide
    c2initial=$(rclone lsd --config /pg/var/rclone/blitz.conf gcrypt: | grep -oP plexguide | head -n1)
  fi

  if [[ "$c1initial" == "encrypt" ]]; then echo "GCRYPT1:  Passed" >> /pg/var/.drivelog; else echo "GCRYPT1:  Failed" >> /pg/var/.drivelog; fi
  if [[ "$c2initial" == "plexguide" ]]; then echo "GCRYPT2:  Passed" >> /pg/var/.drivelog; else echo "GCRYPT2:  Failed" >> /pg/var/.drivelog; fi
}
tcryptmod ()
{
  c1initial=$(rclone lsd --config /pg/var/rclone/blitz.conf tdrive: | grep -oP encrypt | head -n1)
  c2initial=$(rclone lsd --config /pg/var/rclone/blitz.conf tcrypt: | grep -oP plexguide | head -n1)

  if [[ "$c1initial" != "encrypt" ]]; then
    rclone mkdir --config /pg/var/rclone/blitz.conf tdrive:/encrypt
    c1initial=$(rclone lsd --config /pg/var/rclone/blitz.conf tdrive: | grep -oP encrypt | head -n1)
  fi
  if [[ "$c2initial" != "plexguide" ]]; then
    rclone mkdir --config /pg/var/rclone/blitz.conf tcrypt:/plexguide
    c2initial=$(rclone lsd --config /pg/var/rclone/blitz.conf tcrypt: | grep -oP plexguide | head -n1)
  fi

  if [[ "$c1initial" == "encrypt" ]]; then echo "TCRYPT1:  Passed" >> /pg/var/.drivelog; else echo "TCRYPT1:  Failed" >> /pg/var/.drivelog; fi
  if [[ "$c2initial" == "plexguide" ]]; then echo "TCRYPT2:  Passed" >> /pg/var/.drivelog; else echo "TCRYPT2:  Failed" >> /pg/var/.drivelog; fi
}
gdsamod ()
{
  initial=$(rclone lsd --config /pg/var/rclone/blitz.conf GDSA01: | grep -oP plexguide | head -n1)

  if [[ "$initial" != "plexguide" ]]; then
    rclone mkdir --config /pg/var/rclone/blitz.conf GDSA01:/plexguide
    initial=$(rclone lsd --config /pg/var/rclone/blitz.conf GDSA01: | grep -oP plexguide | head -n1)
  fi

  if [[ "$initial" == "plexguide" ]]; then echo "GDSA01 :  Passed" >> /pg/var/.drivelog; else echo "GDSA01 :  Failed" >> /pg/var/.drivelog; fi
}
gdsacryptmod ()
{
  initial=$(rclone lsd --config /pg/var/rclone/blitz.conf GDSA01C: | grep -oP encrypt | head -n1)

  if [[ "$initial" != "plexguide" ]]; then
    rclone mkdir --config /pg/var/rclone/blitz.conf GDSA01C:/plexguide
    initial=$(rclone lsd --config /pg/var/rclone/blitz.conf GDSA01C: | grep -oP plexguide | head -n1)
  fi

  if [[ "$initial" == "plexguide" ]]; then echo "GDSA01C:  Passed" >> /pg/var/.drivelog; else echo "GDSA01C:  Failed" >> /pg/var/.drivelog; fi
}
################################################################################
deployblitzstartcheck () {

pgclonevars
if [[ "$displaykey" == "0" ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Fail Notice ~ pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  There are [0] keys generated for PG Blitz! Create those first!

NOTE: Without any keys, PG Blitz cannot upload any data without the use
of service accounts

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
clonestart
fi
}
