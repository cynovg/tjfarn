package TJFARN::Transactions;
use utf8;
use v5.30;
use warnings;
use Const::Fast;
use Try::Tiny;
use TJFARN::Utils qw(get_dbh);

const my %status => (
    empty   => 0,
    started => 1,
    error   => 2,
);

sub new {
    return bless {
        _dbh    => get_dbh(),
        _status => 0,
    } => shift;
}

sub process {
    my ( $self, $code_ref, @args ) = @_;

	my $result;
    if ( $self->{'_status'} == $status{'empty'} ) {
        $self->{'_dbh'}->{'AutoCommit'} = 1;
        $self->{'_dbh'}->begin_work or return $result;
        $self->{'_status'} = $status{'started'};
    }
    elsif ( $self->{'_status'} == $status{'error'} ) {
        return $result;
    }

    try {
        $result = $code_ref->( $self->{'_dbh'}, @args );
    }
    catch {
        $self->{'_status'} = $status{'error'};
        $self->{'_dbh'}->rollback;
    };

    return $result;
}

sub finish {
    my ($self) = @_;

    $self->{'_dbh'}->commit;
    $self->{'_status'} = $status{'empty'};

    return;
}

sub DESTROY {
    my ($self) = @_;
    $self->{'_dbh'}->rollback if $self->{"_status"} == $status{'started'};
    $self->{'_dbh'}->disconnect;
}

1;
