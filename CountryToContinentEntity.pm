package Manta::CountryToContinentEntity;

use Manta::Object;
use base qw(Manta::Object::Std);

has_fields(
	continent_name       => { entity_props => { type => 'string', size => '50' } },
	country_name         => { entity_props => { type => 'string', size => '200' } },
	continent_id         => { entity_props => { type => 'number', nullable => 1 } },
	iso_country_cd		 => { entity_props => { type => 'string', size => '2', nullable => 1 } },
);

sub entity_conf_info {{
	db => 'ha',
	table_prefix => 'ecadm',
	table_name    => 'continents',
	primary_key   => 'country_name',
}}

sub app_context { Manta::Web::ApplicationContext->get_current }

sub _entity_mgr { $_[0]->app_context->component_factory->main_entity_mgr }

sub countryFromCode {
	my $countryCode = shift;
	my $result = $_[0]->_entity_mgr->find(CLASS => 'Manta::CountryToContinentEntity', ISO_COUNTRY_CD => $countryCode, REQUIRED => 0);
	my $country_name = $result->[0]->country_name;
	$country_name =~ s/([\w']+)/\u\L$1/g;
	return $country_name;
}

1;
