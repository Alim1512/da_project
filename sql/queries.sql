
-- Топ-10 контрагентов по обороту с рангом
SELECT
    sender_id,
    COUNT(*) AS tx_count,
    SUM(amount_kzt) AS total_amount,
    AVG(amount_kzt) AS avg_amount,
    RANK() OVER (ORDER BY SUM(amount_kzt) DESC) AS rank
FROM transactions_clean
GROUP BY sender_id
ORDER BY total_amount DESC
LIMIT 10;

-- Ежемесячная динамика с накопленным итогом
SELECT
    strftime('%Y-%m', date_clean) AS month,
    COUNT(*) AS tx_count,
    SUM(amount_kzt) AS monthly_sum,
    SUM(SUM(amount_kzt)) OVER (ORDER BY strftime('%Y-%m', date_clean)) AS cumulative_sum
FROM transactions_clean
WHERE date_clean IS NOT NULL
GROUP BY month
ORDER BY month;

-- Аномальные транзакции (отклонение от среднего отправителя > 10x)
SELECT
    sender_id,
    receiver_id,
    date_clean,
    amount_kzt,
    AVG(amount_kzt) OVER (PARTITION BY sender_id) AS sender_avg,
    amount_kzt / AVG(amount_kzt) OVER (PARTITION BY sender_id) AS deviation_ratio
FROM transactions_clean
WHERE amount_kzt > 0
ORDER BY deviation_ratio DESC
LIMIT 10;

-- Скользящее среднее за 3 транзакции по каждому отправителю
SELECT
    sender_id,
    date_clean,
    amount_kzt,
    AVG(amount_kzt) OVER (
        PARTITION BY sender_id
        ORDER BY date_clean
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3
FROM transactions_clean
ORDER BY sender_id, date_clean
LIMIT 20;
