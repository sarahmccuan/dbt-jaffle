
with c as (
     select * from {{ ref('stg_jaffle_shop__customers') }}
)

, o as ( 
    select * from {{ ref('stg_jaffle_shop__orders') }}
)

, p as (
    select * from {{ ref('stg_stripe__payments') }}
)

, co as (
    select
        o.customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders
    from o
    group by 1
)

, order_payments as (
    select
    o.customer_id,
    --o.order_id,
    sum (case when p.status = 'success' then p.amount_dollars end) as amount
    from o 
    left join p using (order_id)
    group by 1
)

, final as (
    select
        c.customer_id,
        c.first_name,
        c.last_name,
        co.first_order_date,
        co.most_recent_order_date,
        coalesce (co.number_of_orders, 0) as number_of_orders,
        coalesce(order_payments.amount, 0) as lifetime_value
    from c
    left join co on c.customer_id = co.customer_id
    left join order_payments on c.customer_id = order_payments.customer_id

)

select * from final
