# Installation
## Using docker-compose:

```
docker compose up -d
```
> **Note**: This docker-compose only spins up the Microsoft SQL Server 2019 database. After it starts, you must execute the SQL scripts in the `sql/` directory (`schema.sql` and `seed.sql`) to initialize tables and dummy data.

## Local
- Requirement:
  - Windows (recommended) or any OS running NetBeans
  - JDK 8
  - Apache Tomcat 9.0+
  - Apache Ant (bundled with NetBeans)

- Clone this project
```
git clone <your-repo-url>
cd smart-automated-car-wash-system
```

- Build and package into war file
```
ant clean dist
```

- Move the war file to tomcat webapps folder 
```
copy .\dist\smart-automated-car-wash-system.war C:\Path\To\Tomcat9\webapps\
```
*(Alternatively, open the project in NetBeans IDE, attach your Tomcat 9 server, and click Run/Deploy)*
