
-- Q1
SELECT wh_addr_id AS addr_id
FROM warehouse

INTERSECT

SELECT cstmr_addr_id AS addr_id
FROM customer
WHERE cstmr_secondary_contact IS NULL

ORDER BY addr_id;

-- Q2
SELECT DISTINCT litm_inv_id AS inv_id
FROM line_item
WHERE litm_quantity BETWEEN 15 AND 25
ORDER BY inv_id;

-- Q3
SELECT cstmr_primary_contact AS cntct_id
FROM customer
WHERE cstmr_addr_id BETWEEN 5 AND 10

UNION

SELECT cstmr_secondary_contact AS cntct_id
FROM customer
WHERE cstmr_addr_id BETWEEN 5 AND 10
    AND cstmr_secondary_contact IS NOT NULL
ORDER BY cntct_id;

-- Q4
SELECT cstmr_primary_contact AS cntct_id
FROM customer

INTERSECT

SELECT cstmr_secondary_contact AS cntct_id
FROM customer

ORDER BY cntct_id DESC;

-- Q5
SELECT litm_inv_id AS inv_id, SUM(litm_quantity) AS total_quantity
FROM line_item
GROUP BY litm_inv_id
HAVING total_quantity >= 50
ORDER BY inv_id;


-- Q6
SELECT inv_id, 
        COUNT(*) AS line_item_count,
        SUM(itm_unit_price * litm_quantity) AS total_cost
FROM invoice, line_item, item
WHERE inv_id = litm_inv_id
    AND litm_itm_id = itm_id
    AND inv_payment_status_cd IN ('UNP', 'DEF')
GROUP BY inv_id
HAVING litm_quantity >= 2
ORDER BY total_cost DESC;

-- Q7
SELECT DISTINCT c1.cstmr_primary_contact AS cntct_id
FROM customer AS c1, customer AS c2
WHERE c1.cstmr_primary_contact = c2.cstmr_secondary_contact
    AND c1.cstmr_id != c2.cstmr_id
ORDER BY cntct_id;

-- Q8
SELECT c.cstmr_id
FROM customer AS c, address AS a, contact AS cn1, contact AS cn2
WHERE c.cstmr_addr_id = a.addr_id
    AND cstmr_primary_contact = cn1.cntct_id
    AND cn2.cntct_id = COALESCE(
        c.cstmr_primary_contact,
        c.cstmr_secondary_contact
    )
    AND (a.addr_state = 'PA'
        OR(cn1.cntct_phone_number IS NULL
            AND cn2.cntct_phone_number IS NULL
        )
    )
ORDER BY c.cstmr_id;

-- Q9
SELECT cs.cstmr_id, a.addr_state, 
        SUM(it.itm_unit_price * li.litm_quantity) AS total_cost
FROM customer AS cs, contact AS cn, invoice AS iv, 
        address AS a, line_item AS li, item AS it
WHERE cs.cstmr_addr_id = a.addr_id
    AND cs.cstmr_primary_contact = cn.cntct_id
    AND iv.inv_cstmr_id = cs.cstmr_id
    AND li.litm_inv_id = iv.inv_id
    AND li.litm_itm_id = it.itm_id
    AND cn.cntct_firstname LIKE 'Jess%'
GROUP BY cs.cstmr_id, a.addr_state
ORDER BY cs.cstmr_id;

-- Q10
SELECT cn.cntct_firstname, cn.cntct_lastname
FROM contact AS cn, customer AS cs, invoice AS iv
WHERE cs.cstmr_id = iv.inv_cstmr_id
    AND cs.cstmr_primary_contact = cn.cntct_id
    AND iv.inv_payment_status_cd = 'UNP'
    AND julianday('now') - julianday(iv.inv_date) > 730
GROUP BY cn.cntct_id, cn.cntct_firstname, cn.cntct_lastname
ORDER BY cn.cntct_id;

-- Q11
SELECT cntct_id
FROM contacts 

EXCEPT

SELECT cstmr_primary_contact
FROM customer

EXCEPT

SELECT cstmr_secondary_contact
FROM customer
ORDER BY cntct_id;

-- Q12
SELECT DISTINCT c.cstmr_id, a.addr_state. w.wh_id
FROM customer AS c, warehouse AS w,
    address AS ca, address AS wa,
    invoice AS iv, line_item AS li, stock AS s
WHERE c.cstmr_id = iv.inv_cstmr_id
    AND iv.inv_payment_status_cd = 'UNP'
    AND iv.inv_id = li.litm_inv_id
    AND li.litm_itm_id = s.stk_itm_id
    AND s.stk_wh_id = w.wh_id
    AND s.stk_quantity > 0
    AND w.wh_addr_id = wa.addr_id
    AND c.cstmr_addr_id = ca.addr_id
    AND wa.addr_state = ca.addr_state
ORDER BY c.cstmr_id, w.wh_id;

-- Q13


-- Q14


-- Q15


-- Q16


-- Q17


-- Q18


-- Q19


-- Q20


-- Q21


-- Q22


-- Q23


-- Q24


-- Q25