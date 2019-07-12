#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use CGI::Minimal;
use lib "/srv/httpd/cgi-bin/lib";
use MY_HTML;

# input
my $cgi = CGI::Minimal->new;
my $query = $cgi->param("query");

my @cols;
my @rows;
if (length $query > 0) {
   process_query($query, \@cols, \@rows);
}

# get no. of rows and columns
my $nr = scalar @rows;
if ($nr > 254) { # no need for n^2 stuff
   exit;
}

# html vars
my $action = "globe.pl";
my $footer = "Copyright &copy; 2019 Josh Roybal";
my $backlink = "/globe.html";
my %field_hash =  (  # label, type, name, value
                     1 => ["SQL QUERY", "textarea", "query", $query],
                     2 => ["", "submit", "", ""],
                  );

# output
print "Content-Type: text/html; charset=utf-8\n\n";
print "<!DOCTYPE html>\n";
print "<head>\n";
print "<meta charset=\"utf-8\">\n";
print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n";
print "<meta name=\"description\" content=\"Perl/SQL global database\">\n";
print "<link id=\"styleinfo\" media=\"all\">\n";
print "<title>Perl/SQL geographic database</title>\n";
print "<script type=\"text/javascript\" src=\"/globe.js\" defer></script>\n";
print "</head>\n";
print "<body>\n";
print "<header><p>Perl/MariaDB geographic database</p></header>\n";
print "<br>\n";
print "<div><a href='/index.php'>Home</a> | <a href='/globe.html'>Back</a></div>\n";
print "<br>\n";
print_form($action, %field_hash);
print "<br>\n";
# emit html table of query results
print "<table id=\"my_table\">\n";
# print relation column headers
print "<tr>";
foreach (@cols) {
   print "<th>$_</th>";
}
print "</tr>\n";
# fetch and print relation rows
foreach (@rows) {
   my @row = @$_; # dereference
   print "<tr>";
   foreach (@row) {
      printf("<td>%s</td>", $_);
   }
   print "</tr>\n";
}
print "</table>\n";
print_bottom($footer, $backlink);

#
# subroutines
#

sub process_query {
   my ($query, $cols_ref, $rows_ref) = @_;
   my @cols = @{ $cols_ref }; # dereferencing
   my @rows = @{ $rows_ref };
   my $dbh = DBI->connect('dbi:mysql:database=world;host=localhost',
      'apache','',   {AutoCommit=>1,RaiseError=>0,PrintError=>0});
   my $sth = $dbh->prepare($query)
      or die;
   $sth->execute()
      or error($sth->errstr, $query);
   @cols = @{$sth->{NAME}};   # fetch relation column headers/field names
   my $index = 0;
   while (my @row = $sth->fetchrow_array()) {
      push @rows, \@row;      # push reference to @row onto @rows
      if (++$index > 254) {  # bail out if there are too many results
         last;
      }
   }
   $sth->finish();
   $dbh->disconnect();
   @{ $cols_ref } = @cols;    # referencing
   @{ $rows_ref } = @rows;
}

sub error {
   my ($errstr, $query) = @_;
   print "Content-type: text/plain\n\n";
   print "$errstr\n";
   exit;        #exit so the script stops here
}
