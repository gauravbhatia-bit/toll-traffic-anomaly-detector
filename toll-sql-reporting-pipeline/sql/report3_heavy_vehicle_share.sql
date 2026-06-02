-- ============================================================
-- Report 3: Heavy Vehicle Share & Revenue Contribution
-- Author  : Gaurav Bhatia | gauravbhatia-bit
-- Engine  : PostgreSQL / DuckDB / MySQL compatible
-- Techniques: CTE x2, JOIN x3, LIKE, percentage calculation
-- ============================================================

WITH base AS (
    SELECT
        c.month_name,
        c.month,
        s.segment_name,
        CASE
            WHEN v.vehicle_class LIKE 'LKW%' THEN 'Heavy'
            ELSE 'Light/Other'
        END                                     AS vehicle_type,
        COUNT(t.transaction_id)                 AS transactions,
        ROUND(SUM(t.toll_amount)::NUMERIC, 2)   AS revenue
    FROM toll_transactions t
    JOIN vehicles v ON t.vehicle_id = v.vehicle_id
    JOIN segments s ON t.segment_id = s.segment_id
    JOIN calendar c ON t.date_id    = c.date_id
    GROUP BY
        c.month_name,
        c.month,
        s.segment_name,
        vehicle_type
),

totals AS (
    SELECT
        month_name,
        month,
        segment_name,
        SUM(transactions)   AS total_tx,
        SUM(revenue)        AS total_rev
    FROM base
    GROUP BY
        month_name,
        month,
        segment_name
)

SELECT
    b.month_name,
    b.segment_name,
    b.vehicle_type,
    SUM(b.transactions)                                         AS transactions,
    ROUND((SUM(b.transactions) * 100.0 / t.total_tx)::NUMERIC, 1)  AS pct_of_traffic,
    ROUND(SUM(b.revenue)::NUMERIC, 2)                           AS revenue,
    ROUND((SUM(b.revenue) * 100.0 / t.total_rev)::NUMERIC, 1)  AS pct_of_revenue
FROM base b
JOIN totals t
    ON b.month_name    = t.month_name
    AND b.segment_name = t.segment_name
GROUP BY
    b.month_name,
    b.month,
    b.segment_name,
    b.vehicle_type,
    t.total_tx,
    t.total_rev
ORDER BY
    b.month,
    b.segment_name,
    b.vehicle_type;
