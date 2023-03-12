package TJFARN::Process;
use utf8;
use v5.30;
use warnings;
use Exporter;
use TJFARN::Transactions;

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(add_user);

sub add_user {
	my ($user) = @_;

	my $tns = TJFARN::Transactions->new();

	my $uid = $tns->process( sub {
		my ($dbh) = @_;
		my $rc = $dbh->do(<<MYSQL, undef, $user, !!1);
INSERT INTO
	`user`
	(`name`, `status`)
	VALUES
	(?, ?)
MYSQL
		return $rc ? $dbh->last_insert_id : undef;
	});

	my $res = $tns->process( sub {
		my ($dbh, $user_id) = @_;
		my $rc = $dbh->do(<<MYSQL, undef, $user_id, !!1);
INSERT INTO
	`log`
(`user_id`)
VALUES
	(?)
MYSQL
		return $rc;
	}, $uid );

	$tns->finish;
}

1;