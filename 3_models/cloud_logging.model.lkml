# Define the database connection to be used for this model.
connection: "@{CONNECTION_NAME}"

# include all the views
include: "/2_views/**/*.view"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: cloud_logging_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: cloud_logging_default_datagroup

explore: _all_logs {

  always_filter: {
    # to reduce inadverent expensive queries, default all explore queries to last 1 day (today)
    filters: [_all_logs.timestamp_date: "last 1 days"]
  }

  # this is used for Searching across columns
  sql_always_where:
  {% if _all_logs.search_filter._in_query %}
  SEARCH(_all_logs,"`{% parameter _all_logs.search_filter %}`")
  {% else %}
  1=1
  {% endif %} ;;


  # Quick Start Queries

  query: all_logs_last_hour {
    description: "Show all logs for the last 1 hour"

    dimensions: [
      timestamp_time,
      severity,
      log_name,
      labels_string,
      proto_payload__request_log__resource  ]
    filters: [_all_logs.timestamp_time: "1 hours"]
    limit: 500
  }

  join: _all_logs__proto_payload__request_log__line {
    view_label: " All Logs: Proto Payload Request Log Line"
    sql: LEFT JOIN UNNEST(${_all_logs.proto_payload__request_log__line}) as _all_logs__proto_payload__request_log__line ;;
    relationship: one_to_many
  }

  join: _all_logs__proto_payload__audit_log__authorization_info {
    view_label: " All Logs: Proto Payload Audit Log Authorization Info"
    sql: LEFT JOIN UNNEST(${_all_logs.proto_payload__audit_log__authorization_info}) as _all_logs__proto_payload__audit_log__authorization_info ;;
    relationship: one_to_many
  }

  join: _all_logs__proto_payload__request_log__source_reference {
    view_label: " All Logs: Proto Payload Request Log Source Reference"
    sql: LEFT JOIN UNNEST(${_all_logs.proto_payload__request_log__source_reference}) as _all_logs__proto_payload__request_log__source_reference ;;
    relationship: one_to_many
  }

  join: _all_logs__proto_payload__audit_log__resource_location__current_locations {
    view_label: " All Logs: Proto Payload Audit Log Resource Location Current Locations"
    sql: LEFT JOIN UNNEST(${_all_logs.proto_payload__audit_log__resource_location__current_locations}) as _all_logs__proto_payload__audit_log__resource_location__current_locations ;;
    relationship: one_to_many
  }

  join: _all_logs__proto_payload__audit_log__resource_location__original_locations {
    view_label: " All Logs: Proto Payload Audit Log Resource Location Original Locations"
    sql: LEFT JOIN UNNEST(${_all_logs.proto_payload__audit_log__resource_location__original_locations}) as _all_logs__proto_payload__audit_log__resource_location__original_locations ;;
    relationship: one_to_many
  }

  join: _all_logs__proto_payload__audit_log__request_metadata__request_attributes__auth__audiences {
    view_label: " All Logs: Proto Payload Audit Log Request Metadata Request Attributes Auth Audiences"
    sql: LEFT JOIN UNNEST(${_all_logs.proto_payload__audit_log__request_metadata__request_attributes__auth__audiences}) as _all_logs__proto_payload__audit_log__request_metadata__request_attributes__auth__audiences ;;
    relationship: one_to_many
  }

  join: _all_logs__proto_payload__audit_log__request_metadata__request_attributes__auth__access_levels {
    view_label: " All Logs: Proto Payload Audit Log Request Metadata Request Attributes Auth Access Levels"
    sql: LEFT JOIN UNNEST(${_all_logs.proto_payload__audit_log__request_metadata__request_attributes__auth__access_levels}) as _all_logs__proto_payload__audit_log__request_metadata__request_attributes__auth__access_levels ;;
    relationship: one_to_many
  }

  join: _all_logs__proto_payload__audit_log__service_data__policy_delta__binding_deltas {
    view_label: " All Logs: Proto Payload Audit Log Service Data Policy Delta Binding Deltas"
    sql: LEFT JOIN UNNEST(JSON_QUERY_ARRAY(${_all_logs.proto_payload__audit_log__service_data__policy_delta__binding_deltas})) AS bindingDelta ;;
    relationship: one_to_many
  }

  join: _all_logs__proto_payload__audit_log__authentication_info__service_account_delegation_info {
    view_label: " All Logs: Proto Payload Audit Log Authentication Info Service Account Delegation Info"
    sql: LEFT JOIN UNNEST(${_all_logs.proto_payload__audit_log__authentication_info__service_account_delegation_info}) as _all_logs__proto_payload__audit_log__authentication_info__service_account_delegation_info ;;
    relationship: one_to_many
  }

  join: _all_logs__proto_payload__audit_log__policy_violation_info__org_policy_violation_info__violation_info {
    view_label: " All Logs: Proto Payload Audit Log Policy Violation Info Org Policy Violation Info Violation Info"
    sql: LEFT JOIN UNNEST(${_all_logs.proto_payload__audit_log__policy_violation_info__org_policy_violation_info__violation_info}) as _all_logs__proto_payload__audit_log__policy_violation_info__org_policy_violation_info__violation_info ;;
    relationship: one_to_many
  }
}
