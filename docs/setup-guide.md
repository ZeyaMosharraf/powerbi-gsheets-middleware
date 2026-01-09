# 🛠️ Deployment & Setup Guide

This guide explains how to deploy the Google Apps Script middleware and connect it to Power BI.

## **Prerequisites**
* A Google Account (Gmail or Workspace).
* A target Google Sheet containing your data.
* Power BI Desktop installed.

---

## **Phase 1: Google Apps Script Setup**

1.  **Create the Script**
    * Open your Google Sheet.
    * Go to **Extensions > Apps Script**.
    * Rename the project to `PowerBI-Connector-Middleware`.

2.  **Install the Engine**
    * Copy the code from [`src/Code.gs`](../src/Code.gs) in this repository.
    * Paste it into the script editor, replacing any existing code.

3.  **Configure Secrets (Crucial Step)**
    * In the Apps Script editor, go to **Project Settings** (Gear Icon ⚙️ on the left).
    * Scroll down to **Script Properties**.
    * Click **Add script property** and add the following key-value pairs:

    | Property | Value |
    | :--- | :--- |
    | `SHEET_ID` | The ID found in your Google Sheet URL (between `/d/` and `/edit`). |
    | `SHEET_NAME` | The exact name of the tab (e.g., `Sheet1` or `Data`). |
    | `AUTH_TOKEN` | Create a strong password/token (e.g., `MySecretToken2026`). |
    | `REFRESH_START_HOUR` | (Optional) Start hour for refresh window (0-23). Default `0`. |
    | `REFRESH_END_HOUR` | (Optional) End hour for refresh window (0-23). Default `24`. |

4.  **Save** the properties.

---

## **Phase 2: Deploy as Web App**

1.  Click the blue **Deploy** button (top right) > **New deployment**.
2.  Click the **Select type** gear icon > **Web app**.
3.  Configure the settings exactly like this:
    * **Description:** `v1 - Production`
    * **Execute as:** `Me` (Important: This allows the script to see your private sheet).
    * **Who has access:** `Anyone` (Important: This allows Power BI to connect without a login popup).
4.  Click **Deploy**.
5.  **Copy the Web App URL** (It ends with `/exec`). You will need this for Power BI.

> **Note:** If you update the code later, you must create a **New Version** when deploying, or the changes won't go live.

---

## **Phase 3: Connect Power BI**

1.  Open Power BI Desktop.
2.  Go to **Home > Get Data > Blank Query**.
3.  Open the **Advanced Editor**.
4.  Copy the M-Code from [`power-query/LoadData.m`](../power-query/LoadData.m) in this repository.
5.  Paste it into the editor.
6.  Update the configuration variables at the top of the script:
    ```powerquery
    WebAppUrl = "YOUR_WEB_APP_URL_FROM_PHASE_2",
    Token = "YOUR_AUTH_TOKEN_FROM_PHASE_1",
    ```
7.  Click **Done**.

### **Verification**
If successful, you should see your Google Sheet data appear in the preview window. If you see a `RATE_LIMITED` error, wait 60 seconds and click **Refresh Preview**.

---

## **Troubleshooting**

| Error | Cause | Fix |
| :--- | :--- | :--- |
| **401 UNAUTHORIZED** | The token in Power BI doesn't match the Script Property. | Check `AUTH_TOKEN` in Project Settings. |
| **SHEET_NOT_FOUND** | The Sheet ID or Name is incorrect. | Verify `SHEET_ID` and `SHEET_NAME` properties. |
| **Data is Old/Static** | You didn't deploy a "New Version". | Go to Deploy > Manage Deployments > Edit > New Version. |