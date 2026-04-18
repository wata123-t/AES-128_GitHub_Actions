-- 全ビットが1回以上トグルしていないレコードがあれば「失敗」とみなす
SELECT
    bit_index,
    toggle_count
FROM {{ ref('fct_bit_toggles') }}
WHERE toggle_count = 0
