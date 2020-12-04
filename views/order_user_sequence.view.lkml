view: order_user_sequence {
  derived_table: {
    sql: SELECT

              order_id AS order_id

              , RANK() OVER(PARTITION BY user_id ORDER BY created_at) as user_order_sequence_number

            FROM ecomm.order_items
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: user_order_sequence_number {
    type: number
    sql: ${TABLE}."USER_ORDER_SEQUENCE_NUMBER" ;;
  }

  dimension: is_first_purchase {
    type: yesno
    sql: ${user_order_sequence_number} = 1 ;;
  }

  set: detail {
    fields: [order_id, user_order_sequence_number]
  }
}
