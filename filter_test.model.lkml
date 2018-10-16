#testing to see if required_fields parameter works inside of a filter
#result: it does not

connection: "thelook"


explore:  orders {
  hidden: yes
}

view: orders {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
#     required_fields: [id]
  }

# #   filter: test_filter {
# #     type: number
# #     suggest_dimension: id
# #     required_fields: [id]
# #   }
}
