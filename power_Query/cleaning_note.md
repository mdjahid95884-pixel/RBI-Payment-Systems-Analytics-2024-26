# Data Cleaning Notes

## Source
- Source: RBI Payment System Data
- Original source data coverage: 2020–2026
- Analysis period selected: April 2024 – August 2026
- Reason: The project focuses on the most recent and consistently available period selected for analysis.
- Number of monthly datasets used: 29

## Power Query Transformations

1. Combined the selected monthly sheets into one master dataset.
2. Removed unnecessary metadata/header rows.
3. Promoted the correct header row.
4. Standardized column names.
5. Removed unnecessary columns.
6. Appended all selected monthly data into one master table.

## Python Cleaning

1. Converted the Date column to datetime format.
2. Removed non-transaction rows such as `Total` and `Note` rows.
3. Converted payment Volume and Value columns to numeric data types.
4. Converted source marker `h` to `NaN`.
5. Investigated missing values by payment system and date.
6. Retained legitimate `NaN` values instead of automatically replacing them with zero.
7. Checked for duplicate records.
8. Checked for negative values.
9. Verified the final date range.

## Data Quality Checks

- Final rows: 868
- Final columns: 43
- Duplicate rows: 0
- Negative values: 0
- Final analysis period: 2024-04-01 to 2026-08-16
- Missing values: Investigated and retained where appropriate.

## Scope Note

The original RBI source contains data covering multiple years, including 2020–2026. 
For this project, only the period from April 2024 to August 2026 was selected for analysis.
