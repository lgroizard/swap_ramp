view: order_user_sequence {

# Compute the order's sequence over the users lifetime.  Is this the first, second, third, etc.

derived_table: {
  sql: SELECT order_id as order_id,
  ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY created_at) as user_order_sequence_number
  FROM ecomm.order_items ;;
  }

dimension: order_id {
  primary_key: yes
  type: number
  sql: ${TABLE}.order_id ;;
}

dimension: user_order_sequence_number {
  type: number
  sql: ${TABLE}.user_order_sequence_number ;;
}

dimension: is_first_purchase {
  description: "Is this the customer's first purchase?"
  type: yesno
  sql: ${user_order_sequence_number} = 1 ;;
}

}
# view: customer_order_sequence {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
