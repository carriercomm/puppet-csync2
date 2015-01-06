# = Class: csync2
#
# Module to manage csync2
#
# == Requirements:
#
# - This module makes use of the example42 functions in the puppi module
#   (https://github.com/credativ/puppet-example42lib)
#
# == Parameters:
#
# [* ensure *]
#   What state to ensure for the package. Accepts the same values
#   as the parameter of the same name for a package type.
#   Default: present
#   
# [* config_source *]
#   Specify a configuration source for the configuration. If this
#   is specified it is used instead of a template-generated configuration
#
# [* config_template *]
#   Override the default choice for the configuration template
#
#

class csync2 (
    $ensure             = params_lookup('ensure'),
    $manage_config      = params_lookup('manage_config'),
    $config_file        = params_lookup('config_file'),
    $config_source      = params_lookup('config_source'),
    $config_template    = params_lookup('config_template'),
    $key                = params_lookup('key'),
    $keyfile            = params_lookup('keyfile'),
    ) inherits csync2::params {

    package { 'csync2':
        ensure => $ensure
    }

    file { $config_file:
        mode   => '0644',
        owner  => 'root',
        group  => 'root',
        tag    => 'csync2_config',
    }

    if $config_source {
        File <| tag == 'csync2_config' |> {
            source  => $config_source
        }
    } elsif $config_template {
        File <| tag t== 'csync2_config' |> {
            content => template($config_template)
        }
    }

    file { $keyfile:
        ensure  => present,
        content => $key
    }
}

