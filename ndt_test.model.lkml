## test: reference one NDT in another NDT where both NDTs are built off the same source explore and both joined
##        to the source exploe.
## results: error that isn't thrown in noral PDT example

connection: "thelook"


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

  measure: status_c {
    type: string
    sql: group_concat(DISTINCT ${status}) ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.first_name, users.last_name, users.id, order_items.count]
  }
}


explore: orders {
#   hidden: yes

  ## NDT JOINS:

  join: ndt_1 {
    sql_on: ${orders.id} = ${ndt_1.id} ;;
    relationship: one_to_one
  }

  join: ndt_2 {
    sql_on: ${orders.id} = ${ndt_2.id} ;;
    relationship: one_to_one
  }

  ## PDT JOINS

  join: pdt_1 {
    sql_on: ${orders.id} = ${pdt_1.id} ;;
    relationship: one_to_one
  }

  join: pdt_2 {
    sql_on: ${orders.id} = ${pdt_2.id} ;;
    relationship: one_to_one
  }
}


##### NDT VIEWS: #####

## NDT 1 VIEW:
view: ndt_1 {
  derived_table: {
    explore_source: orders {
      column: created_date {}
      column: id {}
      column: status {}
    }
  }
  dimension: created_date {
    type: date
  }
  dimension: id {
    type: number
    primary_key: yes
  }
  dimension: status {}
}

## NDT 2 VIEW:
view: ndt_2 {
  derived_table: {
    explore_source: orders {
      column: created_date {}
      column: id {}
      column: status {}
    }
  }
  dimension: created_date {
    type: date
  }
  dimension: id {
    type: number
    primary_key: yes
  }
  dimension: status {
    sql: ${ndt_1.status} ;;
  }
}


##### NDT EXPLORES: #####

## NDT 1 EXPLORE:
# explore: ndt_1 {
#   hidden: yes
#   join: ndt_2 {
#     sql_on: ${ndt_1.id} = ${ndt_2.id} ;;
#   }
# }

## NDT 2 EXPLORE:
# explore:ndt_2 {
#   hidden: yes
#   join: ndt_1 {
#     sql_on: ${ndt_1.id} = ${ndt_2.id} ;;
#   }
# }


##### PDT VIEWS: #####

## PDT VIEW 1:
view: pdt_1 {
  derived_table: {
    sql:
      SELECT
        DATE(orders.created_at ) AS created_date,
        orders.id  AS id,
        orders.status  AS status
      FROM demo_db.orders  AS orders ;;
  }
  dimension: created_date {
    type: date
    sql: ${TABLE}.created_date ;;
  }
  dimension: id {
    type: number
    primary_key: yes
    sql: ${TABLE}.id ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }
}

## PDT VIEW 2:
view: pdt_2 {
  derived_table: {
    sql:
      SELECT
        DATE(orders.created_at ) AS created_date,
        orders.id  AS id,
        orders.status  AS status
      FROM demo_db.orders  AS orders ;;
  }
  dimension: created_date {
    type: date
    sql: ${TABLE}.created_date ;;
  }
  dimension: id {
    type: number
    primary_key: yes
    sql: ${TABLE}.id ;;
  }
  dimension: status {
    sql: CASE WHEN ${TABLE}.status = ${pdt_1.status} THEN ${TABLE}.status
          ELSE ${TABLE}.status
          END
          ;;
  }
}


##### PDT EXPLORES: #####

## PDT 1 EXPLORE:
# explore: pdt_1 {
# #   hidden: yes
# }

## PDT 2 EXPLORE:
# explore: pdt_2 {
# #   hidden: yes
# }
