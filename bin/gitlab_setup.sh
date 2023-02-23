#!/bin/bash

############################################################
# Help
############################################################
Help()
{
   # Display Help
   echo "Automate setup and teardown of the Gitlab Snyk Tutorial"
   echo
   echo "Syntax: gitlab_setup.sh [-h|-c|-d]"
   echo "options:"
   echo "h     Print this help"
   echo "c     Create the gitlab instance"
   echo "d     Delete and clean up gitlab setup"
}

############################################################
# Main program                                             #
############################################################

# Sort through the options
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