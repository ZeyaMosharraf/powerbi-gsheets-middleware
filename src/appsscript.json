function doGet(e) {
  const props = PropertiesService.getScriptProperties();
  const cache = CacheService.getScriptCache();

  // ===============================
  // 1. READ CONFIG (SCRIPT PROPERTIES)
  // ===============================
  const AUTH_TOKEN = props.getProperty("AUTH_TOKEN");
  const SHEET_ID   = props.getProperty("SHEET_ID");
  const SHEET_NAME = props.getProperty("SHEET_NAME");

  // Default to 0-24 if properties aren't set, just to be safe
  const START_HOUR = Number(props.getProperty("REFRESH_START_HOUR")) || 0; 
  const END_HOUR   = Number(props.getProperty("REFRESH_END_HOUR")) || 24;   

  // ===============================
  // 2. AUTHENTICATION
  // ===============================
  const receivedToken = e?.parameter?.token ? e.parameter.token.trim() : null;

  if (!receivedToken || receivedToken !== AUTH_TOKEN) {
    return csvStatus("UNAUTHORIZED");
  }

  // ===============================
  // 3. REFRESH WINDOW CHECK
  // ===============================
  const tz = Session.getScriptTimeZone();
  const currentHour = Number(Utilities.formatDate(new Date(), tz, "H"));

  if (currentHour < START_HOUR || currentHour > END_HOUR) {
    return csvStatus("REFRESH_WINDOW_CLOSED");
  }

  // ===============================
  // 4. SMART THROTTLING (BURST ALLOWED)
  // ===============================
  // FIX: We use a counter now. 
  // Power BI needs to hit the URL 2-3 times rapidly to load data.
  // We allow 5 requests every 60 seconds before blocking.
  
  const throttleKey = "request_count_" + receivedToken;
  let requestCount = Number(cache.get(throttleKey)) || 0;

  if (requestCount >= 5) {
    return csvStatus("RATE_LIMITED_Try_Again_In_1_Min");
  }

  // ===============================
  // 5. DATA ACCESS
  // ===============================
  const ss = SpreadsheetApp.openById(SHEET_ID);
  const sh = ss.getSheetByName(SHEET_NAME);

  if (!sh) {
    return csvStatus("SHEET_NOT_FOUND");
  }

  const rows = sh.getDataRange().getValues();

  // ===============================
  // 6. SAFE CSV CONVERSION
  // ===============================
  const csv = rows
    .map(row =>
      row
        .map(value => {
          if (value instanceof Date) {
            return Utilities.formatDate(value, tz, "yyyy-MM-dd");
          }
          if (value === null || value === undefined) return "";
          
          // Escape quotes and handle commas
          const str = String(value).replace(/"/g, '""');
          return /[",\n]/.test(str) ? `"${str}"` : str;
        })
        .join(",")
    )
    .join("\n");

  // ===============================
  // 7. INCREMENT COUNTER & SERVE
  // ===============================
  // Count this as 1 successful request. Expires in 60 seconds.
  cache.put(throttleKey, String(requestCount + 1), 60); 

  return ContentService.createTextOutput(csv)
    .setMimeType(ContentService.MimeType.CSV);
}

// ===============================
// CSV STATUS RESPONSE (POWER BI SAFE)
// ===============================
function csvStatus(status) {
  // Returns a valid CSV format so Power BI doesn't crash, just shows the status
  return ContentService.createTextOutput("status\n" + status)
    .setMimeType(ContentService.MimeType.CSV);
}