control 'CVE-2016-5195' do
impact 1.0
title 'Dirty Cow'
  describe bash("
    declare -A os_target_kernel

    os_target_kernel=(['ubuntu 16.10']='4.8.0-26-generic #28' ['ubuntu 16.04']='4.4.0-45-generic #66' ['ubuntu 14.04']='3.13.0-100-generic #147' ['debian 8']='3.16.36-1-amd64 #2')
    os_release=$( echo \"$( cat /etc/*release | grep ^ID= | sed 's/ID=//' | sed 's/\"//g' ) $( cat /etc/*release | grep VERSION_ID | tr -d '[A-Za-z]_=\\\"' )\" )
    target_kernel=${os_target_kernel[${os_release}]}
    current_kernel=$( echo -e \"$( uname -r ) $( uname -rv | grep -o \\#[0-9]. )\" )

    if [ -z \"${target_kernel}\" ]; then
      exit 1
    fi

    if [[ \"${current_kernel}\" != \"${target_kernel}\" ]]; then
      higher_kernel=$( echo -e \"${current_kernel}\\n${target_kernel}\" | sort -rV | head -n1 )
      if [[ \"${current_kernel}\" != \"${higher_kernel}\" ]]; then
        exit 1
      else
        exit 0
      fi
    else
      exit 0
    fi
    exit 1
  ") do
    its('exit_status') { should eq 0 }
  end
end