package myhomepage;
use Dancer2;

our $VERSION = '0.1';

# make app_setting available in the templates
hook before_template => sub {
    my $tokens = shift;

    # Put the app_setting from the configuration into the tokens
    $tokens->{app_setting} = config->{'app_setting'};
};


get '/' => sub {
    template 'index' => { 
        title => 'myhomepage',
        activities => config->{app_setting}->{activities},
    };
};

true;
