
select 
    id as payment_id
    , orderid as order_id
    , paymentmethod as payment_method
    , status
    , amount as amount_cents
    , {{ cents_to_dollars('amount') }} as amount_dollars
    , created as created_at
from {{ source('stripe', 'payments') }}