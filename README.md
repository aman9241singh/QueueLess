# QueueLess – Online Queue Management System

## Project Overview

QueueLess is a web-based Online Queue Management System designed to simplify queue management and reduce customer waiting time. It allows customers to explore available services, book tokens online, track their queue status, and receive notifications. Administrators can manage services, monitor live queues, manage users, and analyze queue activity through an administrative dashboard.

## Objectives

- Reduce physical waiting time and overcrowding.
- Enable customers to book tokens online.
- Provide real-time queue status and token tracking.
- Simplify service and queue management for administrators.
- Improve the overall customer experience.

## Technologies Used

**Frontend**
- HTML5
- CSS3
- JavaScript
- Bootstrap (if used in the final application)

**Backend**
- Java
- JSP (JavaServer Pages)
- Servlets
- JDBC

**Database**
- MySQL

**Development Tools**
- Apache NetBeans IDE
- Apache Tomcat Server
- MySQL Workbench
- Git and GitHub

## Main Features

### Client Module
- User Registration and Login
- Browse Available Services
- Online Token Booking
- Queue Status Tracking
- My Bookings
- Notifications
- Profile Management
- Contact and Feedback

### Admin Module
- Admin Login
- Dashboard and Statistics
- Manage Services
- Live Queue Management
- User Management
- Analytics and Reports
- Announcements
- Contact Message Management
- System Settings
- Admin Profile Management

## Project Structure

```text
QueueLess/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/queueless/
│       │       ├── controller/
│       │       ├── dao/
│       │       ├── model/
│       │       └── util/
│       └── webapp/
│           ├── admin/
│           ├── client/
│           ├── css/
│           ├── js/
│           ├── assets/
│           └── WEB-INF/
├── pom.xml
├── database/
│   └── queueless.sql
└── README.md
```

*Note: Update the folder structure if your actual project differs.*

## Installation and Setup

1. Clone or download this repository.
2. Open the project in Apache NetBeans IDE.
3. Configure Apache Tomcat Server.
4. Create a MySQL database for QueueLess.
5. Import the provided SQL database file.
6. Configure the database connection in the project.
7. Build and run the project using NetBeans.
8. Open the application in your browser.

## Database Configuration

QueueLess uses MySQL as its database.

To configure the database locally:

Install and start MySQL Server.

Create a database named queueless (use the actual database name configured in your project).

Import the provided QueueLess SQL file.

Open the DBConnection.java file located in com.queueless.util.

Configure your local MySQL database URL, username, and password.

Run the application using Apache Tomcat.

Note: Database credentials are specific to each environment. Do not upload actual passwords or sensitive credentials to GitHub.

## Project Purpose

This project is developed as part of the Academic Project (AJT) to demonstrate the practical implementation of enterprise web application technologies.

## Developed By

**Aman Kumar**

Computer Engineering

## Acknowledgement

This project was developed as part of the academic curriculum with the guidance and support of the faculty members.
