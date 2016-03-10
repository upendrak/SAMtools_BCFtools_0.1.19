#!/usr/bin/env perl-w

use strict;
use warnings;
use Getopt::Long qw(:config no_ignore_case no_auto_abbrev pass_through);

use constant DEFAULT_BCFTOOLS_PATH => '/usr/bin/bcftools';

my ($bcftools_path, $out_file);

GetOptions(
        "bcftools_path=s" => \$bcftools_path,
        "output=s" => \$out_file,
);

if (defined($bcftools_path)) {
        $bcftools_path=~s/\/$//;
} else {
        $bcftools_path=DEFAULT_BCFTOOLS_PATH;
}
# add bcftools path
$ENV{"PATH"}.=":$bcftools_path";

my $subcommand=shift;
my $BCFTOOLS_ARGS = join(" ", @ARGV);
if (! defined($out_file)) {
        $out_file="bcftools_$subcommand\_output";
}
$BCFTOOLS_ARGS.=" > $out_file";

my $bcftools_command="bcftools $subcommand $BCFTOOLS_ARGS";

info("$bcftools_command");
system("$bcftools_command") == 0 or info("$bcftools_command failed: $!");

unless (-e $out_file) {
        exit(1);
}

sub info {
        print STDERR shift, "\n";
}

1;


=head1 AUTHOR

Zhenyuan Lu
Cold Spring Harbor Laboratory
luj@cshl.edu

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
