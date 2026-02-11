A full-stack Restaurant Management System built with Flask + MySQL that simulates real restaurant workflows including ordering, kitchen processing, staff management, payments, and admin reporting.

***Admin Features***
1. Add & view staff (waiters + kitchen staff)
2. Manage menu (add/delete items)
3. Inventory management with low-stock alerts
4. View all orders + who placed them
5. Transaction logs


***Kitchen Dashboard***
Kitchen staff can:

1.View incoming orders
2. See time since order placed 
3. Mark orders as Ready
4. View Daily Order Summary
5. Total orders today

***Waiter Dashboard***
Waiters can:
1. Place orders for customers
2. View ready orders
3. Mark orders as Delivered

***Customer Features***
Customers can:
1. Sign up & login
2. Browse menu
3. Place orders
4. Pay for orders
5. View Order History
6, View profile

***Ordering & Payment Logic***
1. Max 10 items per order
2. Automatic 15% discount on orders ≥ 1500 BDT

---

**Database Overview**
Main tables:
1. users (all login credentials)
2. admins
3. waiters
4. kitchen_staff
5. customers
6. menu_items
7. orders
8. order_items
9. transactions
10. inventory

---

**Tech Stack**
Backend: Flask (Python)
Database: MySQL
Frontend: HTML + Bootstrap + Custom CSS

---

**Instructions for Running Locally**

1️. Clone the repository:
git clone https://github.com/Sunehra02/restaurant-management-system.git
cd restaurant-management-system

2️. Create virtual environment:
python -m venv .venv
.venv\Scripts\activate   # Windows

3️. Install dependencies: pip install -r requirements.txt

4. Configure database: Update your DB credentials in config.py.
   
5.  Run the app: python app.py
  
6.  Open in browser
