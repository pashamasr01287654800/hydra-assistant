# hydra-assistant

hydra-assistant.sh is an interactive Bash script designed to simplify the process of using Hydra, a powerful brute-force tool for password cracking. This script provides a user-friendly interface for building and executing Hydra commands, making it easier for penetration testers and security researchers to test authentication mechanisms across various protocols.

Features

Interactive Command Builder: Guides users through configuring a Hydra command step-by-step.

Supported Protocols: Includes support for protocols like SSH, FTP, HTTP, HTTPS, MySQL, RDP, SMB, VNC, and more.

Customizable Options:

Enter usernames or use a file containing usernames.

Enter passwords or use a file containing passwords.

Configure verbose output, attempts per second, and special guess types (same as login, null, reverse login).


Advanced HTTP/HTTPS Forms:

Supports http-get-form, https-get-form, http-post-form, and https-post-form protocols.

Allows specifying URL paths, POST parameters, and error messages to identify failed attempts.


Real-Time Command Execution: Displays the final Hydra command before execution and allows user confirmation.


Usage

1. Clone the repository:

git clone https://github.com/yourusername/hydra-assistant.git
cd hydra-assistant


2. Make the script executable:

chmod +x hydra-assistant.sh


3. Run the script:

./hydra-assistant.sh


4. Follow the prompts to:

Specify the target IP address and port.

Choose the desired protocol from the list of supported services.

Provide usernames and passwords manually or via files.

Customize advanced options such as -e, -V, and -t.



5. Review the final Hydra command and confirm execution.



Example Command

For an SSH brute-force attack:

hydra -l admin -P /path/to/passwords.txt -u -t 10 192.168.1.100 ssh

For an HTTP POST form attack:

hydra -L /path/to/usernames.txt -P /path/to/passwords.txt -u -t 5 -m "/login:username=^USER^&password=^PASS^:Invalid credentials" 192.168.1.200 http-post-form

Purpose

This script is a productivity tool for ethical hacking and penetration testing, helping users focus on testing rather than manually building complex commands.

Contribution

Contributions are welcome! Feel free to open a pull request or submit feature requests.

Disclaimer

hydra-assistant.sh is intended for authorized security testing only. Unauthorized use of this tool is illegal and unethical. The author is not responsible for misuse or damages caused by this script.
