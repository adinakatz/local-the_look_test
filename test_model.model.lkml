connection: "thelook"


view: orders_2 {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
}

view: orders {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.first_name, users.last_name, users.id, order_items.count]
  }

  measure: count_id {
    type: count_distinct
    sql: ${id} ;;
  }

  measure: percent_of_total {
    type: percent_of_total
    sql: ${count_id} ;;
  }

  dimension: test_liquid_in_sql {
    type: string
#     html: {{orders.id._value}} ;;
    sql: CASE WHEN ${id} = ${id} THEN concat("https://wikipedia.com/",${id})
    ELSE 'No link'
    END;;
  }

  dimension: liquid_link_test {
    html: {{id._value}} ;;
    link: {
      label: "Please work"
      url: "{{test_liquid_in_sql._value}}"
      }
      sql: ${id} ;;
  }
}

# explore: orders {
#   join: orders_2 {
#     sql_on: ${orders.id} = ${orders_2.id} ;;
#     relationship: one_to_one
#   }
# }

explore: orders_filter_test {
  from: orders
  label: "Test"
}
