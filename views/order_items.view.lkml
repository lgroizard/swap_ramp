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

  dimension: is_returned {
    description: "Has the item been returned?"
    type: yesno
    sql: ${returned_raw} IS NOT NULL  ;;
  }

  measure: count_of_returned_items {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: is_returned
      value: "yes"
    }
  }

    dimension: days_until_return {
      type: number
      sql: datediff('day',${created_raw},${returned_raw}) ;;
    }

    dimension: is_wardrobed {
      type: yesno
      description: "Has the item been Wardrobed? i.e. returned within 28-30 days of purchase"
      sql: ${days_until_return} between 28 and 30 ;;
    }

    measure: count_of_wardrobed_items {
      type: count_distinct
      sql: ${id} ;;
      filters: {
        field: is_wardrobed
        value: "yes"
      }    }

   measure: sales_of_wardrobed_items {
     type: sum
    sql: ${sale_price} ;;
    filters: {
      field: is_wardrobed
      value: "yes"
    }
    value_format_name: usd
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
    sql: ${sale_price} ;;
    drill_fields: [id, order_id,user_id, users.name]
    value_format_name: usd
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      inventory_items.product_name,
      inventory_items.id,
      users.last_name,
      users.id,
      users.first_name
    ]
  }
}
