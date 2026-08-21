let
    // Load RBI Payment System workbook
    Source = Excel.Workbook(
    File.Contents("C:\Users\zakir\Downloads\Rbi_paymentdata.xlsx"),
    null,
    true
),

    // Monthly sheets selected for this project
    MonthSheets = {
        "April 2024",
        "May 2024",
        "June 2024",
        "July 2024",
        "August 2024",
        "September 2024",
        "October 2024",
        "November 2024",
        "December 2024",
        "January 2025",
        "February 2025",
        "March 2025",
        "April 2025",
        "May 2025",
        "June 2025",
        "July 2025",
        "August 2025",
        "September 2025",
        "October 2025",
        "November 2025",
        "December 2025",
        "January 2026",
        "February 2026",
        "March 2026",
        "April 2026",
        "May 2026",
        "June 2026",
        "July 2026",
        "August 2026"
    },

    // Keep only the selected monthly worksheets
    Sheets = Table.SelectRows(
        Source,
        each [Kind] = "Sheet"
            and List.Contains(MonthSheets, [Item])
    ),

    // Function to clean and standardize each monthly sheet
    CleanMonth = (SheetData as table, SheetName as text) as table =>
        let

            // Remove unnecessary rows above the actual headers
            SkipTop = Table.Skip(SheetData, 4),

            // Promote the correct header row
            PromoteHeaders = Table.PromoteHeaders(
                SkipTop,
                [PromoteAllScalars = true]
            ),

            // Standardize column names
            RenameColumns = Table.RenameColumns(
                PromoteHeaders,
                {
                    {"Column1", "Date"},
                    {"RTGS", "RTGS_Vol"},
                    {"Column3", "RTGS_Val"},
                    {"NEFT", "NEFT_Vol"},
                    {"Column5", "NEFT_Val"},
                    {"AePS", "AePS_Vol"},
                    {"Column7", "AePS_Val"},
                    {"UPI", "UPI_Vol"},
                    {"Column9", "UPI_Val"},
                    {"IMPS", "IMPS_Vol"},
                    {"Column11", "IMPS_Val"},

                    {"NACH Credit", "NACH_Credit_Vol"},
                    {"Column13", "NACH_Credit_Val"},
                    {"NACH Debit", "NACH_Debit_Vol"},
                    {"Column15", "NACH_Debit_Val"},

                    {"NETC", "NETC_Vol"},
                    {"Column17", "NETC_Val"},
                    {"BBPS", "BBPS_Vol"},
                    {"Column19", "BBPS_Val"},

                    {"CTS", "CTS_Vol"},
                    {"Column21", "CTS_Val"},

                    {"Credit Card", "CreditCard_POS_Vol"},
                    {"Column23", "CreditCard_POS_Val"},

                    {"Debit Card", "DebitCard_POS_Vol"},
                    {"Column27", "DebitCard_POS_Val"},

                    {"Column24", "CreditCard_Ecommerce_Vol"},
                    {"Column25", "CreditCard_Ecommerce_Val"},

                    {"Column28", "DebitCard_Ecommerce_Vol"},
                    {"Column29", "DebitCard_Ecommerce_Val"},

                    {"Prepaid Payment Instruments (PPIs) Card", "PPI_POS_Vol"},
                    {"Column31", "PPI_POS_Val"},

                    {"Column32", "PPI_Ecommerce_Vol"},
                    {"Column33", "PPI_Ecommerce_Val"},

                    {"NFS (through ATMs)", "NFS_ATM_Vol"},
                    {"Column35", "NFS_ATM_Val"},

                    {"AePS (through micro-ATMs / BCs)", "AePS_microATM_Vol"},
                    {"Column37", "AePS_microATM_Val"},

                    {"Government Securities Clearing",
                        "Government_Securities_Clearing_Vol"},
                    {"Column39",
                        "Government_Securities_Clearing_Val"},

                    {"Forex Clearing", "Forex_Clearing_Vol"},
                    {"Column41", "Forex_Clearing_Val"},

                    {"Rupee Derivatives (for all deals matched during the day)",
                        "Rupee_Derivatives_Vol"},
                    {"Column43", "Rupee_Derivatives_Val"}
                },
                MissingField.Ignore
            ),

            // Remove unnecessary columns
            RemoveExtraColumns = Table.RemoveColumns(
                RenameColumns,
                {
                    "Column44",
                    "Column45",
                    "Column46",
                    "Column47",
                    "Column48",
                    "Column49",
                    "Column50"
                },
                MissingField.Ignore
            ),

            // Remove additional rows below the headers
            RemoveHeaderRows = Table.Skip(
                RemoveExtraColumns,
                2
            ),

            // Add month/source identifier
            AddMonth = Table.AddColumn(
                RemoveHeaderRows,
                "Month",
                each SheetName,
                type text
            )

        in
            AddMonth,

    // Apply cleaning function to every monthly sheet
    CleanedTables = Table.AddColumn(
        Sheets,
        "CleanedData",
        each CleanMonth([Data], [Item])
    ),

    // Combine all monthly datasets
    MasterTable = Table.Combine(
        CleanedTables[CleanedData]
    )

in
    MasterTable
