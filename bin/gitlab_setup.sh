#!/bin/bash

############################################################
# Help
############################################################
Help() {
   # Display Help
   echo "Automate setup and teardown of the Gitlab Snyk Tutorial"
   echo
   echo "Syntax: gitlab_setup.sh [-h|--help|-c|--create|-d|--delete]"
   echo "options:"
   echo "-h, --help     Print this help"
   echo "-c, --create   Create the gitlab instance"
   echo "-d, --delete   Delete and clean up gitlab setup"
}

createHelp () {
  # Help for the --create command
  echo "You can pass options into the --create command"
  echo ""
  echo "Syntax: --create [-h|--help|--project-name|--project-id]"
  echo "-h,--help      Print this help"
  echo "--project-name Project name used by Google Cloud"
  echo "--project-id   Project ID used by Google Cloud"
}

checkConfig () {
  gcloud --version
  gcloud_exit=$(echo $?)
  if [ "$gcloud_exit" != "0" ]; then
    exit [1]
  fi
  kubectl
  if [ echo $? != "0" ]; then
    echo "kubectl command failed. Confirm a valid kubectl CLI is installed and configured"
    break
  fi
  helm
  if [ echo $? != "0" ]; then
    echo "kubectl command failed. Confirm a valid kubectl CLI is installed and configured"
    break
  fi
}

setupCreateProject () {
while test $# -gt 0; do
  if [ $1 == "-h" ] || [ $1 == "--help" ]; then
    createHelp
    exit 0
  elif [ $1 == "--project-name" ]; then
    export PROJECT_NAME=$2
    echo $PROJECT_NAME
  elif [ $1 == "--project-id" ]; then
    export PROJECT_ID=$2
  #       need to write a function to parse list and figure out the inputs should be passed
  #       elif [ $1 == "--project-tags" ]; then
  #         export PROJECT_TAGS=$2
  #         echo $PROJECT_TAGS
  else
    echo "Unrecognized options for --create command $1"
    exit 1
  fi
  # Shift past the last two parameters evaluated
  shift
  shift
done
}

createProject () {
  echo Creating a project!
  if [ PROJECT_NAME == "" ]; then
    echo Please enter a project name:
    read projName
    export PROJECT_NAME=projName
  fi
  if [ PROJECT_ID == "" ]; then
    echo Please enter a project ID:
    read projId
    export PROJECT_ID=projId
  fi
  # Create a project
  gcloud projects create $PROJECT_ID --name="$PROJECT_NAME" --labels=type=tutorial
  # Activate the require services for the project
  gcloud config set project $PROJECT_ID
  # gcloud services enable container
  gcloud services enable container
  # Setup cluster
  # Confirm the cluster is setup is complete - need to pause script and get a green status before proceeding
  # Setup kubectl
  # Add the helm chart
  # Confirm the cluster is setup
  # Install the Gitlab helm chart
  # Confirm the status of the gitlab install
  # get the IP address
  # Add option for setting up project to use Cloud DNS
    # gcloud services enable dns
    # need to collect a zone name [$DNS_ZONE_NAME] and a record [$DNS_RECORD] (eg: "example.com." - trailing period is required)
    # Can setup for user to choose visibility - may be necessary for future setup that uses firewall and Broker tutorial
    # Example command: gcloud dns --project=$PROJECT_ID managed-zones create $DNS_ZONE_NAME --description="" --dns-name="$DNS_RECORD" --visibility="$DNS_VISIBILITY" --dnssec-state="on"
  # confirm the available domain
  # Create the DNS Zone
  # gcloud dns --project=gitlab-tutorial-378620 managed-zones create gitlab-tutorial-zone --description="" --dns-name="owenpickford.com." --visibility="public" --dnssec-state="off"
  # Add the A record
}

############################################################
# Main program                                             #
############################################################

PROJECT_NAME=""
PROJECT_ID=""
GKE_CLUSTER_NAME=""

checkConfig

# Sort through the options"
# Using this model: https://stackoverflow.com/questions/7069682/how-to-get-arguments-with-flags-in-bash/7069755#7069755

if [ $# -eq 0 ]; then
  echo "Additional Arguments are required"
  echo ""
  Help
fi
while test $# -gt 0; do
  case "$1" in
    -h|--help)
      Help
      exit 0
      ;;
    -c|--create)
      ## Shift to the parameter after --create
      shift
      ## Evaluate which parameters are where passed in
      setupCreateProject $@
      createProject PROJECT_NAME PROJECT_ID
      ;;
    -d|--delete)
      if [ $1 == "-h" ] || [ $1 == "--help" ]; then
        deleteHelp
        exit 0
      elif [ $1 == "--project-id" ]; then
        export PROJECT_ID=$2
        echo $PROJECT_ID
      else
        echo "Unrecognized options for --delete command: $1"
        echo "--project-id is required"
        exit 1
      fi
      shift
      ;;
    -o)
      shift
      if test $# -gt 0; then
        export OUTPUT=$1
      else
        echo "no output dir specified"
        exit 1
      fi
      shift
      ;;
    --output-dir*)
      export OUTPUT=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    *)
      break
      ;;
  esac
done


while getopts ":hcd" option; do
  case $option in
    h) # display Help
      Help
      exit;;
    c) # Gitlab Google Cloud tutorial setup
      echo Creating a project!
      echo Please enter a project name:
      read projName
      echo Please enter a project ID:
      read projId
      # Create a project
      gcloud projects create $projId --name="$projName" --labels=type=tutorial
      # Activate the require services for the project
      # gcloud config set project $projId
      # gcloud services enable container
      # gcloud container
      # Setup kubectl
      # Add the helm chart
      # Confirm the cluster is setup
      # Install the Gitlab helm chart
      # Confirm the status of the gitlab install
      # get the IP address
      # enable the Cloud DNS API
      # confirm the available domain
      # Create the DNS Zone
      # gcloud dns --project=gitlab-tutorial-378620 managed-zones create gitlab-tutorial-zone --description="" --dns-name="owenpickford.com." --visibility="public" --dnssec-state="off"
      # Add the A record
      exit;;
    d) #Gitlab Google Cloud tutorial deletion and teardown
      echo Deleting a project!
      echo Please enter a project ID:
      read projId1
      echo Please confirm deletion. Re-enter the project ID:
      read projId2
      if [ $projId1 == $projId2 ]; then
        gcloud projects delete $projId1
      else
        echo project IDs do not match.
      fi
      exit;;
    \?) # Invalid option
      echo "Error: Invalid option. Use -h to see options."
      exit;;
    esac
done