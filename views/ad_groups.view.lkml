view: ad_groups {
  sql_table_name: "ECOMM"."AD_GROUPS"
    ;;

  dimension: ad_id {
    type: number
    sql: ${TABLE}."AD_ID" ;;
  }

  dimension: ad_type {
    type: string
    sql: ${TABLE}."AD_TYPE" ;;
  }

  dimension: campaign_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."CAMPAIGN_ID" ;;
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

  dimension: headline {
    type: string
    sql: ${TABLE}."HEADLINE" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: period {
    type: number
    sql: ${TABLE}."PERIOD" ;;
  }

  measure: count {
    type: count
    drill_fields: [name, campaigns.id, campaigns.campaign_name]
  }
}
