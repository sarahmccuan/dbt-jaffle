
select 
    o.order_id
    , o.customer_id
    , sum(p.amount_dollars) as amount_paid

from {{ ref('stg_jaffle_shop__orders') }} as o 
left join {{ ref('stg_stripe__payments') }} as p on o.order_id = p.order_id

group by 1,2 

