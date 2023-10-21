requires "Dancer2" => "1.0.0";

# app deps
requires "Text::Markdown"          => "0";
requires "File::Slurp"          => "0";

# Accelerate Dancer
requires "YAML"                    => "0";
requires "YAML::XS"                => "0";
requires "Unicode::UTF8"           => "0";
requires "URL::Encode::XS"         => "0";
requires "CGI::Deurl::XS"          => "0";
requires "YAML::XS"                => "0";
requires "Class::XSAccessor"       => "0";
requires "HTTP::XSHeaders"         => "0";
requires "MooX::TypeTiny"          => "0";
requires "Type::Tiny::XS"          => "0";

on "test" => sub {
    requires "Test::More"            => "0";
    requires "HTTP::Request::Common" => "0";
};

