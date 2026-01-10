let
    // --------------------------------------------------------
    // CONFIGURATION
    // --------------------------------------------------------
    // Replace these text strings with your actual Web App URL and Token.
    // OR: Create Parameters in Power BI named 'WebconnectorLink' and 'connectorkey'
    WebconnectorLink = "YOUR_DEPLOYED_WEB_APP_URL_HERE",
    connectorkey     = "YOUR_SECURE_TOKEN_HERE",

    // --------------------------------------------------------
    // DATA FETCH (Securely passes token via Query Parameters)
    // --------------------------------------------------------
    Source = Web.Contents(
        WebconnectorLink,
        [
            Query = [ token = connectorkey ]
        ]
    ),

    // --------------------------------------------------------
    // TRANSFORMATION
    // --------------------------------------------------------
    Csv = Csv.Document(Source, [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Out = Table.PromoteHeaders(Csv, [PromoteAllScalars = true])
in 
    Out