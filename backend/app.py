from flask import Flask, jsonify, request
from db import get_connection

app = Flask(__name__)


@app.route("/")
def home():
    return jsonify({
        "message": "3alTayer API is running"
    })


# =========================
# STORES
# =========================

@app.route("/stores", methods=["GET"])
def get_stores():

    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("""
        SELECT
            store_id,
            store_name,
            description,
            address,
            latitude,
            longitude,
            rating,
            delivery_fee,
            min_order,
            is_open
        FROM Stores
    """)

    stores = []

    for row in cursor.fetchall():
        stores.append({
            "store_id": row.store_id,
            "store_name": row.store_name,
            "description": row.description,
            "address": row.address,
            "latitude": row.latitude,
            "longitude": row.longitude,
            "rating": float(row.rating),
            "delivery_fee": float(row.delivery_fee),
            "min_order": float(row.min_order),
            "is_open": bool(row.is_open)
        })

    cursor.close()
    connection.close()

    return jsonify(stores)


# =========================
# STORE BY ID
# =========================

@app.route("/stores/<int:store_id>", methods=["GET"])
def get_store(store_id):

    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("""
        SELECT
            store_id,
            store_name,
            description,
            address,
            latitude,
            longitude,
            rating,
            delivery_fee,
            min_order,
            is_open
        FROM Stores
        WHERE store_id = ?
    """, (store_id,))

    row = cursor.fetchone()

    cursor.close()
    connection.close()

    if row is None:
        return jsonify({
            "error": "Store not found"
        }), 404

    store = {
        "store_id": row.store_id,
        "store_name": row.store_name,
        "description": row.description,
        "address": row.address,
        "latitude": row.latitude,
        "longitude": row.longitude,
        "rating": float(row.rating),
        "delivery_fee": float(row.delivery_fee),
        "min_order": float(row.min_order),
        "is_open": bool(row.is_open)
    }

    return jsonify(store)


# =========================
# PRODUCTS OF A STORE
# =========================

@app.route("/stores/<int:store_id>/products", methods=["GET"])
def get_store_products(store_id):

    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("""
        SELECT
            product_id,
            name,
            description,
            price,
            image_url,
            is_available
        FROM Products
        WHERE store_id = ?
    """, (store_id,))

    products = []

    for row in cursor.fetchall():
        products.append({
            "product_id": row.product_id,
            "name": row.name,
            "description": row.description,
            "price": float(row.price),
            "image_url": row.image_url,
            "is_available": bool(row.is_available)
        })

    cursor.close()
    connection.close()

    return jsonify(products)


# =========================
# CREATE USER
# =========================

@app.route("/users", methods=["POST"])
def create_user():

    data = request.get_json()

    name = data.get("name")
    email = data.get("email")
    password_hash = data.get("password_hash")
    phone = data.get("phone")
    role = data.get("role", "Customer")

    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("""
        INSERT INTO Users
        (name, email, password_hash, phone, role)
        VALUES (?, ?, ?, ?, ?)
    """, (
        name,
        email,
        password_hash,
        phone,
        role
    ))

    connection.commit()

    cursor.execute("""
        SELECT SCOPE_IDENTITY()
    """)

    user_id = cursor.fetchone()[0]

    cursor.close()
    connection.close()

    return jsonify({
        "message": "User created successfully",
        "user_id": int(user_id)
    }), 201


# =========================
# GET USER
# =========================

@app.route("/users/<int:user_id>", methods=["GET"])
def get_user(user_id):

    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("""
        SELECT
            user_id,
            name,
            email,
            phone,
            role,
            created_at
        FROM Users
        WHERE user_id = ?
    """, (user_id,))

    row = cursor.fetchone()

    cursor.close()
    connection.close()

    if row is None:
        return jsonify({
            "error": "User not found"
        }), 404

    return jsonify({
        "user_id": row.user_id,
        "name": row.name,
        "email": row.email,
        "phone": row.phone,
        "role": row.role,
        "created_at": str(row.created_at)
    })


# =========================
# RUN APP
# =========================

if __name__ == "__main__":
    app.run(debug=True, port=5000)
