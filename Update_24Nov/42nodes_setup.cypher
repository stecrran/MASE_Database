// Clear all existing data
MATCH (n)
DETACH DELETE n;

// Create Customers
CREATE (:Customer {customerId: 'C001', name: 'Jim', email: 'jim@gmail.com', phone: '0865443322'});
CREATE (:Customer {customerId: 'C002', name: 'Áine', email: 'aine@gmail.com', phone: '0874443234'}); 
CREATE (:Customer {customerId: 'C003', name: 'John', email: 'john@gmail.com', phone: '0874309889'});
CREATE (:Customer {customerId: 'C004', name: 'Sophia', email: 'sophia@gmail.com', phone: '0854327887'});
CREATE (:Customer {customerId: 'C005', name: 'Jane', email: 'jane@gmail.com', phone: '0854327887'});

// Create Accounts
CREATE (:Account {accountId: 'A001', balance: 5784, accountType: 'Credit'});
CREATE (:Account {accountId: 'A002', balance: 2990, accountType: 'Credit'});
CREATE (:Account {accountId: 'A003', balance: 10632, accountType: 'Checking'});
CREATE (:Account {accountId: 'A004', balance: 3009, accountType: 'Savings'});
CREATE (:Account {accountId: 'A005', balance: 570, accountType: 'Credit'});
CREATE (:Account {accountId: 'A006', balance: 10098, accountType: 'Credit'});
CREATE (:Account {accountId: 'A007', balance: 1320, accountType: 'Credit'});
CREATE (:Account {accountId: 'A008', balance: 1430, accountType: 'Credit'});
CREATE (:Account {accountId: 'A009', balance: 863, accountType: 'Savings'});
CREATE (:Account {accountId: 'A010', balance: 1000, accountType: 'Savings'});
CREATE (:Account {accountId: 'A011', balance: 1863, accountType: 'Savings'});

// Create Transactions
CREATE (:Transaction {transactionId: 'T001', amount: 120, timestamp: '2024-11-15T10:00:00', location: 'Dublin'});
CREATE (:Transaction {transactionId: 'T002', amount: 2800, timestamp: '2024-11-15T10:30:00', location: 'Athlone'});
CREATE (:Transaction {transactionId: 'T003', amount: 13, timestamp: '2024-11-16T12:00:00', location: 'Galway'});
CREATE (:Transaction {transactionId: 'T004', amount: 80, timestamp: '2024-11-16T15:45:00', location: 'Limerick'});
CREATE (:Transaction {transactionId: 'T005', amount: 90, timestamp: '2024-11-16T15:46:00', location: 'Waterford'});
CREATE (:Transaction {transactionId: 'T006', amount: 150, timestamp: '2024-11-16T15:50:00', location: 'Longford'});
CREATE (:Transaction {transactionId: 'T007', amount: 500, timestamp: '2024-11-16T16:10:00', location: 'Dublin'});
CREATE (:Transaction {transactionId: 'T008', amount: 350, timestamp: '2024-11-16T17:05:00', location: 'Athlone'});
CREATE (:Transaction {transactionId: 'T009', amount: 1, timestamp: '2024-11-17T08:40:00', location: 'Galway'});
CREATE (:Transaction {transactionId: 'T010', amount: 5, timestamp: '2024-11-17T08:45:00', location: 'Galway'});
CREATE (:Transaction {transactionId: 'T011', amount: 2, timestamp: '2024-11-17T09:40:00', location: 'Galway'});
CREATE (:Transaction {transactionId: 'T012', amount: 2200, timestamp: '2024-11-15T11:30:00', location: 'Athlone'});
CREATE (:Transaction {transactionId: 'T013', amount: 2500, timestamp: '2024-11-15T12:30:00', location: 'Athlone'});


// Create Merchants
CREATE (:Merchant {merchantId: 'M001', name: 'Smyths'});
CREATE (:Merchant {merchantId: 'M002', name: 'XYZ'});
CREATE (:Merchant {merchantId: 'M003', name: 'Zara'});
CREATE (:Merchant {merchantId: 'M004', name: 'Harvey Norman'});
CREATE (:Merchant {merchantId: 'M005', name: 'Shoe Factory'});
CREATE (:Merchant {merchantId: 'M006', name: 'H Samuel'});
CREATE (:Merchant {merchantId: 'M007', name: 'Toastbox Café'});


// Create Devices
CREATE (:Device {deviceId: 'D001', type: 'Mobile', ipAddress: '192.168.1.1'});
CREATE (:Device {deviceId: 'D002', type: 'Desktop', ipAddress: '203.0.113.42'});
CREATE (:Device {deviceId: 'D003', type: 'Tablet', ipAddress: '192.168.2.10'});
CREATE (:Device {deviceId: 'D004', type: 'Laptop', ipAddress: '203.0.113.50'});
CREATE (:Device {deviceId: 'D005', type: 'Mobile', ipAddress: '203.0.113.51'});
CREATE (:Device {deviceId: 'D006', type: 'Laptop', ipAddress: '123.134.154.32'});
CREATE (:Device {deviceId: 'D007', type: 'Mobile'});
CREATE (:Device {deviceId: 'D008', type: 'Tablet'});


// Link Customers to Accounts
// MERGE ensures idempotency, meaning the query can be run multiple times without creating duplicate relationships
// C004 has 5 accounts
MATCH (c:Customer {customerId: 'C001'}), (a:Account {accountId: 'A001'})
MERGE (c)-[:OWNS]->(a);

MATCH (c:Customer {customerId: 'C002'}), (a:Account {accountId: 'A002'})
MERGE (c)-[:OWNS]->(a);

MATCH (c:Customer {customerId: 'C003'}), (a:Account {accountId: 'A003'})
MERGE (c)-[:OWNS]->(a);

MATCH (c:Customer {customerId: 'C004'}), (a:Account {accountId: 'A004'})
MERGE (c)-[:OWNS]->(a);

MATCH (c:Customer {customerId: 'C004'}), (a:Account {accountId: 'A005'})
MERGE (c)-[:OWNS]->(a);

MATCH (c:Customer {customerId: 'C004'}), (a:Account {accountId: 'A006'})
MERGE (c)-[:OWNS]->(a);

MATCH (c:Customer {customerId: 'C004'}), (a:Account {accountId: 'A007'})
MERGE (c)-[:OWNS]->(a);

MATCH (c:Customer {customerId: 'C004'}), (a:Account {accountId: 'A008'})
MERGE (c)-[:OWNS]->(a);

MATCH (c:Customer {customerId: 'C005'}), (a:Account {accountId: 'A009'})
MERGE (c)-[:OWNS]->(a);

MATCH (c:Customer {customerId: 'C005'}), (a:Account {accountId: 'A010'})
MERGE (c)-[:OWNS]->(a);

MATCH (c:Customer {customerId: 'C005'}), (a:Account {accountId: 'A011'})
MERGE (c)-[:OWNS]->(a);



// Link Accounts to Transactions
MATCH (a:Account {accountId: 'A001'}), (t:Transaction {transactionId: 'T001'})
MERGE (a)-[:CONDUCTS]->(t);

MATCH (a:Account {accountId: 'A002'}), (t:Transaction {transactionId: 'T002'})
MERGE (a)-[:CONDUCTS]->(t);

MATCH (a:Account {accountId: 'A003'}), (t:Transaction {transactionId: 'T003'})
MERGE (a)-[:CONDUCTS]->(t);

MATCH (a:Account {accountId: 'A004'}), (t:Transaction {transactionId: 'T004'})
MERGE (a)-[:CONDUCTS]->(t);

MATCH (a:Account {accountId: 'A005'}), (t:Transaction {transactionId: 'T005'})
MERGE (a)-[:CONDUCTS]->(t);

MATCH (a:Account {accountId: 'A006'}), (t:Transaction {transactionId: 'T006'})
MERGE (a)-[:CONDUCTS]->(t);

MATCH (a:Account {accountId: 'A007'}), (t:Transaction {transactionId: 'T007'})
MERGE (a)-[:CONDUCTS]->(t);

MATCH (a:Account {accountId: 'A008'}), (t:Transaction {transactionId: 'T008'})
MERGE (a)-[:CONDUCTS]->(t);

MATCH (a:Account {accountId: 'A009'}), (t:Transaction {transactionId: 'T009'})
MERGE (a)-[:CONDUCTS]->(t);

MATCH (a:Account {accountId: 'A010'}), (t:Transaction {transactionId: 'T010'})
MERGE (a)-[:CONDUCTS]->(t);

MATCH (a:Account {accountId: 'A011'}), (t:Transaction {transactionId: 'T011'})
MERGE (a)-[:CONDUCTS]->(t);

MATCH (a:Account {accountId: 'A003'}), (t:Transaction {transactionId: 'T012'})
MERGE (a)-[:CONDUCTS]->(t);

MATCH (a:Account {accountId: 'A004'}), (t:Transaction {transactionId: 'T013'})
MERGE (a)-[:CONDUCTS]->(t);


// Device performs transaction
MATCH (d:Device {deviceId: 'D001'}), (t:Transaction {transactionId: 'T001'})
MERGE (d)-[:PERFORMS]->(t);

MATCH (d:Device {deviceId: 'D002'}), (t:Transaction {transactionId: 'T002'})
MERGE (d)-[:PERFORMS]->(t);

MATCH (d:Device {deviceId: 'D007'}), (t:Transaction {transactionId: 'T002'})
MERGE (d)-[:PERFORMS]->(t);

MATCH (d:Device {deviceId: 'D008'}), (t:Transaction {transactionId: 'T002'})
MERGE (d)-[:PERFORMS]->(t);

MATCH (d:Device {deviceId: 'D003'}), (t:Transaction {transactionId: 'T003'})
MERGE (d)-[:PERFORMS]->(t);

MATCH (d:Device {deviceId: 'D003'}), (t:Transaction {transactionId: 'T012'})
MERGE (d)-[:PERFORMS]->(t);

MATCH (d:Device {deviceId: 'D005'}), (t:Transaction {transactionId: 'T004'})
MERGE (d)-[:PERFORMS]->(t);

MATCH (d:Device {deviceId: 'D005'}), (t:Transaction {transactionId: 'T005'})
MERGE (d)-[:PERFORMS]->(t);

MATCH (d:Device {deviceId: 'D004'}), (t:Transaction {transactionId: 'T006'})
MERGE (d)-[:PERFORMS]->(t);

MATCH (d:Device {deviceId: 'D005'}), (t:Transaction {transactionId: 'T007'})
MERGE (d)-[:PERFORMS]->(t);

MATCH (d:Device {deviceId: 'D004'}), (t:Transaction {transactionId: 'T008'})
MERGE (d)-[:PERFORMS]->(t);

MATCH (d:Device {deviceId: 'D004'}), (t:Transaction {transactionId: 'T013'})
MERGE (d)-[:PERFORMS]->(t);

MATCH (d:Device {deviceId: 'D006'}), (t:Transaction {transactionId: 'T009'})
MERGE (d)-[:PERFORMS]->(t);



// Link Transactions to Merchants
MATCH (t:Transaction {transactionId: 'T001'}), (m:Merchant {merchantId: 'M001'})
MERGE (t)-[:INVOLVES]->(m);

MATCH (t:Transaction {transactionId: 'T002'}), (m:Merchant {merchantId: 'M002'})
MERGE (t)-[:INVOLVES]->(m);

MATCH (t:Transaction {transactionId: 'T012'}), (m:Merchant {merchantId: 'M002'})
MERGE (t)-[:INVOLVES]->(m);

MATCH (t:Transaction {transactionId: 'T013'}), (m:Merchant {merchantId: 'M002'})
MERGE (t)-[:INVOLVES]->(m);

MATCH (t:Transaction {transactionId: 'T003'}), (m:Merchant {merchantId: 'M003'})
MERGE (t)-[:INVOLVES]->(m);

MATCH (t:Transaction {transactionId: 'T004'}), (m:Merchant {merchantId: 'M004'})
MERGE (t)-[:INVOLVES]->(m);

MATCH (t:Transaction {transactionId: 'T005'}), (m:Merchant {merchantId: 'M004'})
MERGE (t)-[:INVOLVES]->(m);

MATCH (t:Transaction {transactionId: 'T006'}), (m:Merchant {merchantId: 'M005'})
MERGE (t)-[:INVOLVES]->(m);

MATCH (t:Transaction {transactionId: 'T007'}), (m:Merchant {merchantId: 'M006'})
MERGE (t)-[:INVOLVES]->(m);

MATCH (t:Transaction {transactionId: 'T008'}), (m:Merchant {merchantId: 'M003'})
MERGE (t)-[:INVOLVES]->(m);

MATCH (t:Transaction {transactionId: 'T009'}), (m:Merchant {merchantId: 'M007'})
MERGE (t)-[:INVOLVES]->(m);

MATCH (t:Transaction {transactionId: 'T010'}), (m:Merchant {merchantId: 'M005'})
MERGE (t)-[:INVOLVES]->(m);

MATCH (t:Transaction {transactionId: 'T011'}), (m:Merchant {merchantId: 'M006'})
MERGE (t)-[:INVOLVES]->(m);
