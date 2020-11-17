package read;

use nginx;
use strict;
use warnings;

sub handler {
  my $r = shift;

  return OK if $r->header_only;

  my $response_body = "";

  unless(open FILE, "/tmp/".$r->uri."_".$r->request_method.".json") {
    die "File not exists ".$r->uri;
  }

  while(my $line = <FILE>) {
    $line =~ m/status:\s(\d+)/;
    my $status_code = $1;

    if ($status_code) {
      $r->status($status_code);
    } else {
      $response_body = $response_body.$line
    }

  }

  $r->send_http_header("application/json");
  $r->print($response_body);

  close FILE;

  return OK;
}

1;
__END__
