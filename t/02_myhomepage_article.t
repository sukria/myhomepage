use Test::More;
use strict;
use warnings;

use File::Basename;
use File::Spec;
use myhomepage::article;


# Testing basedir

eval { myhomepage::article->new() };
like( $@, qr/Missing required/, "failed to create without basedir") ;

eval { myhomepage::article->new( basedir => 'nonexisting') };
like( $@, qr/Not a valid/, "failed to create with invalid basedir") ;

my $page;
my $localdir = File::Spec->catfile(dirname(__FILE__), 'articles', 'some-test-article');
eval { $page = myhomepage::article->new( basedir => $localdir ); };
is( $@, '', "article created with a valid basedir");

# Testing slug
is($page->slug, 'some-test-article', 'slug is correctly initialized');

# Testing category
is ($page->category, 'page', "This article is actually a page (top-level)");
ok($page->is_page, "Flag is_page works");
like ($page->permalink, qr{/some-test-article}, "permalink looks good");

$localdir = File::Spec->catfile(dirname(__FILE__), 'articles','tech','myhomepage' );
my $article = myhomepage::article->new( basedir => File::Spec->catfile($localdir));
is($article->category, 'tech', "This article is under the 'tech' category");
ok(!$article->is_page, "Flag is_page works");

# Testing meta
ok($article->meta, "meta initialized correctly"); 
like($article->meta->{'title'}, qr/myhomepage, the super/, 'title looks good');
is_deeply($article->meta->{'tags'}, [qw(perl dancer blog)], "tags looks ok");


# Testing content
eval { $page->content };
like ($@, qr/content\.md file not found/, "Exception triggered for missing content.md file");

like ($article->content, qr/<h1>This is the first.*<\/h1>/, "content has been rendered as HTML");

like ($article->permalink, qr{/blog/tech/myhomepage}, "permalink looks good");

# End of tests
done_testing;
