{% if data.sync is defined %}
{% set add_semicolon_after_slot_name = 'slot_name' %}
{% endif %}
{#####################################################}
{## Change owner of subscription ##}
{#####################################################}
{% if data.subowner and data.subowner != o_data.subowner %}
ALTER SUBSCRIPTION {{ conn|qtIdent(o_data.name) }}
    OWNER TO {{ data.subowner }};

{% endif %}
{###  Disable subscription ###}
{% if data.enabled is defined and data.enabled != o_data.enabled %}
{% if not data.enabled %}
ALTER SUBSCRIPTION {{ conn|qtIdent(o_data.name) }} DISABLE;
{% endif %}

{% endif %}
{###  Alter slot name of subscription ###}
{% if data.slot_name is defined or data.sync %}
ALTER SUBSCRIPTION {{ conn|qtIdent(o_data.name) }}
    SET ({% if data.slot_name is defined and data.slot_name != o_data.slot_name %}slot_name = {{ data.slot_name }}{% if add_semicolon_after_slot_name == 'slot_name' %}, {% endif %}{% endif %}{% if data.sync %}synchronous_commit = '{{ data.sync }}'{% endif %});

{% endif %}
{###  Enable subscription ###}
{% if data.enabled is defined and data.enabled != o_data.enabled %}
{% if data.enabled %}
ALTER SUBSCRIPTION {{ conn|qtIdent(o_data.name) }} ENABLE;
{% endif %}

{% endif %}
{###  Refresh publication ###}
{% if data.refresh_pub %}
ALTER SUBSCRIPTION {{ conn|qtIdent(o_data.name) }}
    REFRESH PUBLICATION{% if not data.copy_data_after_refresh %} WITH (copy_data = false){% else %} WITH (copy_data = true){% endif %};

{% endif %}
{###  Alter publication of subscription ###}
{% if data.pub%}
{% if data.pub and not data.refresh_pub and not data.enabled %}
ALTER SUBSCRIPTION {{ conn|qtIdent(o_data.name) }}
    SET PUBLICATION {% for pub in data.pub %}{% if loop.index != 1 %},{% endif %}{{ conn|qtIdent(pub) }}{% endfor %} WITH (refresh = false);
{% else %}
ALTER SUBSCRIPTION {{ conn|qtIdent(o_data.name) }}
    SET PUBLICATION {% for pub in data.pub %}{% if loop.index != 1 %},{% endif %}{{ conn|qtIdent(pub) }}{% endfor %};
{% endif %}

{% endif %}
{###  Alter subscription connection info ###}
{% if data.host or data.port or data.username or data.password  or data.db or  data.connect_timeout or data.passfile %}
ALTER SUBSCRIPTION {{ conn|qtIdent(o_data.name) }}
    CONNECTION 'host={{ o_data.host}} port={{ o_data.port }} user={{ o_data.username }} dbname={{ o_data.db }}{% if data.connect_timeout %} connect_timeout={{ o_data.connect_timeout }}{% endif %}{% if data.passfile %} passfile={{ o_data.passfile }}{% endif %}{% if data.password %} {% if dummy %}password=xxxxxx{% else %} password={{ data.password}}{% endif %}{% endif %}';
{% endif %}
{###  Alter subscription name ###}
{% if data.name and data.name != o_data.name %}
ALTER SUBSCRIPTION {{ conn|qtIdent(o_data.name) }}
    RENAME TO {{ conn|qtIdent(data.name) }};

{% endif %}






