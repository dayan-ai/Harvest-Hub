from app import app, db, User

with app.app_context():
    print("Database se connect ho raha hoon...")
    
    # 1. Saaray missing tables bana do (Users table ban jayega)
    db.create_all()
    print("✅ Tables check/create ho gaye.")

    # 2. Check karo ke Admin user hai ya nahi
    admin = User.query.filter_by(email='admin@harvest.com').first()
    
    if not admin:
        # Agar nahi hai to naya Admin banao
        new_admin = User(name='Admin User', email='admin@harvest.com', password='admin123', role='admin')
        db.session.add(new_admin)
        db.session.commit()
        print("✅ Admin User add ho gaya! (Email: admin@harvest.com / Pass: admin123)")
    else:
        print("ℹ️ Admin User pehle se majood hai.")

    print("=== SAB SET HAI! AB APP CHALAO ===")