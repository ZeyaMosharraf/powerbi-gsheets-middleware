# 🚀 Power BI & Google Sheets Secure Middleware

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

### **The Problem**
Connecting Power BI directly to Google Sheets often leads to frustrated stakeholders due to **`429: Too Many Requests`** API errors, slow refreshes, and unsecured "anyone with the link" access constraints.

### **The Solution**
This project is an enterprise-grade middleware solution built on Google Apps Script. It acts as a secure, intelligent API gateway that sits between Power BI and raw Google Sheets data.

It handles authentication, manages API burst limits to prevent bans, and serializes data into clean CSV format for rapid ingestion into Power BI.

---

## **System Architecture**

![Architecture Diagram](./docs/architecture.png)

*The middleware manages the handshake between Power BI's requests and Google's API limits.*

---

## **Key Features**

✅ **Zero 429 Errors (Smart Throttling)**
Implements a "Burst Bucket" algorithm using Apps Script CacheService to handle Power BI's rapid preview+load requests without triggering Google's API rate limits.

🔐 **Token Authentication**
Replaces insecure direct sharing. Data is only accessible via a secure token passed in the URL parameters, validated against server-side script properties.

⚡ **High-Performance CSV Serialization**
Instead of sending heavy JSON, the middleware converts sheet data into streamlined CSV format, significantly reducing refresh times in Power BI.

🛡️ **Schema Safety**
Includes server-side sanitization to handle special characters, quotes, and null values, preventing CSV injection attacks and broken data loads.

---

## **🚀 Getting Started**

Ready to deploy this for your client or organization?

👉 **[Click here for the complete step-by-step Setup Guide](./docs/setup-guide.md)**

---

## **Project Structure**

```text
/
├── src/
│   ├── Code.gs            # The server-side Apps Script logic (Middleware engine)
│   └── appsscript.json    # Google project configuration and security manifest
│
├── power-query/
│   └── LoadData.m         # Client-side M Code for Power BI (Copy-paste ready)
│
├── docs/
│   ├── setup-guide.md     # Deployment instructions
│   └── architecture.png   # System diagram
│
└── LICENSE                # MIT open-source license