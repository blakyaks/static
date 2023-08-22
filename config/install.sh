#!/bin/bash -e

github_version () {
  REPO="$1"
  wget -q -O- https://api.github.com/repos/${REPO}/releases/latest | jq -r '.name'
}

install_software () {
  software="$1"
  if [[ $software = "terraform" ]]
  then
    echo "Installing terraform..."
    sudo apt-get install terraform -y -u
  elif [[ $software = "tflint" ]]
  then
    echo "Installing tflint..."
    sudo curl -s "https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh" | bash
  elif [[ $software = "terraform-docs" ]]
  then
    echo "Installing terraform-docs..."
    v_tfdocs=$(github_version "terraform-docs/terraform-docs")
    sudo curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/$v_tfdocs/terraform-docs-$v_tfdocs-$(uname)-amd64.tar.gz \
        && tar -xzf terraform-docs.tar.gz terraform-docs \
        && chmod +x terraform-docs \
        && sudo mv terraform-docs /usr/local/bin/terraform-docs \
        && rm terraform-docs.tar.gz -f
  elif [[ $software = "tt" ]]
  then
    echo "Installing BlakYaks terratest runner..."
    curl -sfSLo tt https://blakyaks.blob.core.windows.net/utils/tt \
      && sudo chmod +x tt \
      && sudo mv tt /usr/local/bin/tt
  else
    echo "$software not found"
  fi  
}
