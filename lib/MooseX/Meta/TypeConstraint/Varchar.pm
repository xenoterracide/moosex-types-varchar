package MooseX::Meta::TypeConstraint::Varchar;
use strict;
use warnings;
use Moose::Util::TypeConstraints qw/ register_type_constraint
				     find_type_constraint /;

use base qw/ Moose::Meta::TypeConstraint::Parameterizable /;

sub parameterize {
	my ($self, $length) = @_;
	my $contained_tc = $self->_parse_type_parameter($length);

        my $tc_name = $self->name . '[' . $length . ']';
        my $parameterized = Moose::Meta::TypeConstraint::Parameterized->new(
            name           => $tc_name,
            parent         => $self,
            type_parameter => $contained_tc,
	    message        => sub {
		    my $value = shift;
		    return "'$value' is too long for attribute type $tc_name"
	    },
        );
	return $parameterized;
}

register_type_constraint(
	MooseX::Meta::TypeConstraint::Varchar->new(
		name                 => 'Varchar',
		package_defined_in   => __PACKAGE__,
		parent               => find_type_constraint('Str'),
		constraint           => sub {1},
		constraint_generator => sub {
			my $length = shift;
			return sub {
				return 1 if defined $_ && length $_ <= $length;
				return;
			}
		},
	)
);

Moose::Util::TypeConstraints::add_parameterizable_type(
	find_type_constraint('Varchar')
);

1;
