# Pragmas.
use strict;
use warnings;

# Modules.
use Cwd qw(realpath);
use English qw(-no_match_vars);
use File::Spec::Functions qw(catfile);
use FindBin qw($Bin);
use Test::More 'tests' => 1;

# Test.
eval 'use Test::Pod 1.00';
if ($EVAL_ERROR) {
        plan 'skip_all' => 'Test::Pod 1.00 required for testing POD';
}
pod_file_ok(realpath(catfile($Bin, '..', '..', 'HTML.pm')));
