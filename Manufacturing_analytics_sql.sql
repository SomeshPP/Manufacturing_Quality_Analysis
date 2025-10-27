CREATE TABLE quality_defects (
    date TEXT,
    shift TEXT,
    machine_no TEXT,
    product_id TEXT,
    operator TEXT,
    qty_produced INTEGER,
    defects INTEGER,
    breakdown_min INTEGER,
    defect_pct DOUBLE PRECISION
);

select * from quality_defects

CREATE TABLE oee (
    date TEXT,
    shift TEXT,
    machine_no TEXT,
    product TEXT,
    operator TEXT,
    planned_time_min DOUBLE PRECISION,
    downtime_min DOUBLE PRECISION,
    qty_produced INTEGER,
    scrap INTEGER,
    standard_rate DOUBLE PRECISION,
    run_time_min DOUBLE PRECISION,
    availability DOUBLE PRECISION,
    performance DOUBLE PRECISION,
    quality DOUBLE PRECISION,
    oee DOUBLE PRECISION
);

select * from oee

CREATE TABLE inventory (
    date TEXT,
    product TEXT,
    warehouse TEXT,
    supplier TEXT,
    opening_stock INTEGER,
    inward INTEGER,
    outward INTEGER,
    closing_stock INTEGER,
    lead_time_days INTEGER,
    unit_cost DOUBLE PRECISION,
    total_value DOUBLE PRECISION
);

select * from inventory

--Top 5 machines by defect percentage
SELECT machine_no, round(AVG(defect_pct)::numeric,2) AS avg_defect_pct
FROM quality_defects
GROUP BY machine_no
ORDER BY avg_defect_pct DESC
LIMIT 5;

--Top 5 machines by OEE
SELECT machine_no, ROUND(AVG(oee)::numeric,2) AS avg_oee
FROM oee
GROUP BY machine_no
ORDER BY avg_oee DESC
LIMIT 5;

--Machines with high defects & low OEE
SELECT o.machine_no,
       AVG(o.oee) as avg_oee,
       AVG(q.defect_pct) as avg_defect_pct
FROM oee o
JOIN quality_defects q ON o.machine_no = q.machine_no
GROUP BY o.machine_no
ORDER BY avg_defect_pct DESC
LIMIT 10;

--Top 10 inventory items by total value
SELECT product, SUM(total_value) AS total_value
FROM inventory
GROUP BY product
ORDER BY total_value DESC
LIMIT 10;