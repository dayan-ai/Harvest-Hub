from flask import Flask, render_template, request, jsonify, session, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
import json
from datetime import datetime

app = Flask(__name__)
app.secret_key = "supersecretkey"

# --- DATABASE CONFIGURATION ---
# Using MSSQL with ODBC Driver
app.config['SQLALCHEMY_DATABASE_URI'] = (
    "mssql+pyodbc://@localhost/HarvestHub"
    "?driver=ODBC+Driver+17+for+SQL+Server"
    "&trusted_connection=yes"
)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# --- DATABASE MODELS ---

class Coupon(db.Model):
    __tablename__ = "Coupons"
    coupon_id = db.Column(db.Integer, primary_key=True)
    code = db.Column(db.String(50), unique=True, nullable=False)
    discount_percent = db.Column(db.Integer, nullable=False)

class Customer(db.Model):
    __tablename__ = "Customers"
    customer_id = db.Column(db.Integer, primary_key=True)
    full_name = db.Column(db.String(255))
    email = db.Column(db.String(255))
    phone_number = db.Column(db.String(20))
    address = db.Column(db.String)

class Order(db.Model):
    __tablename__ = "Orders"
    order_id = db.Column(db.Integer, primary_key=True)
    
    # Foreign Key linking to Customers
    customer_id = db.Column(db.Integer, db.ForeignKey("Customers.customer_id"))
    
    # Relationship to fetch Customer details easily
    customer = db.relationship('Customer', backref='orders') 
    
    subtotal = db.Column(db.Float)
    tax_amount = db.Column(db.Float)
    total_amount = db.Column(db.Float)
    payment_method = db.Column(db.String(50))
    order_date = db.Column(db.DateTime, default=datetime.now)

class OrderItem(db.Model):
    __tablename__ = "Order_Items"
    order_item_id = db.Column(db.Integer, primary_key=True)
    order_id = db.Column(db.Integer, db.ForeignKey("Orders.order_id"))
    product_id = db.Column(db.Integer)
    quantity = db.Column(db.Integer)
    unit_price = db.Column(db.Float)
    total_price = db.Column(db.Float)

class Product(db.Model):
    __tablename__ = "Products"
    product_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255))
    price = db.Column(db.Float)
    image_url = db.Column(db.String(255))

class User(db.Model):
    __tablename__ = "Users"
    user_id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    email = db.Column(db.String(100), unique=True)
    password = db.Column(db.String(100))
    role = db.Column(db.String(20))  # 'admin' or 'customer'

# --- ROUTE DEFINITIONS ---

@app.route("/")
def home():
    """Renders the Home Page."""
    return render_template("first.html")

@app.route("/shop")
def shop():
    """Renders the Shop Page."""
    return render_template("shop.html")

@app.route("/details")
def shop_details():
    """Renders Product Details dynamically based on query parameter."""
    product_name = request.args.get('name', 'Brocoli') # Default to Brocoli
    
    # Static dictionary for product details (In a real app, fetch from DB)
    products_data = {
        'Brocoli': {
            'name': 'Brocoli', 'price': 2.67, 'image': 'vegetable-item-2.jpg', 
            'category': 'Vegetables',
            'desc': 'Fresh organic broccoli, rich in vitamins and minerals. Sourced directly from organic farms.'
        },
        'Apple': {
            'name': 'Apple', 'price': 2.59, 'image': 'featur-1.jpg', 
            'category': 'Fruits',
            'desc': 'Crisp, juicy, and naturally sweet apples. Perfect for a healthy snack.'
        },
        'Strawberry': {
            'name': 'Strawberry', 'price': 2.29, 'image': 'featur-2.jpg', 
            'category': 'Fruits',
            'desc': 'Sweet and red strawberries, handpicked fresh from the farm.'
        },
        'Potatoes': {
            'name': 'Potatoes', 'price': 1.76, 'image': 'vegetable-item-5.jpg', 
            'category': 'Vegetables',
            'desc': 'Organic potatoes, great for frying, boiling or baking.'
        }
        # Add more items here if needed
    }
    
    # Fetch product or fallback to default
    product = products_data.get(product_name, products_data['Brocoli'])
    
    return render_template("second.html", product=product)

@app.route("/cart")
def cart():
    return render_template("third.html")

@app.route("/checkout")
def checkout_page():
    return render_template("checkout.html")

@app.route("/contact")
def contact():
    return render_template("contact.html")

@app.route("/about")
def about():
    return render_template("about.html")

@app.route("/privacy")
def privacy():
    return render_template("privacy.html")

@app.route("/coming-soon")
def coming_soon():
    return render_template("coming_soon.html")

# --- COUPON VALIDATION ---
@app.route("/validate-coupon", methods=["POST"])
def validate_coupon():
    data = request.get_json()
    code = data.get('code')
    
    # Check coupon in database
    coupon = Coupon.query.filter_by(code=code).first()
    
    if coupon:
        return jsonify({'valid': True, 'discount': coupon.discount_percent})
    else:
        return jsonify({'valid': False})

# --- AUTHENTICATION (Login/Signup) ---

@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        email = request.form.get("email")
        password = request.form.get("password")
        
        # Authenticate User
        user = User.query.filter_by(email=email, password=password).first()
        
        if user:
            # Store session data
            session['user_id'] = user.user_id
            session['name'] = user.name
            session['role'] = user.role
            
            # Redirect based on Role
            if user.role == 'admin':
                return redirect(url_for('admin_dashboard'))
            else:
                return redirect(url_for('home'))
                
    return render_template("login.html")

@app.route("/signup", methods=["GET", "POST"])
def signup():
    if request.method == "POST":
        # Simplified signup logic (In real app, hash passwords)
        return redirect(url_for('login'))
    return render_template("signup.html")

@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for('home'))

# --- USER DASHBOARD ---
@app.route("/dashboard")
def dashboard():
    # Ensure user is logged in
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    user = User.query.get(session['user_id'])
    
    # Retrieve order history for this user via email matching
    my_orders = []
    matching_customers = Customer.query.filter_by(email=user.email).all()
    
    for customer in matching_customers:
        orders = Order.query.filter_by(customer_id=customer.customer_id).all()
        my_orders.extend(orders)
    
    return render_template("dashboard.html", user=user, orders=my_orders)

# --- ADMIN DASHBOARD ---
@app.route("/admin")
def admin_dashboard():
    # Role-based Access Control
    if 'role' not in session or session['role'] != 'admin':
        return "Access Denied! Administrators only."

    # Fetch all data for admin view
    all_orders = Order.query.all()
    all_users = User.query.all()
    
    # Calculate Total Sales
    total_sale = sum(order.total_amount for order in all_orders)

    return render_template("admin.html", 
                         orders=all_orders, 
                         users=all_users, 
                         sale=total_sale,
                         count_orders=len(all_orders),
                         count_users=len(all_users))

# --- ORDER PROCESSING ---
@app.route("/place-order", methods=["POST"])
def place_order():
    try:
        # Retrieve form data
        name = request.form.get('name')
        email = request.form.get('email')
        phone = request.form.get('phone')
        address = request.form.get('address')
        payment_method = request.form.get('payment')
        cart_json = request.form.get('cart_data')
        
        # Parse Cart Items
        cart_items = json.loads(cart_json)
        
        # Calculate Totals
        subtotal = sum(float(item['price']) * int(item['qty']) for item in cart_items)
        tax = subtotal * 0.10
        total = subtotal + tax

        # Save Customer Info
        new_customer = Customer(full_name=name, email=email, phone_number=phone, address=address)
        db.session.add(new_customer)
        db.session.commit()

        # Create Order
        new_order = Order(
            customer_id=new_customer.customer_id,
            subtotal=subtotal,
            tax_amount=tax,
            total_amount=total,
            payment_method=payment_method
        )
        db.session.add(new_order)
        db.session.commit()

        # Save Order Items (Not implemented in this snippet, but logic exists)
        db.session.commit()
        
        return render_template("first.html") # Redirect to Home after success
    except Exception as e:
        db.session.rollback()
        return f"Error processing order: {str(e)}"

if __name__ == "__main__":
    app.run(debug=True)