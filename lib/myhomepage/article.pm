package myhomepage::article;
use Moo;
use Carp 'croak';
use File::Spec;
use File::Basename;
use YAML::XS;
use Text::Markdown 'markdown';
use File::Slurp;

has basedir => (
    is => 'ro',
    required => 1,
    isa => sub {
        my $val = shift;
        croak "Not a valid directory ($val)" if ! -d $val;
    },
);

has slug => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        return basename($self->basedir);
    },
);

has category => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        my $parentdir = basename(dirname($self->basedir));
        return ($parentdir eq 'articles') ? 'page' : $parentdir;
    },
);

has is_page => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        return $self->category eq 'page';
    },
);

has meta => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        my $meta_file = File::Spec->catfile($self->basedir, 'meta.yml');
        if (! -e $meta_file) {
            croak "No meta file, unable to initialize this article";
        }
        return YAML::XS::LoadFile($meta_file);
    },
);

has content => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        my $content_file = File::Spec->catfile($self->basedir, 'content.md');
        if (! -e $content_file) {
            croak "content.md file not found in ".$self->basedir;
        };
    
        my $markdown = read_file($content_file);
        return markdown($markdown);
    },
);

1;
