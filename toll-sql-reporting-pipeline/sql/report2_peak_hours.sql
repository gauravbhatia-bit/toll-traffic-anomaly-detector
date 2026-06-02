-- ============================================================
-- Report 2: Peak Hour Traffic Analysis per Segment
-- Author  : Gaurav Bhatia | gauravbhatia-bit
-- Engine  : PostgreSQL / DuckDB / MySQL compatible
-- Techniques: CTE, CASE WHEN, RANK() window function
-- ============================================================

WITH hourly_stats AS (
    SELECT
        s.segment_name,
        t.hour,
        COUNT(t.transaction_id)             AS transactions,
        ROUND(SUM(t.toll_amount)::NUMERIC, 2) AS revenue,
        CASE
            WHEN t.hour BETWEEN 7  AND 9  THEN 'Morning Rush'
            WHEN t.hour BETWEEN 17 AND 19 THEN 'Evening Rush'
            WHEN t.hour >= 22 OR t.hour <= 5 THEN 'Night'
            ELSE 'Off-Peak'
        END AS time_category
    FROM toll_transactions t
    JOIN segments s ON t.segment_id = s.segment_id
    GROUP BY
        s.segment_name,
        t.hour
),

ranked AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY segment_name
            ORDER BY transactions DESC
        ) AS hour_rank
    FROM hourly_stats
)

SELECT
    segment_name,
    hour,
    time_category,
    transactions,
    revenue,
    hour_rank
FROM ranked
ORDER BY
    segment_name,
    hour;
