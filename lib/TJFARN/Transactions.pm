package TJFARN::Transactions;
use utf8;
use v5.30;
use warnings;
use Const::Fast;
use Try::Tiny;
use TJFARN::Utils qw(get_dbh);

const my %status => (
	started  => 1,
	finished => 2,
);

sub new {
	return bless {
		_dbh    => get_dbh(),
		_status => 0,
	} => shift;
}

sub process {
	my ($self, $code_ref, @args) = @_;

	if ($self->{'_status'} != $status{'started'}) {
		$self->{'_status'} = $status{'started'};
		$self->{'_dbh'}->{'AutoCommit'} = 1;
		$self->{'_dbh'}->begin_work;
	}

	my $result;
	try {
		$result = $code_ref->($self->{'_dbh'}, @args);
	} catch {
		$self->{'_status'} = $status{'finished'};
		$self->{'_dbh'}->rollback;
	};

	return $result;
}

sub finish {
	my ($self) = @_;

	$self->{'_dbh'}->commit;
	$self->{'_status'} = $status{'finished'};

	return;
}

sub DESTROY {
	my ($self) = @_;
	$self->{'_dbh'}->rollback if $self->{"_status"} != $status{'finished'};
	$self->{'_dbh'}->disconnect;
}

1;