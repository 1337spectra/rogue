# Rogue.sh
Video playthrough can be seen here: [https://youtu.be/YNRqINIU3Is](https://youtu.be/YNRqINIU3Is)

## Introduction

Rogue.sh is a Bash script developed as part of my Honor's project for a Linux class. Its purpose is to showcase my proficiency in Linux and my aspirations of becoming a penetration tester. Rogue.sh is designed to identify and exploit vulnerabilities in Linux-based systems by performing an Nmap scan, setting up Metasploit, running exploits and post-exploit tasks, and parsing the Nmap XML output. Instead of reinventing the wheel, it makes use of existing projects and combines them all to provide an automated experience.

With its automated approach, Rogue.sh provides a comprehensive overview of the target system's vulnerabilities and security measures, making it easier to identify potential attack vectors. This streamlined process saves time and effort that would otherwise be spent manually running each exploit and collecting data from the target system. By ensuring consistency across different testing environments, Rogue.sh is an effective tool for assessing the security of a target system.

It is important to note that I have no experience with the Bash or Ruby programming languages prior to this project. I was learning as I went and thus the code is likely very ugly. I am sure there are plenty of ways something could have been written more efficiently, and I would love to hear those suggestions, but please be aware that I am aware of it's unsightliness.

## Features

- Scans the target machine for vulnerabilities using Nmap with the vulners script.
- Sets up the Metasploit environment with the output of the Nmap scan.
- Executes db_autopwn module to exploit vulnerabilities on the target machine.
- Downloads sensitive files such as /etc/passwd, /etc/shadow, etc.
- Gathers credentials from the downloaded files and cracks them using John the Ripper.
- Executes various post-exploitation modules to gather information and escalate privileges.

## Usage

1. Connect the Metasploitable 2 VM to your local network.
2. Download the script and save it to the Desktop of your local machine.
3. Open a terminal and navigate to the Desktop containing the script.
4. Run the following command to give execution permission to the script: `chmod +x rogue.sh`
5. Run the script as the root user by executing the following command: `sudo ./rogue.sh`

## Dependencies

The following tools and packages are required to run the script:
- Kali Linux.
- Bash shell 
- Root privileges for the user running the script.
- PostgreSQL and PostgreSQL client packages.
- fdupes utility for finding and deleting duplicate files.
- msfdb for initializing Metasploit database.
- Nmap network exploration tool.
- git for cloning the nmap-parse-output repository.
- wget for downloading the db_autopwn.rb Metasploit plugin.
- Metasploit Framework.
- John the Ripper password cracking tool.

## Limitations

- This script is intended for educational purposes only and should not be used to exploit systems without proper authorization.
- The script is designed to work with Metasploitable 2 virtual machines only and may not work with other versions or configurations.
- The script does not work with other operating systems besides Kali Linux.
- The db_autpwn plugin for Metasploit is deprecated.
- The script offers no error checking or validation.
- Uses hardcoded paths to the main folders and files, which could cause issues if the user changes the directory structure or if the script is run on a different machine.
- The script is run with the assumption the user is running under the username 'kali'.
- This script is NOISY.

## Conclusion

Rogue.sh offers a valuable framework for streamlining the vulnerability assessment and penetration testing process. Its automation capabilities allow security professionals to save time and effort by automating various stages of the process, including vulnerability scanning, Metasploit setup, and password cracking. Additionally, Rogue.sh is highly adaptable and can be tailored to meet the unique needs of different environments.

The tool's ability to automatically exploit vulnerabilities and gather post-exploitation data makes it a powerful asset for identifying and addressing security weaknesses in Linux-based systems. Nonetheless, it's critical to remember that Rogue.sh, like any other penetration testing tool, should be used ethically and only with the explicit permission and consent of the system's owner. Proper care and caution should be exercised to avoid causing damage or disrupting the system
