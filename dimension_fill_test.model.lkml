## test if a filter will specify the range for dimension fill
## results: it works!!!!!


connection: "thelook"


explore:  orders {
   hidden: yes
}

view: orders {
  derived_table: {
    sql:  SELECT id, status, created_at FROM demo_db.orders
          WHERE extract(year from created_at) <= 2015 ;;

  }

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

  dimension: created_at {
    type: date
    sql: ${TABLE}.created_at ;;
  }

}
