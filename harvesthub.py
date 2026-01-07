from app import app, db, User

def initialize_database():
    """
    Initializes the database, creates tables, and ensures
    the default Admin user exists.
    """
    # Create an application context to interact with the database
    with app.app_context():
        print("🔄 Connecting to the database...")
        
        # 1. Create all missing tables based on the defined models
        # This ensures tables like 'User', 'Product', 'Order' exist
        db.create_all()
        print("✅ Database tables checked/created successfully.")

        # 2. Check if the default Admin user already exists
        admin = User.query.filter_by(email='admin@harvest.com').first()
        
        if not admin:
            # If Admin does not exist, create a new one
            print("⚙️ Admin user not found. Creating new Admin...")
            
            new_admin = User(
                name='System Admin', 
                email='admin@harvest.com', 
                password='admin123',  # Note: Ideally, use password hashing in production
                role='admin'
            )
            
            db.session.add(new_admin)
            db.session.commit()
            
            print("✅ Admin User created successfully!")
            print("👉 Credentials -> Email: admin@harvest.com | Password: admin123")
        else:
            print("ℹ️ Admin User already exists. Skipping creation.")

        print("\n=== ✅ SETUP COMPLETE! YOU CAN RUN THE APP NOW ===")

if __name__ == "__main__":
    initialize_database()