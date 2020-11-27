view: ad_events {
  sql_table_name: "ECOMM"."AD_EVENTS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}."AMOUNT" ;;
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

  dimension: device_type {
    type: string
    sql: ${TABLE}."DEVICE_TYPE" ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}."EVENT_TYPE" ;;
  }

  dimension: keyword_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."KEYWORD_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, keywords.criterion_name, keywords.keyword_id, events.count]
  }
}
