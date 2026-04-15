<script lang="ts">
	import { resolve } from '$app/paths';
	import '../page.css';
	const home = resolve('/');
</script>

<a href={home} class="back"
	><svg
		width="18"
		height="18"
		viewBox="0 0 24 24"
		fill="none"
		stroke="currentColor"
		stroke-width="2"
		stroke-linecap="round"
		stroke-linejoin="round"><path d="M19 12H5"></path><path d="M12 19l-7-7 7-7"></path></svg
	> Back</a
>
<div class="novella-container">
	<div class="novella-inner">
		<div>
			<h1>The Hacker Novella</h1>
			<h2>A note from the designers</h2>
		</div>
		<div style="color: var(--color-text-dim);">
			<p style="text-indent: 50px;">
				As he sat in his room thinking of ideas for this very story, the lead designer of this
				website was unsure how to address his readers.
			</p>
			<p style="text-indent: 50px;">
				"Should I give them advice? Tell them about my own thoughts? Or explain the reason why a gap
				year is compelling?" were all questions floating around in his brain.
			</p>
			<p style="text-indent: 50px;">
				And then it occurred to him that he should write his own story. A novella, of sorts. He
				chuckled to himself. How clever. And then he went back to the drawing board, because it was
				a stupid idea.
			</p>
		</div>
		<h3>Max's Note</h3>
		<p>
			Hi there! My name is Max, and I'm a 15-year-old intern at Hack Club as well as the lead designer 
			for this website! I wasn't tasked to write this by HQ, but over the course of making this site,
			I felt like I wanted to write something for you to read. If you're reading this note, it
			likely means you're thinking of applying to become a media gap year for Hack Club! Perhaps you
			are skeptical. Of course, many of you will never have heard of Hack Club, or maybe you have
			and you're still not convinced. Let me tell you why you should apply.
		</p>
		<p>
			<strong>1. You will meet amazing people.</strong>
			<br />
			Hack Club HQ is full of the most amazing people you will ever meet. Granted, they are all mega nerds,
			but regardless of whether you share their skills, you'll be working with an amazing set of dedicated
			and talented people every day for a whole year, and possibly make some of the best friends you'll
			ever have. Who knows- you might even pick up some technical skills from them! Knowing how to make
			simple little programs or gadgets is a skill that anyone could benefit from. Aside from the people
			at HQ, you'll also meet a lot of cool teens. Kids just a few years younger than you that will make
			you go, "wow, when I was their age, I was playing CS:GO at 12am on a school night, not recreating
			the entirety of Spotify with only text!" And you know what? It'll be your job to make sure the world
			knows what those kids are capable of. And that's a pretty damn cool job.
		</p>
		<p>
			<strong>2. The independence is freeing.</strong>
			<br />
			Although you may also get this from a college experience, I'd argue that it's much more true working
			with Hack Club. Tongyu (a 2025-26 gap year) has a
			<a href="https://journal.tongyu.fish/sf">blog</a> that describes her experience which is definitely
			worth a read, but to put it simply: Hack Club frees you to live alone. You might share an apartment
			or a house that you rent with other gap years, but other than that, you're on your own. You travel
			by yourself, you cook by yourself, you (unfortunately) clean by yourself, and you (most importantly)
			make decisions by yourself. You learn to live your life exactly the way you want to. This is an
			emulation of the adult experience you won't get until you graduate college. Here's an sneak peek.
		</p>
		<p>
			<strong>3. It will be so much fun.</strong>
			<br />
			Imagine this:
			<br />
			You are fresh out of college. You have a friend group full of the coolest people, who also happen
			to be really kind, creative, resourceful, funny, and fun to hang out with people! And guess what?
			You all work together. At the same place. And you live next to each other. In the same place. When
			you go to work... instead of annoying coworkers, it's your friends. During breaks or lunch you can
			make idle chit-chat, show each other cool stuff you've done, talk about projects you've been working
			on. You lock in together, conquer deadlines together, and WORK HARD together. And you hang out together.
			ALL THE TIME. (It's not like there's much else to do in Vermont except bond anyways.) And over this
			whole year, you will be making lifelong friendships that will only be rivaled by the friends you
			make in college (and, if you haven't realized yet, you're probably gonna go to college after this
			too.)
			<br />
			What was this about again? Oh right. Doesn't that sound like a whole lot of fun?
		</p>
		<p>
			Hopefully by now, I have convinced you on the idea of a gap year at Hack Club. But maybe you
			think you shouldn't apply for other reasons. Like, you don't think you will get in. Or, you
			don't think you are qualified enough just yet. To answer these concerns of yours: apply
			anyways. We don't expect you to be the most skilled or the most seasoned in your field. We are
			looking for people are will be dedicated to their work and to our cause.
		</p>
		<p style="color: var(--color-text-dim);">- Max Tran, 2026 Summer Intern</p>
		<br />
		<h3>Swarit's Note</h3>
		<p></p>
		<h3>Astra's Note</h3>
		<p></p>
		<h3>Sahil's Note</h3>
		<p></p>
		<h3>Rushil's Note</h3>
		<p>
			Hey y’all, my name is Rushil and I’m a philanthropy intern at Hack Club. My journey started
			two summers ago when I stumbled upon Hack Club while scrolling through GitHub, and since then
			it’s been a wild ride. I’ve met lifelong friends, experienced both tears of joy and
			frustration, and grown more than I ever expected. Hack Club is for everyone--coder or not--and
			if you dive in, you’ll find yourself surrounded by people who inspire you and push you to
			build amazing things. Embark on the adventure, and great things will happen.
		</p>
		<p style="color: var(--color-text-dim);">- Rushil Chopra, 2026 Summer Intern</p>
	</div>
</div>

<style>
	.novella-container {
		padding: clamp(80px, 10vw, 177px) clamp(24px, 8.3vw, 159px) clamp(60px, 8vw, 160px);
	}

	.novella-inner {
		max-width: 860px;
		margin: 0 auto;
		display: flex;
		flex-direction: column;
		gap: clamp(24px, 3vw, 36px);
	}

	h1,
	h2,
	h3 {
		font-family: 'Young Serif', serif;
	}

	h1 {
		font-size: clamp(40px, 4.3vw, 67px);
		color: var(--color-accent);
	}

	h2 {
		font-size: clamp(25px, 2.5vw, 41px);
	}

	h3 {
		font-size: clamp(18px, 2vw, 30px);
	}

	p {
		font-family: 'Glyseric';
		font-size: clamp(16px, 1.5vw, 24px);
		line-height: 1.6;
	}

	strong {
		font-size: clamp(18px, 1.65vw, 26px);
	}

	svg {
		box-sizing: border-box;
	}

	.back:hover {
		color: white;
	}

	@media (max-width: 768px) {
		div {
			width: 100vw;
		}
	}

	a {
		text-decoration: underline;
	}

	.back {
		position: absolute;
		top: 0;
		left: 0;
		z-index: 10;
		font-family: Glyseric, Newsreader, Georgia, serif;
		font-size: 20px;
		color: #ffffff80;
		text-decoration: none;
		padding: 12px 16px;
		display: flex;
		align-items: center;
		gap: 6px;
		width: fit-content;
		transition: color 0.2s ease;
		box-sizing: border-box;
		text-decoration: none;
	}
</style>
