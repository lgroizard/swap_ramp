connection: "snowflake"
include: "/views/*.view.lkml"                # include all views in the views/ folder in this project


datagroup: swap_lucia_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: swap_lucia_default_datagroup


#Explore for Wardrobing: order_items, users, products, inventory_items

explore: order_items {
  label: "Orders, Products and Users"
  description: "Use this Explore for Wardrobing analysis"
  view_name: order_items

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }

  join: inventory_items {
    type: full_outer
    relationship: one_to_one
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
  }

  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }
}
