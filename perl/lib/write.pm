package write;

use nginx;
use strict;
use warnings;
use JSON;
use File::Path;
use File::Basename;

sub handler {
  my $r = shift;

  if ($r->has_request_body(\&post)) {
      return OK;
  }

  $r->send_http_header("application/json");

  return HTTP_BAD_REQUEST;
}

sub post {
  my $r = shift;
  my $encoded_data = decode_json($r->request_body);

  my $method = defined $encoded_data->{request}->{method} ? $encoded_data->{request}->{method} : "GET" ;

  my $status_code = $encoded_data->{request}->{status_code};
  my $filename = $encoded_data->{request}->{uri};
  my $data = $encoded_data->{response}->{body};
  my $dir = dirname($filename);

  $r->send_http_header("application/json");

  if ( !-d $dir ) {
     mkpath('/tmp/'.$dir);
  }

  unless(open FILE, ">/tmp/".$filename."_".$method.".json") {
     die "Unable to create $filename";
  }

  print FILE "status: ".$status_code."\n" if $status_code;

  print FILE encode_json $data;

  close FILE;

  $r->print('{"success":true}');

  return OK;
}

1;
__END__
