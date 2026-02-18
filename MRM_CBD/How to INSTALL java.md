# Installing Java

`AsmetaComp` needs a working Java environment.

## Windows
To quickly install Java on Mac, follow these three steps:
1. **Download the Installer**: download the latest
JDK (Java Development Kit) installer (MSI or .exe) from the [Oracle website](https://www.oracle.com/java/technologies/downloads/#jdk21-windows). 
2. **Run the installer**: Double-click the downloaded .msi or .exe file to start the installation wizard. follow the on-screen prompts, and click "Close" when finished.
3. **Verify the installation (optional)**:  Open Command Prompt (search for  `cmd`  in the Start menu) and type  `java -version`
    to confirm that the installation was successful
 
## MacOS
To quickly install Java on Mac, follow these three steps:

1. **Download the Installer**: Visit the official [Oracle website](https://www.oracle.com/java/technologies/downloads/#jdk21-mac) and download the latest JDK (Java Development Kit) DMG installer. 
   Choose the version based on your processor:
    * ARM64 DMG Installer: For Mac with Apple Silicon (M1/M2/M3 chips).
    * x64 DMG Installer: For Intel-based Macs.
  
2. **Run the Installer**: Open the downloaded .dmg file and double-click the .pkg file to launch the installation wizard. Follow the on-screen instructions, click "Install," and enter your Mac's password to grant permission.
3. **Verify Installation (optional)**: Open the Terminal (via Spotlight search), type java -version, and press Enter to confirm the installation. 

## Linux - Ubuntu

To quickly install Java on Ubuntu, follow these three steps:

1. First verify that Java is not already inststalled
2. Install the default JRE with apt
3. Run java --version on the command line to validate the install

### 1. Check for existing Java installs

You don’t need to setup Java on Ubuntu if someone has already installed it for you. A quick java --version check will tell you if an install is necessary. 
Open a terminal and check if java is not installed, by trying to execute `java`:
```
java -version
Command 'java' not found, but can be installed with:
sudo apt install default-jre
```
If instaed, the command indicates the version, then Java is installed and you are done. Otherwise you have to install java by usign the apt commands

### 2. Install Java on ubuntu with apt

The full Java suite includes the Java Runtime Environment (JRE), Java Virtual Machine (JVM) and utilities to develop Java source code.
The Java Development Kit (JDK) provides everything a user needs to run Java applications. Install the JDK with the following command:
```
sudo apt install default-jre
Setting up default-jdk-headless (2:1.21) ... 
Setting up openjdk-21-jdk:amd64 (21.0.5+11-1ubuntu~24.04.1) ... 
using /usr/lib/jvm/java-11-openjdk-amd64/bin/jconsole 
Setting up default-jdk (2:1.21) ...
```
Note that it may necessary to execute sudo `apt-get update`
### 3. Verify Java is on the PATH

To validate the successful install of Java on Ubuntu, and to ensure the JDK’s bin directory is accessible through the OS’s PATH variable, issue the following command:
```
java -version
openjdk version "21.0.5" 2024-10-15
OpenJDK Runtime Environment (21.0.5+11-1ubuntu~24.04.11)
OpenJDK 64-Bit Server VM (21.0.5+11-1ubuntu~24.04.1, mixed mode, sharing)
```

If the java -version command outputs information about the version of Java installed, along with information about the JVM and runtime environment, then you successfully installed Java on Ubuntu with apt.
