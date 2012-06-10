nginx-perl-plugins
==================

I'm going to put here my useful nginx plugins. 

--- Minifier

Usage

Load the Plugin in nginx http section:

	perl_require /etc/nginx/perl/Minify.pm;
In nginx add to your server section:

location @minify_css {
	perl Minify::css_handler;
}

location ~ ^/(.*)/([^/]+\.css)$ {
	expires 30d;
	add_header "Cache-Control" "public";
	add_header "Vary" "Accept-Encoding";
	if_modified_since off;
	add_header Last-Modified "";
	try_files /$1/$2min @minify_css;
}

location ~ min$ {
	expires 30d;
	add_header "Cache-Control" "public";
	add_header "Vary" "Accept-Encoding";
	if_modified_since off;
	add_header Last-Modified "";
}

Be aware!

Nginx should be able to write to the directory where the css files are.
You have to take care manually of removing minified files after a new deploy.
