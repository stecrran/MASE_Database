
**************************************************
1. Detect customers with shared contact details                   **possible duplicate identities**.
**************************************************
MATCH (c1:Customer), (c2:Customer)
WHERE c1.customerId <> c2.customerId AND (c1.email = c2.email OR c1.phone = c2.phone)
RETURN c1.name AS Customer1, c2.name AS Customer2, c1.email AS Email, c1.phone AS Phone;

╒═════════╤═════════╤══════════════════╤════════════╕
│Customer1│Customer2│Email             │Phone       │
╞═════════╪═════════╪══════════════════╪════════════╡
│"Sophia" │"Jane"   │"sophia@gmail.com"│"0854327887"│
├─────────┼─────────┼──────────────────┼────────────┤
│"Jane"   │"Sophia" │"jane@gmail.com"  │"0854327887"│
└─────────┴─────────┴──────────────────┴────────────┘



**************************************************
2. Identify customers with transactions using multiple devices.
**************************************************
//links a customer to their account, to the device that uses the account, and finally to the devices used for those transactions
MATCH (c:Customer)-[:OWNS]->(:Account)-[:CONDUCTS]->(t:Transaction)<-[:PERFORMS]-(d:Device)
WITH c, COUNT(DISTINCT d) AS deviceCount
WHERE deviceCount > 1
RETURN c.name AS Customer, deviceCount AS NumberOfDevices;

╒════════╤═══════════════╕
│Customer│NumberOfDevices│
╞════════╪═══════════════╡
│"Áine"  │3              │
├────────┼───────────────┤
│"Sophia"│2              │
└────────┴───────────────┘


**************************************************
3. Identify customers with multiple accounts.
**************************************************
MATCH (c:Customer)-[:OWNS]->(a:Account)
WITH c, COUNT(a) AS accountCount
WHERE accountCount > 1
RETURN c.name AS Customer, accountCount AS NumberOfAccounts;

╒════════╤════════════════╕
│Customer│NumberOfAccounts│
╞════════╪════════════════╡
│"Sophia"│5               │
└────────┴────────────────┘

**************************************************
4. Find customers with unusually high transaction amounts.
**************************************************
MATCH (c:Customer)-[:OWNS]->(a:Account)-[:CONDUCTS]->(t:Transaction)
WHERE t.amount > 2000
RETURN 
  c.name AS CustomerName, 
  a.accountId AS Account, 
  t.transactionId AS TransactionId,
  t.amount AS TransactionAmount, 
  t.timestamp AS Time, 
  t.location AS Location;
╒════════════╤═══════╤═════════════════╤═════════════════════╤═════════╕
│CustomerName│Account│TransactionAmount│Time                 │Location │
╞════════════╪═══════╪═════════════════╪═════════════════════╪═════════╡
│"Áine"      │"A002" │2800             │"2024-11-15T10:30:00"│"Athlone"│
└────────────┴───────┴─────────────────┴─────────────────────┴─────────┘


//5 find customers who uses savings account which is unusual for daily shopping

MATCH (c:Customer)-[:OWNS]->(a:Account {accountType: 'Savings'})-[:CONDUCTS]->(t:Transaction)-[:INVOLVES]->(m:Merchant)
RETURN 
  c.name AS CustomerName,
  a.accountId AS SavingsAccountID,
  t.transactionId AS TransactionID,
  t.amount AS TransactionAmount,
  t.timestamp AS TransactionTimestamp,
  m.name AS MerchantName;

╒════════════╤════════════════╤═════════════╤═════════════════╤═════════════════════╤═══════════════╕
│CustomerName│SavingsAccountID│TransactionID│TransactionAmount│TransactionTimestamp │MerchantName   │
╞════════════╪════════════════╪═════════════╪═════════════════╪═════════════════════╪═══════════════╡
│"Sophia"    │"A004"          │"T004"       │80               │"2024-11-16T15:45:00"│"Harvey Norman"│
├────────────┼────────────────┼─────────────┼─────────────────┼─────────────────────┼───────────────┤
│"Sophia"    │"A004"          │"T013"       │2500             │"2024-11-15T12:30:00"│"XYZ"          │
├────────────┼────────────────┼─────────────┼─────────────────┼─────────────────────┼───────────────┤
│"Jane"      │"A009"          │"T009"       │1                │"2024-11-17T08:40:00"│"Toastbox Café"│
├────────────┼────────────────┼─────────────┼─────────────────┼─────────────────────┼───────────────┤
│"Jane"      │"A010"          │"T010"       │5                │"2024-11-17T08:45:00"│"Shoe Factory" │
├────────────┼────────────────┼─────────────┼─────────────────┼─────────────────────┼───────────────┤
│"Jane"      │"A011"          │"T011"       │2                │"2024-11-17T09:40:00"│"H Samuel"     │
└────────────┴────────────────┴─────────────┴─────────────────┴─────────────────────┴───────────────┘



**************************************************
6. Highlight merchants with frequent high-value transactions. 
**************************************************
MATCH (m:Merchant)<-[:INVOLVES]-(t:Transaction)
WHERE t.amount > 500
RETURN m.name AS Merchant, COUNT(t) AS HighValueTransactionCount
ORDER BY HighValueTransactionCount DESC;

╒════════╤═════════════════════════╕
│Merchant│HighValueTransactionCount│
╞════════╪═════════════════════════╡
│"XYZ"   │3                        │
└────────┴─────────────────────────┘


//7 find details about the high value transaction at "XYZ"

MATCH (c:Customer)-[:OWNS]->(:Account)-[:CONDUCTS]->(t:Transaction)-[:INVOLVES]->(m:Merchant {name: 'XYZ'})
RETURN 
  c.name AS CustomerName, 
  t.transactionId AS TransactionID, 
  t.amount AS AmountSpent, 
  t.timestamp AS TransactionTimestamp, 
  m.name AS MerchantName;


╒════════════╤═════════════╤═══════════╤═════════════════════╤════════════╕
│CustomerName│TransactionID│AmountSpent│TransactionTimestamp │MerchantName│
╞════════════╪═════════════╪═══════════╪═════════════════════╪════════════╡
│"Áine"      │"T002"       │2800       │"2024-11-15T10:30:00"│"XYZ"       │
├────────────┼─────────────┼───────────┼─────────────────────┼────────────┤
│"John"      │"T012"       │2200       │"2024-11-15T11:30:00"│"XYZ"       │
├────────────┼─────────────┼───────────┼─────────────────────┼────────────┤
│"Sophia"    │"T013"       │2500       │"2024-11-15T12:30:00"│"XYZ"       │
└────────────┴─────────────┴───────────┴─────────────────────┴────────────┘



**************************************************
8. Detect transactions involving the same IP address but are in differnt locations.  
**************************************************
MATCH (d:Device)-[:PERFORMS]->(t1:Transaction),
      (d)-[:PERFORMS]->(t2:Transaction)
WHERE t1.transactionId < t2.transactionId
  AND d.ipAddress IS NOT NULL
  AND t1.location <> t2.location
RETURN 
  d.ipAddress AS IPAddress, 
  t1.transactionId AS TransactionID1,
  t2.transactionId AS TransactionID2,
  t1.location AS Location1, 
  t2.location AS Location2, 
  t1.timestamp AS Time1, 
  t2.timestamp AS Time2;

╒══════════════╤══════════════╤══════════════╤═══════════╤═══════════╤═════════════════════╤═════════════════════╕
│IPAddress     │TransactionID1│TransactionID2│Location1  │Location2  │Time1                │Time2                │
╞══════════════╪══════════════╪══════════════╪═══════════╪═══════════╪═════════════════════╪═════════════════════╡
│"203.0.113.50"│"T006"        │"T008"        │"Longford" │"Athlone"  │"2024-11-16T15:50:00"│"2024-11-16T17:05:00"│
├──────────────┼──────────────┼──────────────┼───────────┼───────────┼─────────────────────┼─────────────────────┤
│"203.0.113.51"│"T004"        │"T005"        │"Limerick" │"Waterford"│"2024-11-16T15:45:00"│"2024-11-16T15:46:00"│
├──────────────┼──────────────┼──────────────┼───────────┼───────────┼─────────────────────┼─────────────────────┤
│"203.0.113.51"│"T004"        │"T007"        │"Limerick" │"Dublin"   │"2024-11-16T15:45:00"│"2024-11-16T16:10:00"│
├──────────────┼──────────────┼──────────────┼───────────┼───────────┼─────────────────────┼─────────────────────┤
│"203.0.113.51"│"T005"        │"T007"        │"Waterford"│"Dublin"   │"2024-11-16T15:46:00"│"2024-11-16T16:10:00"│
└──────────────┴──────────────┴──────────────┴───────────┴───────────┴─────────────────────┴─────────────────────┘


// 9. **************************************************
Check for devices performing transactions from suspicious IPs.                                       **To search for IPs used by proxy networks, bot traffic, or blacklisted IPs**
**************************************************
MATCH (d:Device)-[:PERFORMS]->(t:Transaction)<-[:CONDUCTS]-(a:Account)<-[:OWNS]-(c:Customer)
WHERE d.ipAddress STARTS WITH '203.0.113'
RETURN 
  c.name AS CustomerName,
  d.deviceId AS Device, 
  d.ipAddress AS IPAddress, 
  t.transactionId AS Transaction, 
  t.location AS Location, 
  t.timestamp AS Time;

╒════════════╤══════╤══════════════╤═══════════╤═══════════╤═════════════════════╕
│CustomerName│Device│IPAddress     │Transaction│Location   │Time                 │
╞════════════╪══════╪══════════════╪═══════════╪═══════════╪═════════════════════╡
│"Áine"      │"D002"│"203.0.113.42"│"T002"     │"Athlone"  │"2024-11-15T10:30:00"│
├────────────┼──────┼──────────────┼───────────┼───────────┼─────────────────────┤
│"Sophia"    │"D004"│"203.0.113.50"│"T006"     │"Longford" │"2024-11-16T15:50:00"│
├────────────┼──────┼──────────────┼───────────┼───────────┼─────────────────────┤
│"Sophia"    │"D004"│"203.0.113.50"│"T008"     │"Athlone"  │"2024-11-16T17:05:00"│
├────────────┼──────┼──────────────┼───────────┼───────────┼─────────────────────┤
│"Sophia"    │"D005"│"203.0.113.51"│"T004"     │"Limerick" │"2024-11-16T15:45:00"│
├────────────┼──────┼──────────────┼───────────┼───────────┼─────────────────────┤
│"Sophia"    │"D005"│"203.0.113.51"│"T005"     │"Waterford"│"2024-11-16T15:46:00"│
├────────────┼──────┼──────────────┼───────────┼───────────┼─────────────────────┤
│"Sophia"    │"D005"│"203.0.113.51"│"T007"     │"Dublin"   │"2024-11-16T16:10:00"│






**************************************************
10. Identify devices performing unusually high transaction counts within a short timeframe
**************************************************
MATCH (d:Device)-[:PERFORMS]->(t:Transaction)
WITH d, COUNT(t) AS transactionCount, MIN(t.timestamp) AS startTime, MAX(t.timestamp) AS endTime
WHERE duration.between(datetime(startTime), datetime(endTime)).hours <= 1 AND transactionCount >= 3
RETURN d.deviceId AS Device, transactionCount AS NumberOfTransactions, startTime AS StartTime, endTime AS EndTime;     

╒══════╤════════════════════╤═════════════════════╤═════════════════════╕
│Device│NumberOfTransactions│StartTime            │EndTime              │
╞══════╪════════════════════╪═════════════════════╪═════════════════════╡
│"D005"│3                   │"2024-11-16T15:45:00"│"2024-11-16T16:10:00"│
└──────┴────────────────────┴─────────────────────┴─────────────────────┘


**************************************************
11. Detect transactions that happen within a short period of time at different locations using the same device
**************************************************
MATCH (t1:Transaction)-[:PERFORMS]-(d:Device),
      (t2:Transaction)-[:PERFORMS]-(d)
WHERE t1.transactionId < t2.transactionId  // not <> to avoid duplicated results
  AND ABS(duration.between(datetime(t1.timestamp), datetime(t2.timestamp)).minutes) <= 15
  AND t1.location <> t2.location 
RETURN d.deviceId AS Device, t1.location AS Location1, t2.location AS Location2, t1.timestamp AS Time1, t2.timestamp AS Time2;

╒══════╤══════════╤═══════════╤═════════════════════╤═════════════════════╕
│Device│Location1 │Location2  │Time1                │Time2                │
╞══════╪══════════╪═══════════╪═════════════════════╪═════════════════════╡
│"D005"│"Limerick"│"Waterford"│"2024-11-16T15:45:00"│"2024-11-16T15:46:00"│
└──────┴──────────┴───────────┴─────────────────────┴─────────────────────┘


//12 Find who owns Device D005 
MATCH (c:Customer)-[:OWNS]->(:Account)-[:CONDUCTS]->(t:Transaction)<-[:PERFORMS]-(d:Device {deviceId: 'D005'})
RETURN 
  c.name AS CustomerName, 
  d.deviceId AS Device, 
  t.transactionId AS TransactionId;

  ╒════════════╤══════╤═════════════╕
│CustomerName│Device│TransactionId│
╞════════════╪══════╪═════════════╡
│"Sophia"    │"D005"│"T004"       │
├────────────┼──────┼─────────────┤
│"Sophia"    │"D005"│"T005"       │
├────────────┼──────┼─────────────┤
│"Sophia"    │"D005"│"T007"       │
└────────────┴──────┴─────────────┘


**************************************************
13. Identify accounts accessed by multiple devices in a short period
**************************************************
//Collects all unique device IDs that accessed the account via transactions
//more than one unique device accessed the account
MATCH (c:Customer)-[:OWNS]->(a:Account)-[:CONDUCTS]->(t:Transaction)<-[:PERFORMS]-(d:Device)
WITH c, a, COLLECT(DISTINCT d.deviceId) AS devices, MIN(t.timestamp) AS startTime, MAX(t.timestamp) AS endTime
WHERE SIZE(devices) > 1 AND duration.between(datetime(startTime), datetime(endTime)).hours <= 1
RETURN c.name AS Customer, a.accountId AS Account, devices AS AccessingDevices, startTime AS StartTime, endTime AS EndTime;           
╒════════╤═══════╤════════════════════════╤═════════════════════╤═════════════════════╕
│Customer│Account│AccessingDevices        │StartTime            │EndTime              │
╞════════╪═══════╪════════════════════════╪═════════════════════╪═════════════════════╡
│"Áine"  │"A002" │["D002", "D007", "D008"]│"2024-11-15T10:30:00"│"2024-11-15T10:30:00"│
└────────┴───────┴────────────────────────┴─────────────────────┴─────────────────────┘


//14 find accountid that does muliple transactions in multiple merchants paying less than 10 euros within 3 hours

MATCH (c:Customer)-[:OWNS]->(a:Account)-[:CONDUCTS]->(t:Transaction)-[:INVOLVES]->(m:Merchant)
WHERE t.amount < 10
WITH c, a, t, m, MIN(t.timestamp) AS startTime, MAX(t.timestamp) AS endTime
WHERE duration.between(datetime(startTime), datetime(endTime)).hours <= 3
RETURN 
  c.name AS CustomerName,
  a.accountId AS AccountID,
  t.transactionId AS TransactionID,
  m.name AS MerchantName,
  t.amount AS TransactionAmount,
  t.timestamp AS TransactionTime;

╒════════════╤═════════╤═════════════╤═══════════════╤═════════════════╤═════════════════════╕
│CustomerName│AccountID│TransactionID│MerchantName   │TransactionAmount│TransactionTime      │
╞════════════╪═════════╪═════════════╪═══════════════╪═════════════════╪═════════════════════╡
│"Jane"      │"A009"   │"T009"       │"Toastbox Café"│1                │"2024-11-17T08:40:00"│
├────────────┼─────────┼─────────────┼───────────────┼─────────────────┼─────────────────────┤
│"Jane"      │"A010"   │"T010"       │"Shoe Factory" │5                │"2024-11-17T08:45:00"│
├────────────┼─────────┼─────────────┼───────────────┼─────────────────┼─────────────────────┤
│"Jane"      │"A011"   │"T011"       │"H Samuel"     │2                │"2024-11-17T09:40:00"│
└────────────┴─────────┴─────────────┴───────────────┴─────────────────┴─────────────────────┘




// 15 show all information about John -- perhpas merchant XYZ is innocent

MATCH (c:Customer {name: 'John'})-[:OWNS]->(a:Account)
OPTIONAL MATCH (a)-[:CONDUCTS]->(t:Transaction)-[:INVOLVES]->(m:Merchant)
OPTIONAL MATCH (t)<-[:PERFORMS]-(d:Device)
RETURN 
  c.name AS CustomerName,
  a.accountId AS AccountID,
  t.transactionId AS TransactionID,
  t.amount AS TransactionAmount,
  t.timestamp AS TransactionTimestamp,
  t.location AS TransactionLocation,
  m.name AS MerchantName,
  d.deviceId AS DeviceID,
  d.type AS DeviceType,
  d.ipAddress AS DeviceIPAddress;

  ╒════════════╤═════════╤═════════════╤═════════════════╤═════════════════════╤═══════════════════╤════════════╤════════╤══════════╤═══════════════╕
│CustomerName│AccountID│TransactionID│TransactionAmount│TransactionTimestamp │TransactionLocation│MerchantName│DeviceID│DeviceType│DeviceIPAddress│
╞════════════╪═════════╪═════════════╪═════════════════╪═════════════════════╪═══════════════════╪════════════╪════════╪══════════╪═══════════════╡
│"John"      │"A003"   │"T003"       │13               │"2024-11-16T12:00:00"│"Galway"           │"Zara"      │"D003"  │"Tablet"  │"192.168.2.10" │
├────────────┼─────────┼─────────────┼─────────────────┼─────────────────────┼───────────────────┼────────────┼────────┼──────────┼───────────────┤
│"John"      │"A003"   │"T012"       │2200             │"2024-11-15T11:30:00"│"Athlone"          │"XYZ"       │"D003"  │"Tablet"  │"192.168.2.10" │





















// duplicated with above
**************************************************
12. Identify potential account sharing or compromise.
**************************************************                                                                             ***No results**
MATCH (a:Account)-[:CONDUCTS]->(t:Transaction)<-[:PERFORMS]-(d:Device)
WITH a, COUNT(DISTINCT d) AS deviceCount
WHERE deviceCount > 1
RETURN a.accountId AS Account, deviceCount AS NumberOfDevices;
╒═══════╤═══════════════╕
│Account│NumberOfDevices│
╞═══════╪═══════════════╡
│"A002" │3              │
└───────┴───────────────┘
