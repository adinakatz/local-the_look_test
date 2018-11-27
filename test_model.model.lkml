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

  filter: test {
    group_label: "test label"
  }

  dimension: status {
    type: string
    html: <a href="location.href">link test</a> ;;
#     link: {
#       url: "&f['field]"
#       label: "link test"
#       }
    sql: ${TABLE}.status ;;
#     link: {
#       url: "/explore/test_model/orders_filter_test?fields=orders_filter_test.id&f[orders_filter_test.status_test]={{ value }}&f[orders_filter_test.id]={{ _filters['orders_filter_test.id'] }}"
#       label: "Test"
#     }
    required_fields: [status_test]
    can_filter: no

  }

  dimension: status_test {
#     label: "Status"
#     link: {
#     url: "/explore/test_model/orders_filter_test?fields=orders_filter_test.id&f[orders_filter_test.status_test]={{ value }}&f[orders_filter_test.id]={{ _filters['orders_filter_test.id'] }}"
#     label: "link test"
#     }
    type: string
    sql: ${TABLE}.status ;;
    drill_fields: [id]
}

  measure: test_html {
    html:
    {% assign words = {{value}} | split: ' ' %}
    {% assign numwords = 0 %}
    {% for word in words %}
    {{ word }}
    {% assign numwords = numwords | plus: 1 %}
    {% assign mod = numwords | modulo: 2 %}
    {% if mod == 0 %}
    <br>
    {% endif %}
    {% endfor %} ;;
    sql: "Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello";;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    group_label: "test label"
    type: count
    drill_fields: [id, users.first_name, users.last_name, users.id, order_items.count]
  }

  measure: count_id {
    group_label: "test label"
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

  dimension_group: duration_test {
    type: duration
    sql_start: ${created_raw} ;;
    sql_end: ${created_raw} ;;
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
