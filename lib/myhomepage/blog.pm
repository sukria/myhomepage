package myhomepage::blog;
use Moo;
use Carp 'croak';
use YAML::XS;
use File::Spec;
use myhomepage::article;

has rootdir => (
    is => 'ro',
    required => 1,
    isa => sub {
        my $val = shift;
        croak "Not a valid directory ($val)" if ! -d $val;
    },
);

has meta => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        my $meta = File::Spec->catfile($self->rootdir, 'blog-meta.yml');
        if (! -e $meta) {
            croak "No meta file found for the blog : $meta";
        }
        return YAML::XS::LoadFile($meta);
    },
);

has featured_posts => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        
        my @posts;
        foreach my $path (@{ $self->meta->{featured_posts} }) {
            my $post;
            eval { $post = myhomepage::article->new(
                    basedir => File::Spec->catfile( $self->rootdir, $path)
                )
            };
            push @posts, $post if ! $@;
        }
        
        return \@posts;
    },
);

1;
