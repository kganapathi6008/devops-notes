# Setting Up a Sample Spring Boot Application with Maven on Amazon Linux

This guide will walk you through the process of setting up a simple Spring Boot application using Maven on an Amazon Linux server. It includes installing dependencies, building the application, and running it.

---

## **1. Install Prerequisites**

Ensure your Amazon Linux server has the necessary tools installed.

### **Install Java (JDK 17)**
```sh
sudo yum install -y java-17-amazon-corretto-devel
```

### **Verify Java Installation**
```sh
java -version
```

Expected output:
```
openjdk version "17.0."
...
```

### **Install Maven**
```sh
cd /opt
sudo wget https://downloads.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
sudo tar -xvzf apache-maven-3.9.6-bin.tar.gz
sudo ln -s /opt/apache-maven-3.9.6 /opt/maven
```

### **Set Up Maven Environment Variables**
```sh
echo 'export M2_HOME=/opt/maven' | sudo tee -a /etc/profile.d/maven.sh
echo 'export PATH=$M2_HOME/bin:$PATH' | sudo tee -a /etc/profile.d/maven.sh
sudo chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh
```

### **Verify Maven Installation**
```sh
mvn -version
```
Expected output:
```
Apache Maven 3.9.6
...
```

---

## **2. Create a Sample Spring Boot Application**

### **Go to user home directory**
```sh
cd ~
```
### **Generate a Spring Boot Project**
```sh
mvn archetype:generate -DgroupId=com.example -DartifactId=hello-world -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```

### **Move into the Project Directory**
```sh
cd hello-world
```

### **Modify `pom.xml` to Include Spring Boot Dependencies**
Edit `pom.xml` and replace its contents with the following:

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>hello-world</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <name>hello-world</name>
    <description>Spring Boot Hello World Application</description>

    <!-- Add Spring Boot Parent -->
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.2</version>  <!-- Change to latest version if needed -->
        <relativePath/> 
    </parent>

    <dependencies>
        <!-- Spring Boot Web Starter -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>

```

---

## **3. Create the Main Application File**

### **Modify `src/main/java/com/example/App.java`**
Edit the file and replace its contents with:

```java
package com.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class App {
    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }
}

@RestController
@RequestMapping("/")
class HelloController {
    @GetMapping
    public String hello() {
        return "Hello, World from Spring Boot!";
    }
}
```

---

## **4. Build and Run the Application**

### **Build the Application**
```sh
mvn clean package -Dmaven.test.skip=true
```

### **Run the Application**
```sh
java -jar target/hello-world-1.0-SNAPSHOT.jar
```

### **Access the Application**
Open a browser and go to:
```
http://<your-server-ip>:8080/
```
Expected output:
```
Hello, World from Spring Boot!
```

---

## **Troubleshooting**

### **Issue: JUnit Errors During Build**
If you encounter errors related to JUnit while building, either **skip tests** (`-Dmaven.test.skip=true`) or add the following dependencies to `pom.xml`:

```xml
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter-api</artifactId>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter-engine</artifactId>
    <scope>test</scope>
</dependency>
```

### **Issue: Port 8080 Already in Use**
Run the following command to find and kill the process using port 8080:
```sh
sudo netstat -tulnp | grep :8080
sudo kill -9 <PID>
```
Then restart your application.

---

## **Conclusion**
You have successfully set up a Spring Boot application on Amazon Linux, built it using Maven, and deployed it to be accessible via a web browser. 🚀

