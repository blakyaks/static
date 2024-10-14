#!/bin/bash -e

github_version () {
  REPO="$1"
  wget -q -O- https://api.github.com/repos/${REPO}/releases/latest | jq -r '.name'
}

install_software () {
  software="$1"
  if [[ $software = "terraform" ]]; then
    echo "Installing terraform..."
    sudo apt-get install terraform -y -u
  elif [[ $software = "tflint" ]]; then
    echo "Installing tflint..."
    sudo curl -s "https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh" | bash
  elif [[ $software = "terraform-docs" ]]; then
    echo "Installing terraform-docs..."
    v_tfdocs=$(github_version "terraform-docs/terraform-docs")
    sudo curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/$v_tfdocs/terraform-docs-$v_tfdocs-$(uname)-amd64.tar.gz \
        && tar -xzf terraform-docs.tar.gz terraform-docs \
        && chmod +x terraform-docs \
        && sudo mv terraform-docs /usr/local/bin/terraform-docs \
        && rm terraform-docs.tar.gz -f
  elif [[ $software = "yaml-docs" ]]; then
    echo "Installing yaml-docs..."
    v_yamldocs=$(github_version "blakyaks/yaml-docs")
    sudo curl -sSLo ./yaml-docs.tar.gz https://github.com/blakyaks/yaml-docs/releases/download/$v_yamldocs/yaml-docs_${v_yamldocs:1}_Linux_x86_64.tar.gz \
        && tar -xzf yaml-docs.tar.gz yaml-docs \
        && chmod +x yaml-docs \
        && sudo mv yaml-docs /usr/local/bin/yaml-docs \
        && rm yaml-docs.tar.gz -f
  elif [[ $software = "yamllint" ]]; then
    echo "Installing yamllint..."
    sudo apt-get install yamllint -y -u
  else
    echo "$software not found"
  fi
}
