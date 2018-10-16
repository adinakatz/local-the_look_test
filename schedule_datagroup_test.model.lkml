connection: "thelook"



datagroup: test {
  max_cache_age: "24 hours"
  sql_trigger: SELECT max(id) FROM demo_db.orders ;;
}


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
  }

  }
