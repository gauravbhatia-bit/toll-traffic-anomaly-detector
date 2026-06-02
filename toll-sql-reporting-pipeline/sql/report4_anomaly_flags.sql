-- ============================================================
-- Report 4: Transaction Anomaly Flag Report
-- Author  : Gaurav Bhatia | gauravbhatia-bit
-- Engine  : PostgreSQL / DuckDB compatible
-- Techniques: CTE, STDDEV, Z-score, NULLIF, CASE WHEN severity
-- ============================================================

WITH segment_stats AS (
    -- Calculate baseline avg and stddev per segment + vehicle class
    SELECT
        t.segment_id,
        s.segment_name,
        v.vehicle_class,
        AVG(t.toll_amount)                      AS avg_toll,
        STDDEV(t.toll_amount)                   AS std_toll
    FROM toll_transactions t
    JOIN segments s ON t.segment_id = s.segment_id
    JOIN vehicles v ON t.vehicle_id = v.vehicle_id
    WHERE v.vehicle_class != 'PKW'
    GROUP BY
        t.segment_id,
        s.segment_name,
        v.vehicle_class
),

flagged AS (
    -- Flag transactions where Z-score exceeds threshold
    SELECT
        t.transaction_id,
        c.date,
        t.hour,
        s.segment_name,
        v.vehicle_class,
        v.registration,
        t.toll_amount,
        ss.avg_toll,
        ss.std_toll,
        ROUND(
            ((t.toll_amount - ss.avg_toll) / NULLIF(ss.std_toll, 0))::NUMERIC,
            2
        )                                       AS z_score
    FROM toll_transactions t
    JOIN vehicles      v  ON t.vehicle_id  = v.vehicle_id
    JOIN segments      s  ON t.segment_id  = s.segment_id
    JOIN calendar      c  ON t.date_id     = c.date_id
    JOIN segment_stats ss ON t.segment_id  = ss.segment_id
                          AND v.vehicle_class = ss.vehicle_class
    WHERE v.vehicle_class != 'PKW'
      AND ABS(
            (t.toll_amount - ss.avg_toll) / NULLIF(ss.std_toll, 0)
          ) > 2.5
)

SELECT
    *,
    CASE
        WHEN ABS(z_score) > 4 THEN 'CRITICAL'
        WHEN ABS(z_score) > 3 THEN 'HIGH'
        ELSE 'MEDIUM'
    END                                         AS flag_severity
FROM flagged
ORDER BY ABS(z_score) DESC
LIMIT 100;
