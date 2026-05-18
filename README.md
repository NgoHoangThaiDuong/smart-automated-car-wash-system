# Smart Automated Car Wash System (PRJ301)

An enterprise Java Web application built with Servlets, JSP, pure JDBC, and MS SQL Server following strict 3-tier MVC architecture.

## 🚀 Quick Start (NetBeans IDE Workflow)

### Prerequisites
- **NetBeans IDE** (version 12.0 or later recommended)
- **JDK 8** (Java 1.8)
- **Apache Tomcat 9.0+** configured within NetBeans
- **Microsoft SQL Server 2019 / Express** running locally on Windows (port 1433)

*(Note: Ensure your database environment credentials and configurations are correctly satisfied based on the `.env.sample` configuration template before proceeding).*

### 1. Build & Automated Database Initialization
1. Open the project folder `smart-automated-car-wash-system` inside **NetBeans IDE**.
2. Right-click the project node and select **Clean and Build**.
   *(NetBeans Ant build will automatically connect to your SQL Server instance via JDBC, create the `AutoCarWash` database if not exists, execute `sql/schema.sql` to build tables, and execute `sql/seed.sql` to insert dummy data and administrator accounts. No SSMS or manual SQL execution needed!)*

### 2. Deploy
Right-click the project node and select **Run** (or select your configured Apache Tomcat 9.0 server and click the Run icon). NetBeans will automatically deploy the `.war` package and launch your browser.

---

## 🏗️ Project Architecture & Constraints
- **Architecture**: Strict MVC 3-tier hierarchy (Servlet Controller -> Service Layer -> Repository Layer).
- **Frontend**: JSP + JSTL + Custom CSS (Fully responsive UI).
- **Backend**: Pure JDBC PreparedStatement implementation (No ORM frameworks).
