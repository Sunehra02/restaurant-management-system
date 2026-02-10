from flask import Flask, render_template, request, redirect, session, url_for
import mysql.connector
from decimal import Decimal
from datetime import datetime, date

from config import *

print("Starting Flask App...")

app = Flask(__name__)
app.secret_key = 'supersecretkey'  # Needed for session management

# MySQL connection setup
conn = mysql.connector.connect(
   host='localhost',
   user='root',
   password='root',
   database='restaurant_db'
)
cursor = conn.cursor(dictionary=True)


def generate_next_user_id(role_prefix):
   """
   role_prefix: 'A', 'W', 'K', or 'C'
   Returns: next user_id like 'A003', 'C0021', etc.
   """
   cursor.execute("SELECT user_id FROM users WHERE user_id LIKE %s ORDER BY user_id DESC LIMIT 1",
                  (role_prefix + '%',))
   last = cursor.fetchone()

   if not last:
       # No user yet
       return f"{role_prefix}001" if role_prefix != 'C' else "C0001"

   last_id = last['user_id']
   number = int(last_id[1:])  # strip prefix and convert

   next_num = number + 1
   if role_prefix == 'C':
       return f"C{next_num:04d}"
   else:
       return f"{role_prefix}{next_num:03d}"


@app.route('/')
def home():
   return redirect('/login')


@app.route('/login', methods=['GET', 'POST'])
def login():
   error = ''
   if request.method == 'POST':
       username = request.form['username']
       password = request.form['password']

       # Authenticate from users table
       cursor.execute("SELECT * FROM users WHERE username = %s AND password = %s", (username, password))
       user = cursor.fetchone()

       if user:
           session['user_id'] = user['user_id']       # Like 'A001'
           session['role'] = user['role']             # Like 'admin', 'waiter', etc.
           session['username'] = user['username']     # For display

           # Get full name from role-specific table
           role = user['role']
           table_map = {
               'admin': 'admins',
               'waiter': 'waiters',
               'kitchen': 'kitchen_staff',
               'customer': 'customers'
           }

           table = table_map.get(role)
           if table:
               cursor.execute(f"SELECT full_name FROM {table} WHERE user_id = %s", (user['user_id'],))
               details = cursor.fetchone()
               session['full_name'] = details['full_name'] if details else 'User'

           return redirect(f'/{role}')

       else:
           error = 'Invalid username or password.'
   return render_template('login.html', error=error)


@app.route('/logout')
def logout():
   session.clear()
   return redirect('/login')


@app.route('/admin')
def admin_dashboard():
    if session.get('role') != 'admin':
        return redirect('/login')

    user_id = session['user_id']

    # Get admin name from DB
    cursor.execute("SELECT full_name FROM admins WHERE user_id = %s", (user_id,))
    name_row = cursor.fetchone()
    name = name_row['full_name'] if name_row else 'Admin'

    # ✅ Check how many items are below threshold
    cursor.execute("SELECT COUNT(*) AS low_count FROM inventory WHERE stock < threshold")
    low_alert = cursor.fetchone()['low_count']

    return render_template('admin_dashboard.html', name=name, user_id=user_id, low_alert=low_alert)


@app.route('/waiter')
def waiter_dashboard():
    if session.get('role') != 'waiter':
        return redirect('/login')

    cursor.execute("SELECT COUNT(*) AS count FROM orders WHERE status = 'ready'")
    ready_order_count = cursor.fetchone()['count']

    user_id = session['user_id']
    cursor.execute("SELECT full_name FROM waiters WHERE user_id = %s", (user_id,))
    waiter = cursor.fetchone()

    return render_template('waiter_dashboard.html', name=waiter['full_name'], user_id=user_id, ready_order_count=ready_order_count)


@app.route('/kitchen')
def kitchen_dashboard():
   if session.get('role') != 'kitchen':
       return redirect('/login')
   return render_template('kitchen_dashboard.html', name=session.get('full_name'), user_id=session.get('user_id'))


@app.route('/customer')
def customer_dashboard():
   if session.get('role') != 'customer':
       return redirect('/login')
   return render_template('customer_dashboard.html', name=session.get('full_name'), user_id=session.get('user_id'))


@app.route('/customer/profile')
def customer_profile():
   if session.get('role') != 'customer':
       return redirect('/login')

   user_id = session.get('user_id')
   cursor.execute("SELECT * FROM customers WHERE user_id = %s", (user_id,))
   customer = cursor.fetchone()

   return render_template('customer_profile.html', customer=customer, user_id=user_id)


def update_inventory(item_id, quantity_sold):
   cursor.execute("UPDATE inventory SET stock = stock - %s WHERE item_id = %s", (quantity_sold, item_id))
   cursor.execute("SELECT stock, threshold FROM inventory WHERE item_id = %s", (item_id,))
   stock_data = cursor.fetchone()
   if stock_data and stock_data['stock'] <= stock_data['threshold']:
       print(f"⚠️ Low stock alert for item {item_id}")


@app.route('/customer/history')
def customer_history():
    if session.get('role') != 'customer':
        return redirect('/login')

    user_id = session['user_id']

    # Fetch orders for this customer
    cursor.execute("SELECT * FROM orders WHERE user_id = %s ORDER BY order_time DESC", (user_id,))
    orders = cursor.fetchall()

    order_data = []
    for order in orders:
        cursor.execute("SELECT item_name, quantity, subtotal FROM order_items WHERE order_id = %s", (order['order_id'],))
        items = cursor.fetchall()

        order_data.append({
            'order_id': order['order_id'],
            'total': order['total_amount'],
            'time': order['order_time'],
            'items': items
        })

    return render_template('customer_order_history.html', orders=order_data)

@app.route('/menu', methods=['GET'])
def menu():
    role = session.get('role')
    if role not in ['customer', 'waiter']:
        return redirect('/login')

    cursor.execute("SELECT * FROM menu_items")
    items = cursor.fetchall()

    # 👤 If waiter, also fetch customer list for dropdown
    customers = []
    if role == 'waiter':
        cursor.execute("SELECT user_id, full_name FROM customers")
        customers = cursor.fetchall()

    return render_template('menu.html', items=items, customers=customers)


from decimal import Decimal

from decimal import Decimal

@app.route('/place_order', methods=['POST'])
def place_order():
    print("SESSION DEBUG:", dict(session))  # Optional: for debugging

    role = session.get('role')
    if role not in ['customer', 'waiter']:
        return redirect('/login')

    cursor.execute("SELECT * FROM menu_items")
    all_items = cursor.fetchall()

    total = Decimal('0.00')
    order_items = []

    for item in all_items:
        qty_str = request.form.get(f'quantity_{item["id"]}', '0')
        if not qty_str or not qty_str.strip().isdigit():
            continue
        qty = int(qty_str)
        if qty <= 0:
            continue

        subtotal = Decimal(str(qty)) * item['price']
        total += subtotal
        order_items.append({
            'id': item['id'],
            'name': item['name'],
            'price': item['price'],
            'quantity': qty,
            'subtotal': subtotal
        })

    if not order_items:
        return render_template('order_status.html', status='fail',
                               message="⚠️ No items were selected. Please choose something to order.")

    total_quantity = sum(item['quantity'] for item in order_items)
    if total_quantity > 10:
        return render_template('order_status.html', status='fail',
                               message="🚫 You cannot order more than 10 items at once.")

    # Apply 15% discount if total ≥ 1500 BDT
    discount_amount = Decimal('0.00')
    if total >= Decimal('1500'):
        discount_amount = total * Decimal('0.15')
        total = (total - discount_amount).quantize(Decimal('0.01'))

    # Determine who placed the order and for whom
    if role == 'waiter':
        selected_customer_id = request.form.get('customer_id')
        if not selected_customer_id:
            return render_template('order_status.html', status='fail',
                                   message="⚠️ Please select a customer.")
        user_id = selected_customer_id
        placed_by = session['user_id']
    else:
        user_id = session['user_id']
        placed_by = None

    try:
        # Insert order with discount
        if placed_by:
            cursor.execute(
                "INSERT INTO orders (user_id, total_amount, placed_by, discount) VALUES (%s, %s, %s, %s)",
                (user_id, total, placed_by, discount_amount)
            )
        else:
            cursor.execute(
                "INSERT INTO orders (user_id, total_amount, discount) VALUES (%s, %s, %s)",
                (user_id, total, discount_amount)
            )
        conn.commit()
        order_id = cursor.lastrowid

        for item in order_items:
            cursor.execute(
                "INSERT INTO order_items (order_id, item_name, quantity, subtotal) VALUES (%s, %s, %s, %s)",
                (order_id, item['name'], item['quantity'], item['subtotal'])
            )

        cursor.execute(
            "INSERT INTO transactions (order_id, user_id, amount, payment_method, status) VALUES (%s, %s, %s, %s, %s)",
            (order_id, user_id, total, 'not_selected', 'unpaid')
        )
        conn.commit()

    except Exception as e:
        print("🚨 ERROR while placing order:", e)
        return render_template('order_status.html', status='fail',
                               message="❌ Something went wrong: " + str(e))

    # Redirect logic
    if role == 'waiter':
        return render_template(
            'order_status.html',
            status='success',
            message=f"✅ Order #{order_id} placed successfully for customer {user_id}.",
            total=total,
            discount=discount_amount,
            back_url='/waiter'
        )
    else:
        return redirect(f'/pay/{order_id}')


@app.route('/waiter/place_order')
def waiter_place_order():
    if session.get('role') != 'waiter':
        return redirect('/login')

    cursor.execute("""
        SELECT u.user_id, c.full_name
        FROM users u
        JOIN customers c ON u.user_id = c.user_id
    """)
    customers = cursor.fetchall()

    cursor.execute("SELECT * FROM menu_items")
    items = cursor.fetchall()

    return render_template('waiter_place_order.html', items=items, customers=customers)


@app.route('/pay/<int:order_id>', methods=['GET', 'POST'])
def pay_now(order_id):
    if session.get('role') != 'customer':
        return redirect('/login')

    cursor.execute("SELECT * FROM orders WHERE order_id = %s", (order_id,))
    order = cursor.fetchone()
    if not order:
        return "Order not found", 404

    total = order['total_amount']
    discount = order.get('discount', Decimal('0.00'))
    original_total = (total + discount).quantize(Decimal('0.01'))

    if request.method == 'POST':
        payment_method = request.form['payment_method']
        cursor.execute("""
            UPDATE transactions 
            SET payment_method = %s, status = 'paid' 
            WHERE order_id = %s
        """, (payment_method, order_id))
        conn.commit()

        return render_template('payment_success.html', order_id=order_id, total=total, discount=discount,
                               original_total=original_total, method=payment_method)

    return render_template('pay_now.html', order_id=order_id, total=total, discount=discount,
                           original_total=original_total)


@app.route('/admin/inventory', methods=['GET', 'POST'])
def manage_inventory():
    if session.get('role') != 'admin':
        return redirect('/login')

    if request.method == 'POST':
        item_id = request.form['item_id']
        new_stock = request.form['new_stock']
        try:
            new_stock = int(new_stock)
            cursor.execute("UPDATE inventory SET stock = %s WHERE item_id = %s", (new_stock, item_id))
            conn.commit()
            message = "Stock updated successfully!"
        except:
            message = "Failed to update stock. Please enter a valid number."
    else:
        message = None

    cursor.execute("SELECT * FROM inventory ORDER BY stock ASC")
    inventory = cursor.fetchall()
    return render_template('admin_inventory.html', inventory=inventory, message=message)

@app.route('/admin/menu', methods=['GET', 'POST'])
def manage_menu():
    if session.get('role') != 'admin':
        return redirect('/login')

    # Add item logic
    if request.method == 'POST':
        name = request.form.get('name')
        price = request.form.get('price')
        try:
            cursor.execute("INSERT INTO menu_items (name, price) VALUES (%s, %s)", (name, price))
            conn.commit()
            message = "Menu item added successfully!"
        except:
            message = "Failed to add menu item."
    else:
        message = None

    # Get all items
    cursor.execute("SELECT * FROM menu_items ORDER BY id ASC")
    menu = cursor.fetchall()

    return render_template('admin_menu.html', menu=menu, message=message)

@app.route('/admin/menu/delete', methods=['POST'])
def delete_menu_item():
    if session.get('role') != 'admin':
        return redirect('/login')

    item_id = request.form.get('id')
    cursor.execute("DELETE FROM menu_items WHERE id = %s", (item_id,))
    conn.commit()

    return redirect('/admin/menu')


@app.route('/admin/orders')
def admin_order_history():
    if session.get('role') != 'admin':
        return redirect('/login')

    cursor.execute("""
        SELECT 
            o.order_id, 
            o.user_id, 
            o.placed_by, 
            o.total_amount, 
            o.discount, 
            o.order_time, 
            c.full_name AS customer_name
        FROM restaurant_db.orders o
        JOIN restaurant_db.customers c ON o.user_id = c.user_id
        ORDER BY o.order_time DESC
    """)
    orders = cursor.fetchall()

    order_data = []

    for order in orders:
        # Fetch ordered items
        cursor.execute("SELECT item_name, quantity, subtotal FROM restaurant_db.order_items WHERE order_id = %s", (order['order_id'],))
        items = cursor.fetchall()

        # If placed by a waiter, get their name
        if order['placed_by']:
            cursor.execute("SELECT full_name FROM restaurant_db.waiters WHERE user_id = %s", (order['placed_by'],))
            waiter = cursor.fetchone()
            placed_by_name = waiter['full_name'] if waiter else order['placed_by']
        else:
            placed_by_name = 'Customer'

        order_data.append({
            'order_id': order['order_id'],
            'customer_name': order['customer_name'],
            'placed_by': placed_by_name,
            'total': order['total_amount'],
            'discount': order['discount'],
            'time': order['order_time'],
            'items': items
        })

    return render_template('admin_order_history.html', orders=order_data)




@app.route('/admin/logs')
def admin_transaction_logs():
    if session.get('role') != 'admin':
        return redirect('/login')

    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT t.*, c.full_name 
        FROM transactions t
        JOIN customers c ON t.user_id = c.user_id
        ORDER BY t.timestamp DESC
    """)
    logs = cursor.fetchall()

    return render_template('admin_transaction_logs.html', logs=logs)


@app.route('/admin/create_staff', methods=['GET', 'POST'])
def create_staff():
    if session.get('role') != 'admin':
        return redirect('/login')

    message = ''

    if request.method == 'POST':
        name = request.form['full_name']
        username = request.form['username']
        password = request.form['password']
        role = request.form['role']
        shift_time = request.form.get('shift_time')  # 👈 new

        if role not in ['waiter', 'kitchen']:
            message = 'Invalid role selected.'
        else:
            new_id = generate_next_user_id(role[0].upper())

            cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
            if cursor.fetchone():
                message = 'Username already exists.'
            else:
                # insert login account
                cursor.execute(
                    "INSERT INTO users (user_id, username, password, role) VALUES (%s, %s, %s, %s)",
                    (new_id, username, password, role)
                )

                if role == 'waiter':
                    cursor.execute(
                        "INSERT INTO waiters (user_id, full_name, shift_time) VALUES (%s, %s, %s)",
                        (new_id, name, shift_time)
                    )
                else:  # kitchen
                    cursor.execute(
                        "INSERT INTO kitchen_staff (user_id, full_name) VALUES (%s, %s)",
                        (new_id, name)
                    )

                conn.commit()
                message = f'{role.capitalize()} created successfully!'

    return render_template('admin_create_staff.html', message=message)


# ---- Admin: View Staff ----
@app.route('/admin/view_staff')
def view_staff():
    if session.get('role') != 'admin':
        return redirect('/login')

    cursor.execute("SELECT user_id, full_name FROM waiters")
    waiters = cursor.fetchall()

    cursor.execute("SELECT user_id, full_name FROM kitchen_staff")
    kitchen_staff = cursor.fetchall()

    return render_template('admin_view_staff.html', waiters=waiters, kitchen_staff=kitchen_staff)


@app.route('/signup', methods=['GET', 'POST'])
def signup():
   error = ''
   if request.method == 'POST':
       full_name = request.form['full_name']
       phone = request.form['phone']
       email = request.form['email']
       username = request.form['username']
       password = request.form['password']

       # Check if username exists
       cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
       if cursor.fetchone():
           error = "Username already exists. Please choose another."
       else:
           # Generate customer ID
           new_id = generate_next_user_id('C')

           # Insert into users table
           cursor.execute("INSERT INTO users (user_id, username, password, role) VALUES (%s, %s, %s, %s)",
                          (new_id, username, password, 'customer'))

           # Insert into customers table
           cursor.execute("INSERT INTO customers (user_id, full_name, phone, email) VALUES (%s, %s, %s, %s)",
                          (new_id, full_name, phone, email))

           conn.commit()

           # Auto-login and set session
           session['user_id'] = new_id
           session['username'] = username
           session['role'] = 'customer'
           session['full_name'] = full_name

           return redirect('/customer')

   return render_template('signup.html', error=error)

# ---------------- Admin Profile ----------------
@app.route('/admin/profile')
def admin_profile():

    # use SAME auth logic as dashboards
    if session.get('role') != 'admin':
        return redirect('/login')

    cursor.execute("""
        SELECT user_id, full_name, email
        FROM admins
        WHERE user_id = %s
    """, (session['user_id'],))

    admin = cursor.fetchone()

    return render_template('admin_profile.html', admin=admin)



# ---------------- Waiter Profile ----------------
@app.route('/waiter/profile')
def waiter_profile():

    # same session system used everywhere
    if session.get('role') != 'waiter':
        return redirect('/login')

    cursor.execute("""
        SELECT user_id, full_name, shift_time
        FROM waiters
        WHERE user_id = %s
    """, (session['user_id'],))

    waiter = cursor.fetchone()

    return render_template('waiter_profile.html', waiter=waiter)


# ---------------- Kitchen Staff Profile ----------------
@app.route('/kitchen/profile')
def kitchen_profile():

    # use SAME session system as whole app
    if session.get('role') != 'kitchen':
        return redirect('/login')

    cursor.execute("""
        SELECT user_id, full_name, specialty
        FROM kitchen_staff
        WHERE user_id = %s
    """, (session['user_id'],))

    kitchen = cursor.fetchone()

    return render_template('kitchen_profile.html', kitchen=kitchen)

from datetime import datetime

# ---------- Kitchen View: Orders ----------
@app.route('/kitchen/orders')
def kitchen_orders():
    if session.get('role') != 'kitchen':
        return redirect('/login')

    # ✅ Only fetch orders that are still "preparing"
    cursor.execute("""
        SELECT o.order_id, o.user_id, o.order_time, c.full_name
        FROM orders o
        JOIN customers c ON o.user_id = c.user_id
        WHERE o.status = 'preparing'
        ORDER BY o.order_time DESC
    """)
    orders = cursor.fetchall()

    order_data = []
    now = datetime.now()

    for order in orders:
        cursor.execute("SELECT item_name, quantity FROM order_items WHERE order_id = %s", (order['order_id'],))
        items = cursor.fetchall()

        time_diff = now - order['order_time']
        minutes = divmod(time_diff.total_seconds(), 60)[0]

        order_data.append({
            'order_id': order['order_id'],
            'customer_name': order['full_name'],
            'order_time': order['order_time'].strftime('%Y-%m-%d %H:%M'),
            'minutes_ago': int(minutes),
            'items': items
        })

    return render_template('kitchen_orders.html', orders=order_data)


# ---------- Mark Order as Ready ----------
@app.route('/kitchen/mark_ready/<int:order_id>', methods=['POST'])
def mark_order_ready(order_id):
    if session.get('role') != 'kitchen':
        return redirect('/login')

    # ✅ Update the order status to 'ready'
    cursor.execute("UPDATE orders SET status = 'ready' WHERE order_id = %s", (order_id,))
    conn.commit()

    print(f"✅ Order #{order_id} marked as READY by kitchen staff.")
    return redirect('/kitchen/orders')


@app.route('/waiter/orders')
def waiter_orders():
    if session.get('role') != 'waiter':
        return redirect('/login')

    # Get all ready orders
    cursor.execute("""
        SELECT o.order_id, o.user_id, o.order_time, c.full_name
        FROM orders o
        JOIN customers c ON o.user_id = c.user_id
        WHERE o.status = 'ready'
        ORDER BY o.order_time ASC
    """)
    orders = cursor.fetchall()

    order_data = []

    for order in orders:
        cursor.execute("SELECT item_name, quantity FROM order_items WHERE order_id = %s", (order['order_id'],))
        items = cursor.fetchall()

        order_data.append({
            'order_id': order['order_id'],
            'customer_name': order['full_name'],
            'order_time': order['order_time'].strftime('%Y-%m-%d %H:%M'),
            'items': items
        })

    return render_template('waiter_orders.html', orders=order_data)

@app.route('/waiter/mark_delivered/<int:order_id>', methods=['POST'])
def mark_order_delivered(order_id):
    if session.get('role') != 'waiter':
        return redirect('/login')

    cursor.execute("UPDATE orders SET status = 'delivered' WHERE order_id = %s", (order_id,))
    conn.commit()
    print(f"✅ Order #{order_id} delivered by waiter.")
    return redirect('/waiter/orders')



@app.route('/kitchen/daily_summary')
def kitchen_daily_summary():
    if session.get('role') != 'kitchen':
        return redirect('/login')

    # Get today's date only (no time)
    today = date.today()

    # Get all order items from today's orders
    cursor.execute("""
        SELECT oi.item_name, SUM(oi.quantity) AS total_qty
        FROM order_items oi
        JOIN orders o ON oi.order_id = o.order_id
        WHERE DATE(o.order_time) = %s
        GROUP BY oi.item_name
        ORDER BY total_qty DESC
    """, (today,))
    summary = cursor.fetchall()

    # Count total orders today
    cursor.execute("SELECT COUNT(*) AS order_count FROM orders WHERE DATE(order_time) = %s", (today,))
    order_count = cursor.fetchone()['order_count']

    return render_template('kitchen_summary.html', summary=summary, order_count=order_count, today=today.strftime('%B %d, %Y'))


if __name__ == '__main__':
   app.run(debug=True)
