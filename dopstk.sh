#!/bin/zsh
command=$1
option=$2
argument=$3
#echo $command
function_name=$(echo "$command" | tr '-' '_')
#echo $function_name
create_module(){
#  echo "create module invoked with $option and $argument"
  githubrepoprefix="gh:igw2014/dataops.infra.prov.template."
  template=$githubrepoprefix$argument
#  echo $template
# implement exception handling to show error message if cookiecutter is not installed
# also show message how to install cooke cutter
  cookiecutter "$template"
}
setup_sample_database(){
  action=$(echo "$argument" | tr '-' '_')
  case $action in
    "create_db") cdktf deploy database-infra-stack;;
    "create_sample_schema") python3 data_migration_resource_manager.py --command create-sample-schema;;
    "install_db_prerequisites") python3 data_migration_resource_manager.py --command install-db-prerequisites;;
    "install_db_extensions") python3 data_migration_resource_manager.py --command install-db-extensions;;
    "load_sample_data") python3 data_migration_resource_manager.py --command load-sample-data;;
    *) exit ;;
  esac
}

allow_database_access(){
  python3 data_migration_resource_manager.py --command allow-db-access
}

get_db_details(){
  python3 data_migration_resource_manager.py --command get-db-details
}

deploy_data_migration_infra(){
  cdktf deploy data-migration-infra-stack
}

case $function_name in
    "create_module") create_module "$option" "$argument";;
    "setup_sample_database") setup_sample_database "$option" "$argument";;
    "allow_database_access") allow_database_access "$option" "$argument";;
    "get_db_details") get_db_details "$option" "$argument";;
    "deploy_data_migration_infra") deploy_data_migration_infra "$option" "$argument";;
    *) exit ;;
esac

