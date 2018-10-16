# testing how to use a datagroup to schedule a dashboard
# conclusion: datagroup needs to be defined inside the model or defined in a .lkml file and included in the model file

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
