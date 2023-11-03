[Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)
has become a widely-used and respected branching model in software development.
It's centered around the idea of managing feature branches, along with _develop_
and _main_ branches for preparing releases. While effective and great for ensuring
a reliable codebase, I found the repetitive nature of Git Flow commands somewhat
burdensome over time. The constant typing of commands like <code>git flow
feature start ...</code> began to wear on me. To address this, I've refined my
Bash environment to create aliases that eliminate the tedious work.

I got the idea of this little hack when I was working on 
[Dancer2::Plugin::LiteBlog](/dev/liteblog-a-minimalist-file-based-blog-engine-for-perl/).
I often needed to switch between branches and ensure that I was applying changes in the correct place. To
streamline my Git workflow, I came up with a set of Bash functions and aliases
that made managing Git flow feature branches effortless. It's super simple, and
once added to your shell environment, it makes your git flow fu so much
painless.

## Starting a New Feature with Git Flow

When you're ready to start a new feature, you usually need to ensure that you're
branching off from the right place. Typically, the _development_ or _devel_ branch
is where all the action happens. 

With Git Flow, you should start a new feature from that development branch (in
my example below, it will be named _devel_), with the following command line:

<pre><code class="bash">git flow feature start FEATURE_NAME
</code></pre>

It's quite verbose, and you should not launch this command unless:

  * You are in a git repository.
  * The current branch is the development branch.

### The <code>git_flow_feature_start</code> Function

Here is a Bash function that does all the boring stuff for you, and allows you
to open a new feature with as less verbosity as possible.

<pre><code class="bash">function git_flow_feature_start() {
    curbranch=$(git symbolic-ref --short HEAD)
    if [ "$curbranch" == "devel" ]; then
        if [ -z "$1" ]; then
            echo "Please specify a feature name to start."
        else
            git flow feature start "$1"
        fi
    else
        echo "You can only start a new feature from the 'devel' branch."
    fi
}
</code></pre>

To use this function, simply call it with the feature name (note that I've added
an alias <code>gfs</code> that points to that function, as we'll see in the end
of this article):

<pre><code class="bash">gfs feature-name</code></pre>

## Finishing a Feature with Git Flow

Finishing a feature should be just as seamless, but **only if you're on a branch
that actually represents a feature**. Otherwise, well, it does not make sense.

### The <code>git_flow_feature_finish</code> Function

This function checks that your current branch starts with feature/ before
attempting to finish it:

<pre><code class="bash">function git_flow_feature_finish() {
    curbranch=$(git symbolic-ref --short HEAD)
    if [[ $curbranch == feature/* ]]; then
        git flow feature finish "${curbranch#feature/}"
    else
        echo "You can only finish a feature if you are on a 'feature/*' branch."
    fi
}
</code></pre>

Usage is even simpler; just type the following when you're done with your
feature:

<pre><code class="bash">gff</code></pre>

The function will extract the feature name from the branch and proceed with
finishing it.

## Setting Up Aliases for Efficiency

To avoid typing these commands out in full each time, we set up aliases in our
Bash configuration:

<pre><code class="bash">alias gfs="git_flow_feature_start"
alias gff="git_flow_feature_finish"
</code></pre>


## Share your Feedback

If you find this useful, feel free to star my <code>[dotfiles](https://github.com/sukria/dotfiles)</code> project on
GitHub. This is where I host all sorts of little hacks for my Bash/Git/Vim
environments. 

If you tested these little helpers and have suggestions for improvement, feel
free to open an issue or even fork the project.


