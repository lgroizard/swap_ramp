view: order_items {
  sql_table_name: "ECOMM"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: days_until_return {
    type: number
    sql: datediff('day',${created_raw},${returned_raw}) ;;
  }

  dimension: is_returned {
    description: "Has the item been returned?"
    type: yesno
    sql: ${returned_raw} IS NOT NULL ;;
  }

  dimension: is_wardobed {
    description: "Has the item been wardrobed?"
    type: yesno
    sql: ${days_until_return} between 28 and 30 ;;
}

measure: count_of_wardrobed_items {
  type:  count_distinct
  sql: ${id} ;;
  filters: [is_wardobed: "yes"]
 }

measure: wardrobing_rate {
  description: "What % of items have been wardrobed?"
  type: number
  sql: ${count_of_wardrobed_items} / ${count} ;;
  value_format_name: percent_1
}

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_sale_price {
    type: sum
    drill_fields: [id, order_id, created_date]
    sql: ${sale_price} ;;
    value_format_name: usd_0
  }

  measure: count_of_first_orders {
    type: count_distinct
    sql: ${order_id}  ;;
    filters: [order_user_sequence.is_first_purchase: "Yes"]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      inventory_items.id,
      inventory_items.product_name,
      users.last_name,
      users.first_name,
      users.id
    ]
  }
}
