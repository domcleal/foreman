# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151109152507) do

  create_table "architectures", force: true do |t|
    t.string   "name",                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hosts_count",      default: 0
    t.integer  "hostgroups_count", default: 0
  end

  create_table "architectures_operatingsystems", id: false, force: true do |t|
    t.integer "architecture_id",    null: false
    t.integer "operatingsystem_id", null: false
  end

  create_table "audits", force: true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.string   "request_uuid"
    t.datetime "created_at"
    t.string   "remote_address"
    t.text     "auditable_name"
    t.string   "associated_name"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index"
  add_index "audits", ["associated_id", "associated_type"], name: "auditable_parent_index"
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index"
  add_index "audits", ["created_at"], name: "index_audits_on_created_at"
  add_index "audits", ["id"], name: "index_audits_on_id"
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid"
  add_index "audits", ["user_id", "user_type"], name: "user_index"

  create_table "auth_sources", force: true do |t|
    t.string   "type",              default: "",      null: false
    t.string   "name",              default: "",      null: false
    t.string   "host"
    t.integer  "port"
    t.string   "account"
    t.string   "account_password"
    t.string   "base_dn"
    t.string   "attr_login"
    t.string   "attr_firstname"
    t.string   "attr_lastname"
    t.string   "attr_mail"
    t.boolean  "onthefly_register", default: false,   null: false
    t.boolean  "tls",               default: false,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ldap_filter"
    t.string   "attr_photo"
    t.string   "server_type",       default: "posix"
    t.string   "groups_base"
    t.boolean  "usergroup_sync",    default: true,    null: false
  end

  create_table "bookmarks", force: true do |t|
    t.string  "name"
    t.text    "query"
    t.string  "controller"
    t.boolean "public"
    t.integer "owner_id"
    t.string  "owner_type"
  end

  add_index "bookmarks", ["controller"], name: "index_bookmarks_on_controller"
  add_index "bookmarks", ["name"], name: "index_bookmarks_on_name"
  add_index "bookmarks", ["owner_id", "owner_type"], name: "index_bookmarks_on_owner_id_and_owner_type"

  create_table "cached_user_roles", force: true do |t|
    t.integer  "user_id",      null: false
    t.integer  "role_id",      null: false
    t.integer  "user_role_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cached_user_roles", ["role_id"], name: "index_cached_user_roles_on_role_id"
  add_index "cached_user_roles", ["user_id"], name: "index_cached_user_roles_on_user_id"
  add_index "cached_user_roles", ["user_role_id"], name: "index_cached_user_roles_on_user_role_id"

  create_table "cached_usergroup_members", force: true do |t|
    t.integer  "user_id"
    t.integer  "usergroup_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cached_usergroup_members", ["user_id"], name: "index_cached_usergroup_members_on_user_id"
  add_index "cached_usergroup_members", ["usergroup_id"], name: "index_cached_usergroup_members_on_usergroup_id"

  create_table "compute_attributes", force: true do |t|
    t.integer  "compute_profile_id"
    t.integer  "compute_resource_id"
    t.string   "name"
    t.text     "vm_attrs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "compute_attributes", ["compute_profile_id"], name: "index_compute_attributes_on_compute_profile_id"
  add_index "compute_attributes", ["compute_resource_id"], name: "index_compute_attributes_on_compute_resource_id"

  create_table "compute_profiles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "compute_resources", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.string   "user"
    t.text     "password"
    t.string   "uuid"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "attrs"
  end

  create_table "config_group_classes", force: true do |t|
    t.integer  "puppetclass_id"
    t.integer  "config_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "config_groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hosts_count",                default: 0
    t.integer  "hostgroups_count",           default: 0
    t.integer  "config_group_classes_count", default: 0
  end

  create_table "domains", force: true do |t|
    t.string   "name",             default: "", null: false
    t.string   "fullname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dns_id"
    t.integer  "total_hosts",      default: 0
    t.integer  "hostgroups_count", default: 0
  end

  create_table "environment_classes", force: true do |t|
    t.integer "puppetclass_id",            null: false
    t.integer "environment_id",            null: false
    t.integer "puppetclass_lookup_key_id"
  end

  add_index "environment_classes", ["environment_id"], name: "index_environment_classes_on_environment_id"
  add_index "environment_classes", ["puppetclass_id"], name: "index_environment_classes_on_puppetclass_id"

  create_table "environments", force: true do |t|
    t.string   "name",                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hosts_count",      default: 0
    t.integer  "hostgroups_count", default: 0
  end

  create_table "external_usergroups", force: true do |t|
    t.string  "name",           null: false
    t.integer "auth_source_id", null: false
    t.integer "usergroup_id",   null: false
  end

  add_index "external_usergroups", ["usergroup_id"], name: "index_external_usergroups_on_usergroup_id"

  create_table "fact_names", force: true do |t|
    t.string   "name",                            null: false
    t.datetime "updated_at"
    t.datetime "created_at"
    t.boolean  "compose",    default: false,      null: false
    t.string   "short_name"
    t.string   "type",       default: "FactName"
    t.string   "ancestry"
  end

  add_index "fact_names", ["ancestry"], name: "index_fact_names_on_ancestry"
  add_index "fact_names", ["name", "type"], name: "index_fact_names_on_name_and_type", unique: true

  create_table "fact_values", force: true do |t|
    t.text     "value"
    t.integer  "fact_name_id", null: false
    t.integer  "host_id",      null: false
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "fact_values", ["fact_name_id", "host_id"], name: "index_fact_values_on_fact_name_id_and_host_id", unique: true
  add_index "fact_values", ["fact_name_id"], name: "index_fact_values_on_fact_name_id"
  add_index "fact_values", ["host_id"], name: "index_fact_values_on_host_id"

  create_table "features", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "features_smart_proxies", id: false, force: true do |t|
    t.integer "smart_proxy_id"
    t.integer "feature_id"
  end

  create_table "filterings", force: true do |t|
    t.integer  "filter_id"
    t.integer  "permission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "filterings", ["filter_id"], name: "index_filterings_on_filter_id"
  add_index "filterings", ["permission_id"], name: "index_filterings_on_permission_id"

  create_table "filters", force: true do |t|
    t.text     "search"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "taxonomy_search"
  end

  create_table "host_classes", force: true do |t|
    t.integer "puppetclass_id", null: false
    t.integer "host_id",        null: false
  end

  create_table "host_config_groups", force: true do |t|
    t.integer  "config_group_id"
    t.integer  "host_id"
    t.string   "host_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "host_status", force: true do |t|
    t.string   "type"
    t.integer  "status",      limit: 8, default: 0, null: false
    t.integer  "host_id",                           null: false
    t.datetime "reported_at",                       null: false
  end

  add_index "host_status", ["host_id"], name: "index_host_status_on_host_id"
  add_index "host_status", ["type", "host_id"], name: "index_host_status_on_type_and_host_id", unique: true

  create_table "hostgroup_classes", force: true do |t|
    t.integer "hostgroup_id",   null: false
    t.integer "puppetclass_id", null: false
  end

  add_index "hostgroup_classes", ["hostgroup_id"], name: "index_hostgroup_classes_on_hostgroup_id"
  add_index "hostgroup_classes", ["puppetclass_id"], name: "index_hostgroup_classes_on_puppetclass_id"

  create_table "hostgroups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "environment_id"
    t.integer  "operatingsystem_id"
    t.integer  "architecture_id"
    t.integer  "medium_id"
    t.integer  "ptable_id"
    t.string   "root_pass"
    t.integer  "puppet_ca_proxy_id"
    t.boolean  "use_image"
    t.string   "image_file",           limit: 128
    t.string   "ancestry"
    t.text     "vm_defaults"
    t.integer  "subnet_id"
    t.integer  "domain_id"
    t.integer  "puppet_proxy_id"
    t.string   "title"
    t.integer  "realm_id"
    t.integer  "compute_profile_id"
    t.string   "grub_pass",                        default: ""
    t.string   "lookup_value_matcher"
    t.integer  "hosts_count",                      default: 0
  end

  add_index "hostgroups", ["ancestry"], name: "index_hostgroups_on_ancestry"
  add_index "hostgroups", ["compute_profile_id"], name: "index_hostgroups_on_compute_profile_id"

  create_table "hosts", force: true do |t|
    t.string   "name",                                             null: false
    t.datetime "last_compile"
    t.datetime "last_report"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "root_pass"
    t.integer  "architecture_id"
    t.integer  "operatingsystem_id"
    t.integer  "environment_id"
    t.integer  "ptable_id"
    t.integer  "medium_id"
    t.boolean  "build",                            default: false
    t.text     "comment"
    t.text     "disk"
    t.datetime "installed_at"
    t.integer  "model_id"
    t.integer  "hostgroup_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.boolean  "enabled",                          default: true
    t.integer  "puppet_ca_proxy_id"
    t.boolean  "managed",                          default: false, null: false
    t.boolean  "use_image"
    t.string   "image_file",           limit: 128
    t.string   "uuid"
    t.integer  "compute_resource_id"
    t.integer  "puppet_proxy_id"
    t.string   "certname"
    t.integer  "image_id"
    t.integer  "organization_id"
    t.integer  "location_id"
    t.string   "type"
    t.string   "otp"
    t.integer  "realm_id"
    t.integer  "compute_profile_id"
    t.string   "provision_method"
    t.string   "grub_pass",                        default: ""
    t.integer  "global_status",                    default: 0,     null: false
    t.string   "lookup_value_matcher"
  end

  add_index "hosts", ["architecture_id"], name: "host_arch_id_ix"
  add_index "hosts", ["certname"], name: "index_hosts_on_certname"
  add_index "hosts", ["compute_profile_id"], name: "index_hosts_on_compute_profile_id"
  add_index "hosts", ["environment_id"], name: "host_env_id_ix"
  add_index "hosts", ["hostgroup_id"], name: "host_group_id_ix"
  add_index "hosts", ["installed_at"], name: "index_hosts_on_installed_at"
  add_index "hosts", ["last_report"], name: "index_hosts_on_last_report"
  add_index "hosts", ["medium_id"], name: "host_medium_id_ix"
  add_index "hosts", ["name"], name: "index_hosts_on_name"
  add_index "hosts", ["operatingsystem_id"], name: "host_os_id_ix"
  add_index "hosts", ["type"], name: "index_hosts_on_type"

  create_table "images", force: true do |t|
    t.integer  "operatingsystem_id"
    t.integer  "compute_resource_id"
    t.integer  "architecture_id"
    t.string   "uuid"
    t.string   "username"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "iam_role"
    t.boolean  "user_data",           default: false
    t.string   "password"
  end

  create_table "key_pairs", force: true do |t|
    t.text     "secret"
    t.integer  "compute_resource_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "public"
  end

  create_table "locations_organizations", id: false, force: true do |t|
    t.integer "location_id"
    t.integer "organization_id"
  end

  create_table "logs", force: true do |t|
    t.integer  "source_id"
    t.integer  "message_id"
    t.integer  "report_id"
    t.integer  "level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logs", ["level_id"], name: "index_logs_on_level_id"
  add_index "logs", ["message_id"], name: "index_logs_on_message_id"
  add_index "logs", ["report_id"], name: "index_logs_on_report_id"
  add_index "logs", ["source_id"], name: "index_logs_on_source_id"

  create_table "lookup_keys", force: true do |t|
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "puppetclass_id"
    t.text     "default_value"
    t.string   "path"
    t.text     "description"
    t.string   "validator_type"
    t.string   "validator_rule"
    t.string   "key_type"
    t.boolean  "override",            default: false
    t.boolean  "required",            default: false
    t.integer  "lookup_values_count", default: 0
    t.boolean  "merge_overrides"
    t.boolean  "avoid_duplicates"
    t.boolean  "use_puppet_default"
    t.string   "type"
    t.boolean  "merge_default",       default: false, null: false
    t.boolean  "hidden_value",        default: false
  end

  add_index "lookup_keys", ["key"], name: "index_lookup_keys_on_key"
  add_index "lookup_keys", ["path"], name: "index_lookup_keys_on_path"
  add_index "lookup_keys", ["puppetclass_id"], name: "index_lookup_keys_on_puppetclass_id"
  add_index "lookup_keys", ["type"], name: "index_lookup_keys_on_type"

  create_table "lookup_values", force: true do |t|
    t.string   "match"
    t.text     "value"
    t.integer  "lookup_key_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "use_puppet_default", default: false
  end

  add_index "lookup_values", ["match"], name: "index_lookup_values_on_match"

  create_table "mail_notifications", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "mailer"
    t.string   "method"
    t.boolean  "subscriptable",     default: true
    t.string   "default_interval"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subscription_type"
    t.boolean  "queryable",         default: false
  end

  create_table "media", force: true do |t|
    t.string   "name",        default: "", null: false
    t.string   "path",        default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "media_path"
    t.string   "config_path"
    t.string   "image_path"
    t.string   "os_family"
  end

  create_table "media_operatingsystems", id: false, force: true do |t|
    t.integer "medium_id",          null: false
    t.integer "operatingsystem_id", null: false
  end

  create_table "messages", force: true do |t|
    t.text   "value"
    t.string "digest"
  end

  add_index "messages", ["digest"], name: "index_messages_on_digest"

  create_table "models", force: true do |t|
    t.string   "name",                       null: false
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "vendor_class"
    t.string   "hardware_model"
    t.integer  "hosts_count",    default: 0
  end

  create_table "nics", force: true do |t|
    t.string   "mac"
    t.string   "ip"
    t.string   "type"
    t.string   "name"
    t.integer  "host_id"
    t.integer  "subnet_id"
    t.integer  "domain_id"
    t.text     "attrs"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "username"
    t.string   "password"
    t.boolean  "virtual",            default: false,        null: false
    t.boolean  "link",               default: true,         null: false
    t.string   "identifier"
    t.string   "tag",                default: "",           null: false
    t.string   "attached_to",        default: "",           null: false
    t.boolean  "managed",            default: true
    t.string   "mode",               default: "balance-rr", null: false
    t.string   "attached_devices",   default: "",           null: false
    t.string   "bond_options",       default: "",           null: false
    t.boolean  "primary",            default: false
    t.boolean  "provision",          default: false
    t.text     "compute_attributes"
  end

  add_index "nics", ["host_id"], name: "index_by_host"
  add_index "nics", ["type", "id"], name: "index_by_type_and_id"
  add_index "nics", ["type"], name: "index_by_type"

  create_table "operatingsystems", force: true do |t|
    t.string   "major",            limit: 5,  default: "",       null: false
    t.string   "name",                                           null: false
    t.string   "minor",            limit: 16, default: "",       null: false
    t.string   "nameindicator",    limit: 3
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "release_name"
    t.string   "type"
    t.text     "description"
    t.integer  "hosts_count",                 default: 0
    t.integer  "hostgroups_count",            default: 0
    t.string   "password_hash",               default: "SHA256"
    t.string   "title"
  end

  add_index "operatingsystems", ["name", "major", "minor"], name: "index_operatingsystems_on_name_and_major_and_minor", unique: true
  add_index "operatingsystems", ["title"], name: "index_operatingsystems_on_title", unique: true
  add_index "operatingsystems", ["type"], name: "index_operatingsystems_on_type"

  create_table "operatingsystems_provisioning_templates", id: false, force: true do |t|
    t.integer "provisioning_template_id", null: false
    t.integer "operatingsystem_id",       null: false
  end

  create_table "operatingsystems_ptables", id: false, force: true do |t|
    t.integer "ptable_id",          null: false
    t.integer "operatingsystem_id", null: false
  end

  create_table "operatingsystems_puppetclasses", id: false, force: true do |t|
    t.integer "puppetclass_id",     null: false
    t.integer "operatingsystem_id", null: false
  end

  create_table "os_default_templates", force: true do |t|
    t.integer  "provisioning_template_id"
    t.integer  "template_kind_id"
    t.integer  "operatingsystem_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parameters", force: true do |t|
    t.string   "name"
    t.text     "value"
    t.integer  "reference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "priority"
    t.boolean  "hidden_value", default: false
  end

  add_index "parameters", ["reference_id", "type"], name: "index_parameters_on_reference_id_and_type"
  add_index "parameters", ["type", "reference_id", "name"], name: "index_parameters_on_type_and_reference_id_and_name", unique: true
  add_index "parameters", ["type"], name: "index_parameters_on_type"

  create_table "permissions", force: true do |t|
    t.string   "name",          null: false
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["name", "resource_type"], name: "index_permissions_on_name_and_resource_type"

  create_table "puppetclasses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "total_hosts",                default: 0
    t.integer  "hostgroups_count",           default: 0
    t.integer  "global_class_params_count",  default: 0
    t.integer  "variable_lookup_keys_count", default: 0
  end

  add_index "puppetclasses", ["name"], name: "index_puppetclasses_on_name"

  create_table "realms", force: true do |t|
    t.string   "name",             default: "", null: false
    t.string   "realm_type"
    t.integer  "realm_proxy_id"
    t.integer  "hosts_count",      default: 0
    t.integer  "hostgroups_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "realms", ["name"], name: "index_realms_on_name", unique: true

  create_table "reports", force: true do |t|
    t.integer  "host_id",                                        null: false
    t.datetime "reported_at",                                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",      limit: 8
    t.text     "metrics"
    t.string   "type",                  default: "ConfigReport", null: false
  end

  add_index "reports", ["host_id"], name: "index_reports_on_host_id"
  add_index "reports", ["reported_at", "host_id"], name: "index_reports_on_reported_at_and_host_id"
  add_index "reports", ["reported_at"], name: "index_reports_on_reported_at"
  add_index "reports", ["status"], name: "index_reports_on_status"

  create_table "roles", force: true do |t|
    t.string  "name"
    t.integer "builtin"
    t.text    "permissions"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "settings", force: true do |t|
    t.string   "name"
    t.text     "value"
    t.text     "description"
    t.string   "category"
    t.string   "settings_type"
    t.text     "default",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
  end

  add_index "settings", ["category"], name: "index_settings_on_category"
  add_index "settings", ["name"], name: "index_settings_on_name", unique: true

  create_table "smart_proxies", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sources", force: true do |t|
    t.text   "value"
    t.string "digest"
  end

  add_index "sources", ["digest"], name: "index_sources_on_digest"

  create_table "subnet_domains", force: true do |t|
    t.integer  "domain_id"
    t.integer  "subnet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subnets", force: true do |t|
    t.string   "network",       limit: 15
    t.string   "mask",          limit: 15
    t.integer  "priority"
    t.text     "name"
    t.string   "vlanid",        limit: 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dhcp_id"
    t.integer  "tftp_id"
    t.string   "gateway"
    t.string   "dns_primary"
    t.string   "dns_secondary"
    t.string   "from"
    t.string   "to"
    t.integer  "dns_id"
    t.string   "boot_mode",                default: "DHCP", null: false
    t.string   "ipam",                     default: "DHCP", null: false
  end

  create_table "taxable_taxonomies", force: true do |t|
    t.integer  "taxonomy_id"
    t.integer  "taxable_id"
    t.string   "taxable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taxable_taxonomies", ["taxable_id", "taxable_type", "taxonomy_id"], name: "taxable_index"
  add_index "taxable_taxonomies", ["taxable_id", "taxable_type"], name: "index_taxable_taxonomies_on_taxable_id_and_taxable_type"
  add_index "taxable_taxonomies", ["taxonomy_id"], name: "index_taxable_taxonomies_on_taxonomy_id"

  create_table "taxonomies", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "ignore_types"
    t.string   "ancestry"
    t.string   "title"
    t.text     "description"
  end

  add_index "taxonomies", ["ancestry"], name: "index_taxonomies_on_ancestry"

  create_table "template_combinations", force: true do |t|
    t.integer  "provisioning_template_id"
    t.integer  "hostgroup_id"
    t.integer  "environment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "template_kinds", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "templates", force: true do |t|
    t.string   "name"
    t.text     "template"
    t.boolean  "snippet",          default: false,            null: false
    t.integer  "template_kind_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "locked",           default: false
    t.boolean  "default",          default: false
    t.string   "vendor"
    t.string   "type",             default: "ConfigTemplate"
    t.string   "os_family"
  end

  create_table "tokens", force: true do |t|
    t.string   "value"
    t.datetime "expires"
    t.integer  "host_id"
  end

  add_index "tokens", ["host_id"], name: "index_tokens_on_host_id", unique: true
  add_index "tokens", ["value"], name: "index_tokens_on_value"

  create_table "trend_counters", force: true do |t|
    t.integer  "trend_id"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "interval_start"
    t.datetime "interval_end"
  end

  add_index "trend_counters", ["trend_id"], name: "index_trend_counters_on_trend_id"

  create_table "trends", force: true do |t|
    t.string   "trendable_type"
    t.integer  "trendable_id"
    t.string   "name"
    t.string   "type"
    t.string   "fact_value"
    t.string   "fact_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trends", ["fact_value"], name: "index_trends_on_fact_value"
  add_index "trends", ["trendable_type", "trendable_id"], name: "index_trends_on_trendable_type_and_trendable_id"
  add_index "trends", ["type"], name: "index_trends_on_type"

  create_table "user_mail_notifications", force: true do |t|
    t.integer  "user_id"
    t.integer  "mail_notification_id"
    t.datetime "last_sent"
    t.string   "interval"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mail_query"
  end

  create_table "user_roles", force: true do |t|
    t.integer "owner_id",                    null: false
    t.integer "role_id"
    t.string  "owner_type", default: "User", null: false
  end

  add_index "user_roles", ["owner_id", "owner_type"], name: "index_user_roles_on_owner_id_and_owner_type"
  add_index "user_roles", ["owner_id"], name: "index_user_roles_on_owner_id"
  add_index "user_roles", ["owner_type"], name: "index_user_roles_on_owner_type"

  create_table "usergroup_members", force: true do |t|
    t.integer "member_id"
    t.string  "member_type"
    t.integer "usergroup_id"
  end

  create_table "usergroups", force: true do |t|
    t.string   "name",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",      default: false, null: false
  end

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "mail"
    t.boolean  "admin",                               default: false, null: false
    t.datetime "last_login_on"
    t.integer  "auth_source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_hash",           limit: 128
    t.string   "password_salt",           limit: 128
    t.string   "locale",                  limit: 5
    t.string   "avatar_hash",             limit: 128
    t.integer  "default_organization_id"
    t.integer  "default_location_id"
    t.string   "lower_login"
    t.boolean  "mail_enabled",                        default: true
    t.string   "timezone"
  end

  add_index "users", ["lower_login"], name: "index_users_on_lower_login", unique: true

  create_table "widgets", force: true do |t|
    t.integer  "user_id"
    t.string   "template",                   null: false
    t.string   "name",                       null: false
    t.text     "data"
    t.integer  "sizex",      default: 4
    t.integer  "sizey",      default: 1
    t.integer  "col",        default: 1
    t.integer  "row",        default: 1
    t.boolean  "hide",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "widgets", ["user_id"], name: "index_widgets_on_user_id"

end
