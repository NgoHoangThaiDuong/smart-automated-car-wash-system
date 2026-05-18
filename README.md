# Smart Automated Car Wash System (PRJ301)

An enterprise Java Web application built with Servlets, JSP, pure JDBC, and MS SQL Server following strict 3-tier MVC architecture.

## 🚀 Quick Start (NetBeans IDE Workflow)

### Prerequisites
- **NetBeans IDE** (version 12.0 or later recommended)
- **JDK 8** (Java 1.8)
- **Apache Tomcat 9.0+** configured within NetBeans
- **Microsoft SQL Server 2019** (running locally or via Docker container)

*(Note: Ensure your database environment credentials and configurations are correctly satisfied based on the sample configuration template before proceeding).*

### 1. Database Setup & Initialization
If using Docker, start the MS SQL Server container:
```bash
docker-compose up -d
```

Before running the application for the first time, execute the SQL initialization scripts located in the `sql/` directory against your database instance:
1. Execute `sql/schema.sql` to build the required relational tables (`users`, `services`, `orders`).
2. Execute `sql/seed.sql` to insert the initial service catalog and default administrative accounts.

### 2. Build & Deploy in NetBeans
1. Open the project folder `smart-automated-car-wash-system` inside **NetBeans IDE**.
2. Right-click the project node and select **Clean and Build** (NetBeans Ant build will compile classes and bundle the web application).
3. Right-click the project node and select **Run** (or select your configured Apache Tomcat 9.0 server and click the Run icon). NetBeans will automatically deploy the `.war` package and launch your browser.

---

## 🏗️ Project Architecture & Constraints
- **Architecture**: Strict MVC 3-tier hierarchy (Servlet Controller -> Service Layer -> Repository Layer).
- **Frontend**: JSP + JSTL + Custom CSS (Fully responsive UI).
- **Backend**: Pure JDBC PreparedStatement implementation (No ORM frameworks).
