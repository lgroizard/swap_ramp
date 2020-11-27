view: campaigns {
  sql_table_name: "ECOMM"."CAMPAIGNS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: advertising_channel {
    type: string
    sql: ${TABLE}."ADVERTISING_CHANNEL" ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}."AMOUNT" ;;
  }

  dimension: bid_type {
    type: string
    sql: ${TABLE}."BID_TYPE" ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}."CAMPAIGN_NAME" ;;
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

  dimension: period {
    type: string
    sql: ${TABLE}."PERIOD" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, campaign_name, ad_groups.count]
  }
}
