# Rogue.sh
Video playthrough can be seen here: [https://youtu.be/YNRqINIU3Is](https://youtu.be/YNRqINIU3Is)

## Introduction

Rogue is a Bash script developed as an Honors project for my Linux class. Its purpose is to showcase my proficiency in Linux and my aspirations of becoming a penetration tester. Rogue is designed to identify and exploit vulnerabilities in Linux-based systems by performing an Nmap scan, setting up Metasploit, running exploits, and performing post-exploit tasks, as well as parsing the Nmap XML output. Rather than reinventing the wheel, it makes use of existing projects and combines them all to provide an automated framework.

With its automated approach, Rogue provides a comprehensive overview of the target system's vulnerabilities and security measures, making it easier to identify potential attack vectors. This streamlined process saves time and effort that would otherwise be spent manually running each exploit and collecting data from the target system. By ensuring consistency across different testing environments, Rogue could be an effective tool for assessing the security of a target system.

It is important to note that I have no experience with the Bash or Ruby programming languages prior to this project. I was learning as I went and thus the code is likely very ugly. I am sure there are plenty of ways something could have been written more efficiently, and I would love to hear those suggestions, but please be aware that I am aware of it's unsightliness.

## Features

- Scans target machine for vulnerabilities using Nmap with vulners script.
- Sets up Metasploit environment with Nmap scan results.
- Executes db_autopwn module to exploit vulnerabilities on target machine.
- Downloads sensitive files such as `/etc/passwd` and `/etc/shadow`.
- Gathers & cracks credentials from downloaded files with John the Ripper.
- Executes post-exploitation modules to gather info & escalate privileges.
- Generates easy-to-read HTML report of Nmap scan.

## Usage

### Tl;dr

1. Connect the Metasploitable 2 VM to your local network.
2. Download the script and save it to the Desktop of your local machine.
3. Open a terminal and navigate to the Desktop containing the script.
4. Run the following command to give execution permission to the script: `chmod +x rogue.sh`
5. Run the script as the root user by executing the following command: `sudo ./rogue.sh`

---

1. The script begins by checking whether it is being run as root user, which is essential for some of the later operations. Next, it sets the main path for the project and creates directories for reports, modules, credentials, and files.

![Screenshot 1](https://github.com/1337spectra/rogue/blob/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/1.jpg)

2. The script then downloads `nmap-parse-output` and the Metasploit plugin `autopwn`. The first action function is the `nmap_()` function, which scans the target system for vulnerabilities using the Nmap tool. It uses various flags to perform a thorough scan and generate a report in XML format. The report is then saved to the reports directory.

![Screenshot 2](https://github.com/1337spectra/rogue/blob/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/2.jpg)

3. The `createAuto_()` function creates an module that automates the exploitation process. The module uses db_autopwn to exploit vulnerabilities found in the scan and opens sessions to the target. The function then dumps and saves the session IDs and opens a Meterpreter shell in any session opened by the exploit. The `port_cleaner.rc` file is executed to clean up any open ports after the exploit.

![Screenshot 3](https://github.com/1337spectra/rogue/blob/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/3.jpg)

4. The `createPost_()` function creates a post-exploitation module that gathers information from the target system, including credentials and system configurations. It is called at the end of the `createAuto_()` function and downloads important files such as `/etc/passwd`, `/etc/shadow`, and `/etc/group` to the creds directory.

![Screenshot 4](https://github.com/1337spectra/rogue/blob/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/4.jpg)

5. The `createCreds_()` function creates a password cracking module that uses the John the Ripper password cracker to crack the password hashes stored in the shadow file. It is called at the end of the `createPost_()` function.

![Screenshot 5](https://github.com/1337spectra/rogue/blob/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/5.jpg)

## Dependencies

The following tools and packages are required to run the script:
- Kali Linux.
- Bash shell 
- Root privileges for the user running the script.
- PostgreSQL and PostgreSQL client packages.
- `fdupes` utility for finding and deleting duplicate files.
- `msfdb` for initializing Metasploit database.
- `Nmap` network exploration tool.
- `git` for cloning the nmap-parse-output repository.
- `wget` for downloading the `db_autopwn.rb` Metasploit plugin.
- Metasploit Framework.
- John the Ripper password cracking tool.

## Limitations

- **Educational Use Only**: This script is intended for educational purposes and should not be used to exploit systems without proper authorization.
- **Compatibility**: The script is designed to work with Metasploitable 2 virtual machines and may not be compatible with other versions or configurations.
- **Operating System**: Rogue.sh is tailored for use with Kali Linux and may not function correctly on other operating systems.
- **Deprecated Metasploit Plugin**: The `db_autpwn` plugin used in this script is deprecated in newer versions of Metasploit.
- **Lack of Error Checking**: The script does not include comprehensive error checking or validation, so caution should be exercised while using it.
- **Hardcoded Paths**: The script utilizes hardcoded paths to main folders and files, which may cause issues if the directory structure is modified or if the script is run on a different machine.
- **Assumption of User**: The script assumes that the user is running under the username 'kali'.
- **Noisiness**: Rogue.sh generates significant noise during its execution, which may be detectable by network monitoring tools.

## Conclusion

Rogue offers a valuable framework for streamlining the vulnerability assessment and penetration testing process. Its automation capabilities allow security professionals to save time and effort by automating various stages of the process, including vulnerability scanning, Metasploit setup, and password cracking. Additionally, Rogue is highly adaptable and can be tailored to meet the unique needs of different environments. The tool's ability to automatically exploit vulnerabilities and gather post-exploitation data makes it a powerful asset for identifying and addressing security weaknesses in Linux-based systems. 

However, it is crucial to emphasize that Rogue.sh, like any penetration testing tool, must be used ethically and with explicit permission from the system owner. Caution should be exercised to prevent any potential damage or disruption to the target system.

Overall, Rogue's extensive capabilities and flexibility lay the foundation for an essential tool for security professionals who require an efficient and customizable solution for vulnerability assessment and penetration testing.


## License

This project is licensed under the terms of the GNU General Public License v3.0.

A copy of the license can be found in the LICENSE.txt file.
