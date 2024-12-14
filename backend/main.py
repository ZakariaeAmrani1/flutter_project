import json
from flask import Flask, request, jsonify

app = Flask(__name__)

# File to store the data
DATA_FILE = 'data.json'
TRANSACTIONS_FILE = './data/transactions.json'
USER_FILE = './data/user.json'
CHAT_FILE = './data/chatHistory.json'

# Helper function to read data from the file
def read_data():
    try:
        with open(USER_FILE, 'r') as file:
            return json.load(file)
    except (FileNotFoundError, json.JSONDecodeError):
        return []

def read_user_data():
    try:
        with open(USER_FILE, 'r') as file:
            return json.load(file)
    except (FileNotFoundError, json.JSONDecodeError):
        return []
    
def read_transactions_data():
    try:
        with open(TRANSACTIONS_FILE, 'r') as file:
            return json.load(file)
    except (FileNotFoundError, json.JSONDecodeError):
        return []

def read_chat_data():
    try:
        with open(CHAT_FILE, 'r') as file:
            return json.load(file)
    except (FileNotFoundError, json.JSONDecodeError):
        return []

# Helper function to write data to the file
def write_data(data):
    with open(USER_FILE, 'w') as file:
        json.dump(data, file, indent=4)

def write_user_data(data):
    with open(USER_FILE, 'w') as file:
        json.dump(data, file, indent=4)

def write_transactions_data(data):
    with open(TRANSACTIONS_FILE, 'w') as file:
        json.dump(data, file, indent=4)

def write_chat_data(data):
    with open(CHAT_FILE, 'w') as file:
        json.dump(data, file, indent=4)

@app.route('/data', methods=['POST'])
def store_data():
    incoming_data = request.get_json()
    if not incoming_data:
        return jsonify({'error': 'No data provided'}), 400
    data = []
    # Read existing data
    data.append(read_data())
    # Add new data to the list
    data.append(incoming_data)
    
    # Write updated data to the file
    write_data(data)
    
    return jsonify({'message': 'Data stored successfully', 'data': incoming_data}), 201



@app.route('/data', methods=['GET'])
def get_data():
    
    data = read_data()
    return jsonify(data), 200

@app.route('/user', methods=['GET'])
def get_user_data():
    
    data = read_user_data()
    print("Getting user informations!")
    return jsonify(data), 200



@app.route('/transactions', methods=['GET'])
def get_transactions_data():
    data = read_transactions_data()
    print("Getting all transactions!")
    return jsonify(data), 200


@app.route('/chatHistory', methods=['GET'])
def get_chat_data():
    
    data = read_chat_data()
    print("Getting chat history!")
    return jsonify(data), 200


@app.route('/chatHistory', methods=['POST'])
def store_chat():
    incoming_data = request.get_json()
    if not incoming_data:
        return jsonify({'error': 'No data provided'}), 400
    data = []
    for chat in read_chat_data():
        data.append(chat)
    data.append(incoming_data)
    write_chat_data(data)
    return jsonify({'message': 'Data stored successfully', 'data': incoming_data}), 201

@app.route('/transactions', methods=['POST'])
def store_transaction():
    incoming_data = request.get_json()
    if not incoming_data:
        return jsonify({'error': 'No data provided'}), 400
    data = []
    for transaction in read_transactions_data():
        data.append(transaction)
    data.insert(0,incoming_data)
    write_transactions_data(data)
    return jsonify({'message': 'Data stored successfully', 'data': incoming_data}), 201

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
    app.run(debug=True)
