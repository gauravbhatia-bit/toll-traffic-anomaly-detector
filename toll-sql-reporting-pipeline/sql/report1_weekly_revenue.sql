-- ============================================================
-- Report 1: Weekly Revenue by Segment & Vehicle Class
-- Author  : Gaurav Bhatia | gauravbhatia-bit
-- Engine  : PostgreSQL / DuckDB / MySQL compatible
-- ============================================================

SELECT
    c.week_number                               AS week,
    c.month_name                                AS month,
    s.segment_name                              AS segment,
    s.toll_zone                                 AS zone,
    v.vehicle_class                             AS vehicle_class,
    COUNT(t.transaction_id)                     AS total_transactions,
    ROUND(SUM(t.toll_amount)::NUMERIC, 2)       AS total_revenue_eur,
    ROUND(AVG(t.toll_amount)::NUMERIC, 4)       AS avg_toll_eur
FROM toll_transactions t
JOIN vehicles v ON t.vehicle_id = v.vehicle_id
JOIN segments s ON t.segment_id = s.segment_id
JOIN calendar c ON t.date_id    = c.date_id
GROUP BY
    c.week_number,
    c.month_name,
    s.segment_name,
    s.toll_zone,
    v.vehicle_class
ORDER BY
    c.week_number,
    total_revenue_eur DESC;
