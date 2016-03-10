#!/usr/bin/env perl-w

use strict;
use warnings;
use Getopt::Long qw(:config no_ignore_case no_auto_abbrev pass_through);

use constant DEFAULT_SAMTOOLS_PATH => '/usr/bin/samtools';

my ($samtools_path, $out_file);

GetOptions(
        "samtools_path=s" => \$samtools_path,
        "output=s" => \$out_file,
);

if (defined($samtools_path)) {
        $samtools_path=~s/\/$//;
} else {
        $samtools_path=DEFAULT_SAMTOOLS_PATH;
}
# add samtools path
$ENV{"PATH"}.=":$samtools_path";

my $subcommand=shift;
my $SAMTOOLS_ARGS = join(" ", @ARGV);
if (! defined($out_file)) {
        $out_file="samtools_$subcommand\_output";
}
$SAMTOOLS_ARGS.=" > $out_file";

my $samtools_command="samtools $subcommand $SAMTOOLS_ARGS";

info("$samtools_command");
system("$samtools_command") == 0 or info("$samtools_command failed: $!");

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
