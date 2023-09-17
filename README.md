
# rogue.sh

Rogue is a bash script designed to simplify penetration testing workflows for security professionals. It automates the scanning process with Nmap, configures Metasploit, executes exploits, harvests credentials with John the Ripper, generates professional reports, and performs cleanup. The script standardizes these processes to reduce manual labor and free analysts to concentrate on analysis. With only an IP address as input, the script aims to streamline processes while allowing experienced users to customize scans or bypass default behaviors as needed.


## Dependacies

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
## Features

- Automates an end-to-end pentesting workflow via multiple functions
- Scans target with Nmap to identify services and vulnerabilities  
- Imports scan results into Metasploit for exploitation
- Runsexploits and credential cracking to gain initial access
- Extracts files, passwords and other OS intelligence
- Identifies and sessions with elevated privileges 
- Generates report from scan and post-exploitation data
- Modular design allows customization of steps
- Utilizes core pentesting tools like Nmap, Metasploit, John
- Packages results for analysis while cleaning up artifacts
## Installation

Open a terminal and clone the project.

```bash
  git clone https://github.com/1337spectra/rogue.git
```

Navigate to the directory where the script was cloned to.

```bash
  cd rogue
```

Make the script executable.

```bash
  chmod +x rogue.sh
```
## Usage

1. Run the script as root:

```bash
  sudo ./rogue.sh
```

2. Enter the target IP address when prompted.

```bash
  [!] Enter Target IP Address: 127.0.0.1
```

**Note**: Please ensure that the script is run with root privileges, as some commands require administrative access.
## File Structure

The script creates the following directories:

1. `reports`: Contains the Nmap XML scan result and the generated HTML report.
2. `modules`: Contains the `auto.rc`, `post.rc`, and `creds.rc` files used in Metasploit Framework.
3. `creds`: Contains the cracked credentials and combined credentials file.
4. `files`: Contains the extracted files from the target system.

```
	Pentest
	├── reports
	│   ├── Nmap XML scan result
	│   └── Generated HTML report
	├── modules
	│   ├── auto.rc
	│   ├── post.rc
	│   └── creds.rc
	├── creds
	│   ├── Cracked credentials
	│   └── Combined credentials
	└── files
	    └── Extracted files from target
```

### Output

At the end of the script execution, the following output is displayed:

```bash
[!] Pentest done. All reports, files, and credentials can be found in 'Pentest'.
```

The `Pentest` directory will be created in the same directory as the script and will contain all the generated reports, files, and credentials.
## Documentation

This documentation provides an overview of each function in the penetration testing script, detailing what it is designed to do and how it accomplishes those goals. The functions work together to systematically carry out the overall testing process from start to finish.

### initialize()

The initialize() function sets up the necessary environment and tools for the assessment. It first checks that the script is running with root privileges. Then it performs system updates, installs required packages like PostgreSQL, and starts relevant services. Critical directories are created, such as for reports, modules, credentials, and files. The function clones a GitHub repository containing an Nmap parser and downloads additional tools from online repositories. Finally, it sets file permissions and path variables to complete the initialization stage.

**Pseudocode**:

```
Check if root, update packages
Install required packages like PostgreSQL
Start PostgreSQL service
Initialize MSF db
Create directories for reports, modules, creds, files
Clone Nmap parsing repo, download plugins
Set directory permissions
```

### banner()

**Pseudocode**:

```
Print colorful banner text with project info
```

### nmapScan()

An Nmap scan is essential for discovery and vulnerability identification. The nmapScan() function executes a thorough scan of the target system using various Nmap flags, runs additional discovery scripts, and outputs results to an XML report. This centralized report, saved to the reports directory, provides valuable insights into the target for the remainder of the testing process.

**Pseudocode**:

```
Print scan starting message
Run Nmap on target with specified flags
Save XML results
Print scan complete message
```

### msfSetup()

This function prepares the Metasploit framework for exploitation and post-exploitation actions. It imports the Nmap XML data into the Metasploit database, refreshes the host list, configures options like the local host IP, and finally exits the msfconsole. These preparatory steps integrate target reconnaissance into Metasploit to enable automated usage throughout the later functions.

**Pseudocode**:

```
Print setup starting message
Import Nmap XML, reload hosts in MSF
Set LHOST, save config
Print setup done message
```

### createAuto()

Building on the results of nmapScan() and msfSetup(), the createAuto() function generates an automation script. This script leverages the Metasploit db_autopwn plugin to automatically discover and exploit targets. Upon gaining access, it identifies sessions including those with elevated privileges. Post-exploitation actions like credential harvesting are also chained. The end result is a module that methodically conducts the exploitation phase with minimal interaction.

**Pseudocode**:

```
Create auto.rc file in modules dir
Write commands to file:
- Import hosts, load plugin
- Run db_autopwn
- Run vsftpd exploit
- Get all sessions
- Filter for root sessions
- Run post.rc on root sessions
- Gather additional data
- Export results, clean up
- Exit MSF
```

### createPost()

Obtaining additional information from compromised hosts is critical. The createPost() function defines a Metasploit post-exploitation module to extract valuable intel like password hashes, network configurations, user histories and more. Upon completion, the target is fully profiled based on what was accessible through post-exploitation techniques alone.

**Pseudocode**:

```
Create post.rc file in modules dir
Write commands to gather:
- Hashes, files, configs
- Container/VM data
- Credentials
- Exit MSF
```

### createCreds()

With credentials extracted, the final step is often cracking hashes to reverse passwords. This function utilizes John the Ripper for password recovery against the hash files. The cracked credentials are then added to the Metasploit database, completing the full penetration testing cycle from vulnerability discovery to credentials compromise.

**Pseudocode**:

```
Combine passwd, shadow files
Crack hashes with John
Add cracked creds to MSF db
Clean up files
```

### autopwn()

The autopwn() function initiates the exploitation process by executing the previously generated auto.rc automation module. This drives the exploitation phase to completion according to the steps defined in createAuto(), without requiring manual intervention once started.

**Pseudocode**:

```
Print running message
Run MSF with auto.rc
```

### report()

Wrapping up, the report() function leverages the nmap-parse-output tool to transform the detailed Nmap XML data into a formatted HTML report. This condenses the most relevant results and insights into a consumable deliverable for stakeholders.

**Pseudocode**:

```
Print parsing message
Generate HTML report from Nmap XML
Print report done message
```

### cleanup()

No testing effort is complete without cleaning up artifacts. The cleanup() function removes duplicate files, deletes empty folders and files, processes text output for reporting, strips terminal codes, and ensures the environment is restored to its initial state - all important containment and Anti-Forensics steps.

**Pseudocode**:

```
Print cleanup message
Remove duplicate files
Process text files
Generate extracted_files report
Strip terminal codes
Print cleanup done message
```

### mainf()

All of the above functions are orchestrated centrally by mainf(). It prompts for the target, calls the functions in sequence, and finally packages results for delivery. One well-designed testing process is thus defined from start to finish through this driver function and modular component functions below it.

**Pseudocode**:

```
Call all functions in sequence
Package results
Exit with finished message
```
## Limitations

- Rogue requires basic penetration testing skills for usage and advanced skills for customization.
- It is not designed to replace manual testing, but to standardize routine tasks.
- The tool is intended for educational use only and should not be used for unauthorized exploitation of systems.
- Compatibility is limited to Metasploitable 2 virtual machines and may not work with other versions or configurations.
- Rogue.sh is specifically designed for Kali Linux and may not function correctly on other operating systems.
- The `db_autpwn` plugin used in the script is deprecated in newer versions of Metasploit.
- The script lacks comprehensive error checking or validation.
- Hardcoded paths to main folders and files may cause issues if the directory structure is altered or the script is run on a different machine.
- The script assumes the user is running under the username 'kali'.
- Rogue.sh generates a significant amount of network noise during operation, which could be detected by network monitoring tools.
## Screenshots

![Screenshot 1](https://rawcdn.githack.com/1337spectra/rogue/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/1.jpg)

![Screenshot 2](https://rawcdn.githack.com/1337spectra/rogue/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/2.jpg)

![Screenshot 3](https://rawcdn.githack.com/1337spectra/rogue/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/3.jpg)

![Screenshot 4](https://rawcdn.githack.com/1337spectra/rogue/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/4.jpg)

![Screenshot 5](https://rawcdn.githack.com/1337spectra/rogue/143ec64bc83bf27a3f93913f4c6678358a5cfaeb/images/5.jpg)
## Authors

- Gabrielle Decker: [LinkedIn](https://www.linkedin.com/in/gabrielle-decker) [GitHub](https://1337spectra.github.io/) [CodePen](https://codepen.io/gndecker)


## License

[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)

This project is licensed under the GPL v3 - see the [LICENSE.txt](https://github.com/1337spectra/rogue/blob/main/LICENSE.md) file for details
## Acknowledgements

* [db_autopwn.rb](https://github.com/hahwul/metasploit-autopwn)
* [Nmap](https://github.com/nmap/nmap)
* [Metasploit](https://github.com/rapid7/metasploit-framework)
