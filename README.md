# Order Management System

> A full-stack order management system built with **Java, JDBC, MySQL, Servlets, JSP & AJAX**, featuring both a console-based and a real-time web interface for product validation, stock control, and automated order processing.

![Java](https://img.shields.io/badge/Java-007396?style=flat&logo=openjdk&logoColor=white)
![JDBC](https://img.shields.io/badge/JDBC-4479A1?style=flat&logo=java&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white)
![Servlets](https://img.shields.io/badge/Servlets-ED8B00?style=flat&logo=apachetomcat&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-ED8B00?style=flat&logo=apachetomcat&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=javascript&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-green.svg)

---

## Overview

OrderSync lets a user place a product order through either a **command-line interface** or a **browser-based form**, with both versions sharing the same core business logic:

- Product names are validated against a live database before an order can proceed
- Stock levels are checked in real time to prevent overselling
- Order IDs and order dates are generated automatically — no manual entry, no room for human error
- Order value is calculated server-side, never trusted from client input

Built as two parallel implementations of the same backend logic to demonstrate both **core JDBC fundamentals** and **full-stack web integration** (Servlets + JSP + AJAX) within a single project.

---

## Features

- ✅ **Auto-incrementing Order IDs** — handled entirely by the database, retrieved via `RETURN_GENERATED_KEYS`
- ✅ **Automatic order dating** — uses `CURDATE()` at insert time, no client-side date logic
- ✅ **Live product validation** — checks product existence against `Product_Master` before allowing an order
- ✅ **Real-time stock enforcement** — orders exceeding available quantity are rejected, both client-side (instant feedback) and server-side (source of truth)
- ✅ **Automatic order value calculation** — `OrderValue = Quantity × Rate`, computed server-side
- ✅ **AJAX-driven web UI** — product validation and order saving happen without a page reload
- ✅ **Two interchangeable interfaces** — console app for quick testing/demos, web app for a production-style UX

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Java |
| Database Access | JDBC (`PreparedStatement`) |
| Database | MySQL / MariaDB |
| Web Layer | Java Servlets + JSP |
| Frontend Interactivity | Vanilla JavaScript (`fetch` API, AJAX) |
| Server | Apache Tomcat |

---

## Project Structure

```
OrderEntryAssessmentBishwajitPattanaik/
├── consoleapp/
│   ├── OrderEntryApp.java
│   └── seeree_assessment1_bishwajitpattanaik.sql
├── webapp/
│   └── OrderWebApp/
│       ├── src/main/java/com/seeree/orderapp/
│       │   ├── DBUtil.java
│       │   ├── ValidateProductServlet.java
│       │   └── SaveOrderServlet.java
│       └── WebContent/
│           ├── index.jsp
│           └── WEB-INF/
│               └── web.xml
├── .gitignore
├── LICENSE
└── README.md
```

---

## Database Schema

**`Product_Master`**

| Column | Type | Notes |
|---|---|---|
| ProdID | INT | Primary key, auto-increment |
| ProdName | VARCHAR(100) | Unique |
| ProdRate | DECIMAL(10,2) | |
| ProdQty | INT | Available stock |

**`Order_Master`**

| Column | Type | Notes |
|---|---|---|
| OrderID | INT | Primary key, auto-increment |
| OrderDate | DATE | Set via `CURDATE()` |
| ProdID | INT | Foreign key → `Product_Master.ProdID` |
| ProdRate | DECIMAL(10,2) | Captured at time of order |
| OrderQty | INT | |
| OrderValue | DECIMAL(12,2) | `OrderQty × ProdRate` |

---

## Getting Started

### 1. Set up the database

```bash
mysql -u root -p < consoleapp/seeree_assessment1_bishwajitpattanaik.sql
```

This creates the database, both tables, and seeds 5 sample products.

### 2A. Run the console version

You'll need the [MySQL Connector/J](https://dev.mysql.com/downloads/connector/j/) jar — download it and place it alongside `OrderEntryApp.java`.

```bash
cd consoleapp
javac -cp .;mysql-connector-j-8.3.0.jar OrderEntryApp.java
java  -cp .;mysql-connector-j-8.3.0.jar OrderEntryApp
```

> Replace `;` with `:` on macOS/Linux.

### 2B. Run the web version

1. Import `webapp/OrderWebApp` into Eclipse as a **Dynamic Web Project**
2. Download the [MySQL Connector/J](https://dev.mysql.com/downloads/connector/j/) jar and place it in `WebContent/WEB-INF/lib/`
3. Update DB credentials in `DBUtil.java` if needed
4. Run on a configured Tomcat server
5. Visit `http://localhost:8080/OrderWebApp/`

---

## Usage

1. Enter a product name and click **Validate** — rate and available stock load instantly
2. Enter a quantity — order value previews live
3. Click **Save Order** — the server re-validates stock, inserts the order, and returns the generated Order ID and final value

---

## Why Two Versions?

The console app demonstrates raw JDBC fundamentals — connection handling, `PreparedStatement`, transaction-safe inserts — without any framework overhead. The web app builds on that exact same logic but exposes it through Servlets and AJAX, showing how the same business rules translate into a real client-server architecture with asynchronous validation.

---

## License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.

---

## Author

**Bishwajit Pattanaik**
Java Full Stack Developer
