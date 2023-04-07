# Rogue.sh
Video playthrough can be seen here: [https://youtu.be/YNRqINIU3Is](https://youtu.be/YNRqINIU3Is)

## Introduction

Rogue is a Bash script developed as an Honors project for my Linux class. Its purpose is to showcase my proficiency in Linux and my aspirations of becoming a penetration tester. Rogue is designed to identify and exploit vulnerabilities in Linux-based systems by performing an Nmap scan, setting up Metasploit, running exploits, and performing post-exploit tasks, as well as parsing the Nmap XML output. Rather than reinventing the wheel, it makes use of existing projects and combines them all to provide an automated framework.

With its automated approach, Rogue provides a comprehensive overview of the target system's vulnerabilities and security measures, making it easier to identify potential attack vectors. This streamlined process saves time and effort that would otherwise be spent manually running each exploit and collecting data from the target system. By ensuring consistency across different testing environments, Rogue could be an effective tool for assessing the security of a target system.

It is important to note that I have no experience with the Bash or Ruby programming languages prior to this project. I was learning as I went and thus the code is likely very ugly. I am sure there are plenty of ways something could have been written more efficiently, and I would love to hear those suggestions, but please be aware that I am aware of it's unsightliness.

## Planning Methodology

I collaborated with my professor to conceptualize a fully automated penetration testing tool. I began by researching potential tools and strategies that could be used in the project. After examining existing scripts, I set about creating an algorithm to guide script development. However, due to the parameters of the project, it was necessary to scale down the size of the algorithm significantly. To help me visualize the tasks and their interconnections, I implemented a flowchart program to lay out my algorithm.

Since Python is well-known for cybersecurity applications, I initially started script development using Python. Nevertheless, based on my familiarity with Linux and the command line, I found Bash to be more intuitive for scripting purposes. This enabled me to make use of my existing knowledge in these areas.

While attempting to make my script work across any system, it became clear why professional development teams spend years constructing such frameworks. To stay within the scope of a single course project, I had to reduce the target OS list to Linux-based systems. I initially sought to limit my project to Nmap, Nikto, and Metasploit to simplify maintenance. However, as I continued to develop my concept, I realized that further tools and strategies were necessary for a comprehensive and successful script.

As I progressed, I annotated my code with comments to record progress and facilitate troubleshooting. Once each segment was complete, I ran tests to confirm that the output matched my expectations. Finally, I checked my entire script for accuracy and precision and recorded a successful run of the script against a Metasploitable 2 virtual machine.

## Research 

Before starting the development of the Rogue Bash script, I conducted thorough research to gain an understanding of the fundamentals of Bash scripting, the Metasploit Framework, and Linux-based vulnerabilities. To begin with, I analyzed existing open-source scripts and frameworks to get a general idea of how they worked. This provided insights into the best practices and design patterns used in scripting for security testing. Open-source tools such as Sn1per, fsociety, Recox, Pureblood, and Discover all helped me to recognize the necessary processes to achieve my desired outcome.

After deciding to use Bash for the language the script would be written in, I researched the basics of Bash scripting, including syntax, variables, loops, functions, and other essential concepts. Jason Cannon's _*Shell Scripting: How to Automate Command Line Tasks Using Bash Scripting and Shell Programming*_ and Chris Johnson and Jayant Varma's _*Pro Bash Programming: Scripting the GNU/Linux Shell Second Edition*_ were some of the key resources used to learn the fundamentals of Bash scripting.

Shortly after, I enrolled in an e-course titled "Practical Ethical Hacking - The Complete Course" by TCM Security. This course provided me with hands-on experience and allowed me to apply the knowledge I had acquired through my research. These resources provided a thorough understanding of the penetration testing process and the tools and techniques involved.

To ensure that the script adhered to industry standards and best practices, I studied the Penetration Testing Execution Standard (PTES) and read Pearson's _*Penetration Testing Fundamentals: A Hands-On Guide to Reliable Security Audits*_ by Chuck Easttom. These resources provided me with a clear understanding of the penetration testing process, its methodologies, and its documentation.

Furthermore, since Metasploit is based on Ruby, it was necessary to gain familiarity with the Ruby programming language to create the resource scripts. For this purpose, as the final step in my research, I read Packt's _*Metasploit Revealed: Secrets of the Expert Pentester*_ by Sagar Rahalkar and Nipun Jaswal and _*Metasploit: The Penetration Tester's Guide*_ by David Kennedy, Jim O'Gorman, Devon Kearns, and Mati Aharoni. These books provided me with an in-depth understanding of Metasploit and a basic understanding of the Ruby language.

## Features

- Scans the target machine for vulnerabilities using Nmap with the vulners script.
- Sets up the Metasploit environment with the output of the Nmap scan.
- Executes db_autopwn module to exploit vulnerabilities on the target machine.
- Downloads sensitive files such as /etc/passwd, /etc/shadow, etc.
- Gathers credentials from the downloaded files and cracks them using John the Ripper.
- Executes various post-exploitation modules to gather information and escalate privileges.

## Usage

### Tl;dr

1. Connect the Metasploitable 2 VM to your local network.
2. Download the script and save it to the Desktop of your local machine.
3. Open a terminal and navigate to the Desktop containing the script.
4. Run the following command to give execution permission to the script: `chmod +x rogue.sh`
5. Run the script as the root user by executing the following command: `sudo ./rogue.sh`

The script begins by checking whether it is being run as root user, which is essential for some of the later operations. Next, it sets the main path for the project and creates directories for reports, modules, credentials, and files.

![Screenshot 1](https://github.com/1337spectra/rogue/blob/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/1.jpg)

The script then downloads nmap-parse-output and the Metasploit plugin autopwn. The first action function is the `nmap_()` function, which scans the target system for vulnerabilities using the Nmap tool. It uses various flags to perform a thorough scan and generate a report in XML format. The report is then saved to the reports directory.

![Screenshot 2](https://github.com/1337spectra/rogue/blob/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/2.jpg)

The `createAuto_()` function creates an module that automates the exploitation process. The module uses db_autopwn to exploit vulnerabilities found in the scan and opens sessions to the target. The function then dumps and saves the session IDs and opens a Meterpreter shell in any session opened by the exploit. The `port_cleaner.rc` file is executed to clean up any open ports after the exploit.

![Screenshot 3](https://github.com/1337spectra/rogue/blob/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/3.jpg)

The `createPost_()` function creates a post-exploitation module that gathers information from the target system, including credentials and system configurations. It is called at the end of the `createAuto_()` function and downloads important files such as `/etc/passwd`, `/etc/shadow`, and `/etc/group` to the creds directory.

![Screenshot 4](https://github.com/1337spectra/rogue/blob/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/4.jpg)

The `createCreds_()` function creates a password cracking module that uses the John the Ripper password cracker to crack the password hashes stored in the shadow file. It is called at the end of the `createPost_()` function.

![Screenshot 5](https://github.com/1337spectra/rogue/blob/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/5.jpg)

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

Rogue offers a valuable framework for streamlining the vulnerability assessment and penetration testing process. Its automation capabilities allow security professionals to save time and effort by automating various stages of the process, including vulnerability scanning, Metasploit setup, and password cracking. Additionally, Rogue is highly adaptable and can be tailored to meet the unique needs of different environments. The tool's ability to automatically exploit vulnerabilities and gather post-exploitation data makes it a powerful asset for identifying and addressing security weaknesses in Linux-based systems. 

Nonetheless, it is critical to remember that Rogue, like any other penetration testing tool, should be used ethically and only with the explicit permission and consent of the system's owner. Proper care and caution should be exercised to avoid causing damage or disrupting the system. 

Overall, Rogue's extensive capabilities and flexibility lay the foundation for an essential tool for security professionals who require an efficient and customizable solution for vulnerability assessment and penetration testing. 

References
----------
Adams, Heath. 2022. _Practical Ethical Hacking - The Complete Course_. Accessed April 7, 2023. www.academy.tcm-sec.com.
Baird, Lee. 2023. "Discover." March 23. www.github.com/leebaird/discover.
Cannon, Jason. 2015. _Shell scripting: How to automate command line tasks using bash scripting and Shell Programming_. Createspace Independent.
Easttom, Chuck. 2018. _Penetration testing fundamentals: A hands-on guide to reliable security audits_. Pearson.
fsociety-team. 2023. "fsociety: Modular Penetration Testing Framework." April 5. www.github.com/fsociety-team/fsociety.
johnjohnsp1. 2018. "Pure Blood v1." July 13. www.github.com/johnjohnsp1/pureblood.
Johnson, Chris, and Jayant Varma. 2015. _Pro bash programming scripting the GNU/linux shell_. Apress.
Kennedy, David. 2011. _Metasploit the penetration tester's guide_. No Starch Press.
Malik, Suleman. 2023. "Recox: Web Application Vulnerability Finder." February 17. www.github.com/samhaxr/recox.
n.d. "Penetration Testing Execution Standard (PTES)." Accessed April 7, 2023. www.pentest-standard.org.
Rahalkar, Sagar, and Nipun Jaswal. 2017. _Metasploit revealed: Secrets of the expert Pentester_. Packt Publishing.
Sn1perSecurity, LLC. 2023. "Sn1per." March 9. www.github.com/1N3/Sn1per.
