package Minify;
use nginx;
use JavaScript::Minifier qw(minify);
use CSS::Minifier;
use File::Basename;

sub css_handler {
	my $r=shift;
	my $path=$r->filename;
	my($filename, $directory, $suffix) = fileparse($path);
	my $minfile = $directory.$filename.'min';
	my $css = '';
	return DECLINED unless -f $path;

	open(INFILE, $path) or die "Error reading file: $!";
	while(<INFILE>){
		if(m/(\@import) "([^"]*)";/){
			if(open(INCLUDE, $directory.$2)){
				while(<INCLUDE>){
					$css .= $_;
				}
				close(INCLUDE);
			}
		} else {
			$css .= $_;
		}
	}
	close(INFILE);
	open(OUTFILE, '>' . $minfile) or die "Error writing file: $!";
	CSS::Minifier::minify(input=> $css, outfile=> *OUTFILE);
	close(OUTFILE);	

	$r->send_http_header("text/css");
	$r->sendfile($minfile);
	return OK;
}
1;
__END__
