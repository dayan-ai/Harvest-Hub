# 🌾 Harvest Hub - Organic Food E-Commerce Store

> **Integrated Semester Project:** Object-Oriented Programming (OOP) & Database Systems (DB)  
> **Technologies:** Python Flask, SQL Server, Bootstrap, HTML/CSS

## 📖 Project Overview
**Harvest Hub** is a complete E-commerce web application designed to sell fresh, organic fruits and vegetables. The system connects customers with healthy food options through a user-friendly interface. It features a robust backend for managing orders, users, and products, ensuring a seamless shopping experience.

This project demonstrates the practical implementation of **Object-Oriented Design** principles and **Relational Database Management** concepts.

---

## 🚀 Key Features

### 👤 User Module (Customer)
* **User Authentication:** Secure Login and Signup functionality.
* **Product Browsing:** View detailed information about organic fruits and vegetables.
* **Smart Cart System:** Add items, update quantities, and view real-time totals (with tax calculation).
* **Checkout Process:** Secure checkout with multiple payment options (Cash on Delivery, Easypaisa, Bank Transfer).
* **User Dashboard:** View personal profile and order history.
* **Search & Filter:** Easily find products using the search bar or categories.

### 🛠 Admin Module
* **Admin Dashboard:** Real-time overview of Total Sales, Total Orders, and Registered Users.
* **Order Management:** View details of all customer orders.
* **User Management:** Monitor registered customers and their roles.

### 💻 Technical Highlights
* **Database:** Normalized SQL Server database (3NF) with Primary/Foreign Key constraints.
* **OOP Integration:** Python classes (`User`, `Order`, `Product`) mapped to database tables using SQLAlchemy ORM.
* **Security:** Role-based access control (Admin vs. Customer).

---

## 🛠 Tech Stack

* **Frontend:** HTML5, CSS3, Bootstrap 5, JavaScript (for Cart logic).
* **Backend:** Python 3.x, Flask Web Framework.
* **Database:** Microsoft SQL Server (MSSQL), SQLAlchemy ORM.
* **Tools:** Visual Studio Code, Git/GitHub.

---

## ⚙️ Installation & Setup Guide

Follow these steps to run the project locally on your machine.

### Prerequisites
* Python 3.x installed.
* Microsoft SQL Server installed and running.
* ODBC Driver 17 for SQL Server.

### Steps
1.  **Clone the Repository**
    ```bash
    git clone [https://github.com/dayan-ai/Harvest-Hub.git](https://github.com/dayan-ai/Harvest-Hub.git)
    cd Harvest-Hub
    ```

2.  **Create Virtual Environment**
    ```bash
    python -m venv venv
    # Activate venv:
    # Windows:
    .\venv\Scripts\activate
    ```

3.  **Install Dependencies**
    ```bash
    pip install -r requirements.txt
    ```

4.  **Database Setup**
    * Open **SSMS (SQL Server Management Studio)**.
    * Create a new database named `HarvestHub`.
    * Run the provided `HarvestHub.sql` script to create tables and insert dummy data.

5.  **Run the Application**
    ```bash
    python app.py
    ```

6.  **Access the Website**
    Open your browser and go to: `http://127.0.0.1:5000/`

---

## 📸 Screenshots
*(Add screenshots of Home Page, Shop, Cart, and Dashboard here)*

---

## 📝 License
This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

> **Developed by:** Muhammad Dayan  
> **University Project** - 2026