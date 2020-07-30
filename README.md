<p>

<!-- README.md was generated from README.lt3 -->
<p>

<h1>links_manager</h1>
<p>

Eventual purpose: Manage a curated set of web links.
Later this will be a Rails app.
<p>

<h2>Concept</h2>
<p>

The basics are:
<p>

<ul>
<li>Links are divided into fairly broad categories. Each may have any number of entries. Currently, these are not nested, but I am thinking of it.</li>
<li>Links can have any number of tags. Currently a tag is a single token (with blank spaces replaced by underscores.</li>
<li>The categories will be arranged in some kind of logical layout (think classic Yahoo). The tags are currently just alphabetized, but later might be in a "tag cloud" or whatever.</li>
<li>The categories <i>may</i> have hundreds of entries.  So there is a need for some kind of collapse/expand feature for management of screen real estate. </li>
<li>I will add a hidden "score" to each link so as to put the important ones at the top of the category. </li>
<li>I am considering a "More..." link or the equivalent for the rest.</li>
<li>Eventually there should be a search feature.</li>
</ul>
<h2>What I Need Help With...</h2>
<p>

I am Not a Web Guy (for various reasons). I am generating static HTML for now.
<p>

At present, I'm not trying to make this a full-fledged web app. I hope it will be later, though.
<p>

Right now, I'm trying to do three basic things:
<p>

<ul>
<li>Most importantly, make it better looking. It is awful right now.</li>
<li>Introduce some kind of collapse/expand or similar option.</li>
<li>Do whatever else is "easy" in terms of search/tags/whatever (without making it a real web app yet).</li>
</ul>
I have had <font size=+1><tt>MVP.css</tt></font> recommended to me. It looks interesting, but I haven't yet grasped how I should
change my markup to make use of it.
<p>

I've also had <font size=+1><tt>skeleton.css</tt></font> recommended, but haven't really looked yet. As a CSS newbie, I wouldn't
really know where to start.
<p>

On another page, I've played with Bootstrap a little for collapsing/expanding. It's not bad, but I 
definitely don't understand what all my options are.
<p>

<h2>Current status</h2>
<p>

At present, the static HTML is generated from the file <font size=+1><tt>all-links.lt3</tt></font>.
<p>

Note that this uses <font size=+1><tt>Livetext</tt></font>, my own tool that no one else in the world uses.
See the <a style='text-decoration: none' href='https://github.com/Hal9000/livetext'>Livetext repo</a>. Install as a Ruby gem and run intuitively.
<p>

<pre>
    $ gem install livetext
    $ livetext all-links.lt3 >myfile.html
</pre>
An entry looks like this:
<p>

<img src='entry.png'></img>
<p>

The <font size=+1><tt>entry</tt></font> command is defined by the <font size=+1><tt>entry</tt></font> method in <font size=+1><tt>links_mgr.rb</tt></font>, which is
pure Ruby (referenced by the command <font size=+1><tt>.mixin links_mgr</tt></font>).
<p>

Any line starting with "dot-space" is a Livetext comment.
<p>

The command <font size=+1><tt>_entry</tt></font> is a "null" command, in effect commenting out that entry. (It
refers to the Ruby method <font size=+1><tt>_entry</tt></font>).
<p>

Within an entry (before the <font size=+1><tt>.end</tt></font>), you will see lines marked with a single word.
<font size=+1><tt>cats</tt></font> is for categories, <font size=+1><tt>tags</tt></font> for tags, and <font size=+1><tt>link</tt></font> is obviously the link. I will
add <font size=+1><tt>score</tt></font> (a simple integer 0-100) as a rough quality measure.
<p>

A category identifier (single word) is associated with the "real name" by the
<font size=+1><tt>categories.txt</tt></font> file. The list of categories <i>will change</i>.
<p>

At present, I use certain "magic" tags like <font size=+1><tt>BADCERT</tt></font>, <font size=+1><tt>INACTIVE</tt></font>, and <font size=+1><tt>TIMEOUT</tt></font>
to keep entries out of the HTML (but keep them in the data for now).
<p>

See <font size=+1><tt>current.html</tt></font> for the latest output.
<p>

<p>

