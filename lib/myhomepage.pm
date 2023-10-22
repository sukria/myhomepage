package myhomepage;
our $VERSION = '0.1';

use Dancer2;
use File::Spec;
use myhomepage::blog;

my $_BLOG_DIR = File::Spec->catfile(config->{'public_dir'}, 'articles');
my $_BLOG;

# make app_setting available in the templates
hook before_template => sub {
    my $tokens = shift;

    # Put the app_setting from the configuration into the tokens
    $tokens->{app_setting} = config->{'app_setting'};
};


get '/' => sub {
    
    if (! defined $_BLOG) {
        $_BLOG = myhomepage::blog->new(rootdir => $_BLOG_DIR);
    }

    my $posts = [];
    eval { 
        $posts = $_BLOG->featured_posts,
    };

    template 'index' => { 
        title => 'myhomepage',
        posts => $posts,
        has_posts => scalar(@{$posts}),
        activities => config->{app_setting}->{activities},
    };
};

get '/blog/:cat/:slug' => sub {
    my $cat = param('cat');
    my $slug = param('slug');
    my $dir = config->{'public_dir'};

    my $article = myhomepage::article->new(basedir => 
        File::Spec->catfile($_BLOG_DIR, $cat, $slug) );

    return template 'article' => {
        title => $article->title,
        is_article_page => 1,
        tags => $article->tags,
        content => $article->content,
    };
};

true;
