<script lang="ts">
	import { onMount } from 'svelte';
	import { fade } from 'svelte/transition';
	import { bottomCarouselImages, topCarouselImages } from '$lib/carousel';
	import './page.css';

	//** IMPORTANT: CHANGE LATER TO ACTUAL DUE DATE FOR APPLICATION **
	const DUE_YEAR: number = 2026;
	const DUE_MONTH: number = 4;
	const DUE_DAY: number = 24;

	const dueDate: Date = new Date(DUE_YEAR, DUE_MONTH - 1, DUE_DAY);
	const daysUntilDue: number = Math.ceil((dueDate.getTime() - Date.now()) / 86400000);

	const topStripImages = [...topCarouselImages, ...topCarouselImages];
	const bottomStripImages = [...bottomCarouselImages, ...bottomCarouselImages];

	let topStripA: HTMLDivElement | undefined;
	let topStripB: HTMLDivElement | undefined;
	let bottomStripA: HTMLDivElement | undefined;
	let bottomStripB: HTMLDivElement | undefined;

	const TOP_SPEED = 75;
	const BOTTOM_SPEED = 75;
	const WORD_SEPARATOR = ' ';
	const HERO_HIGHLIGHT_WORDS = ['hackers', 'builders', 'programmers'];

	let heroHighlightWordIndex = $state(0);

	function startTeleportLoop(
		stripA: HTMLDivElement,
		stripB: HTMLDivElement,
		direction: 1 | -1,
		speed: number
	) {
		let frameId = 0;
		let lastTimestamp = 0;
		let stripWidth = 0;
		let positionA = 0;
		let positionB = 0;

		const applyPositions = () => {
			stripA.style.transform = `translate3d(${positionA}px, 0, 0)`;
			stripB.style.transform = `translate3d(${positionB}px, 0, 0)`;
		};

		const resetPositions = () => {
			stripWidth = stripA.getBoundingClientRect().width;
			if (stripWidth <= 0) return;

			if (direction === -1) {
				positionA = 0;
				positionB = stripWidth;
			} else {
				positionA = -stripWidth;
				positionB = 0;
			}

			applyPositions();
		};

		const animate = (timestamp: number) => {
			if (!stripWidth) {
				frameId = requestAnimationFrame(animate);
				return;
			}

			if (!lastTimestamp) {
				lastTimestamp = timestamp;
			}

			const deltaSeconds = (timestamp - lastTimestamp) / 1000;
			lastTimestamp = timestamp;

			const movement = speed * deltaSeconds * direction;
			positionA += movement;
			positionB += movement;

			if (direction === -1) {
				if (positionA <= -stripWidth) positionA = positionB + stripWidth;
				if (positionB <= -stripWidth) positionB = positionA + stripWidth;
			} else {
				if (positionA >= stripWidth) positionA = positionB - stripWidth;
				if (positionB >= stripWidth) positionB = positionA - stripWidth;
			}

			applyPositions();
			frameId = requestAnimationFrame(animate);
		};

		const resizeObserver = new ResizeObserver(() => {
			resetPositions();
			lastTimestamp = 0;
		});

		resizeObserver.observe(stripA);
		window.addEventListener('resize', resetPositions);
		resetPositions();
		frameId = requestAnimationFrame(animate);

		return () => {
			cancelAnimationFrame(frameId);
			resizeObserver.disconnect();
			window.removeEventListener('resize', resetPositions);
		};
	}

	onMount(() => {
		const scrollDown = document.getElementById('scroll-down') as HTMLParagraphElement;
		scrollDown.addEventListener('click', () => {
			const opacity = parseFloat(getComputedStyle(scrollDown).opacity);
			if (opacity < 1) return;

			const container = document.querySelector('.hero-scroll-container') as HTMLElement;
			const scrollableHeight = container.scrollHeight - window.innerHeight;
			window.scrollTo({
				top: scrollableHeight * 0.85,
				behavior: 'smooth'
			});
		});

		if (!topStripA || !topStripB || !bottomStripA || !bottomStripB) {
			return;
		}

		const heroWordInterval = window.setInterval(() => {
			heroHighlightWordIndex = (heroHighlightWordIndex + 1) % HERO_HIGHLIGHT_WORDS.length;
		}, 1500);

		const stopTop = startTeleportLoop(topStripA, topStripB, -1, TOP_SPEED);
		const stopBottom = startTeleportLoop(bottomStripA, bottomStripB, 1, BOTTOM_SPEED);

		return () => {
			window.clearInterval(heroWordInterval);
			stopTop();
			stopBottom();
		};
	});

	type Token =
		| { type: 'word'; text: string; bold?: boolean; accent?: boolean }
		| { type: 'break' }
		| { type: 'underline'; text: string };

	const TYPING_TOKENS: Token[] = [
		{ type: 'word', text: 'Hack' },
		{ type: 'word', text: 'Club' },
		{ type: 'word', text: 'is' },
		{ type: 'word', text: 'an' },
		{ type: 'word', text: 'international' },
		{ type: 'word', text: 'nonprofit' },
		{ type: 'word', text: 'organization' },
		{ type: 'word', text: 'of' },
		{ type: 'word', text: 'teenagers' },
		{ type: 'word', text: 'who' },
		{ type: 'word', text: 'code' },
		{ type: 'word', text: 'together.' },
		{ type: 'word', text: "We're" },
		{ type: 'word', text: 'also' },
		{ type: 'word', text: 'a' },
		{ type: 'word', text: 'community,' },
		{ type: 'word', text: 'run' },
		{ type: 'word', text: 'by' },
		{ type: 'word', text: 'teenagers' },
		{ type: 'word', text: 'for' },
		{ type: 'word', text: 'teenagers,' },
		{ type: 'word', text: 'full' },
		{ type: 'word', text: 'of' },
		{ type: 'word', text: 'amazing' },
		{ type: 'word', text: 'people' },
		{ type: 'word', text: 'and' },
		{ type: 'word', text: 'amazing' },
		{ type: 'word', text: 'stories.' },
		{ type: 'break' },
		{ type: 'word', text: "We're" },
		{ type: 'word', text: 'looking' },
		{ type: 'word', text: 'for' },
		{ type: 'word', text: 'storytellers', bold: true, accent: true },
		{ type: 'word', text: '- people' },
		{ type: 'word', text: 'who' },
		{ type: 'word', text: 'can' },
		{ type: 'word', text: 'use' },
		{ type: 'word', text: 'a' },
		{ type: 'word', text: 'camera' },
		{ type: 'word', text: 'as' },
		{ type: 'word', text: 'a' },
		{ type: 'word', text: 'window' },
		{ type: 'word', text: 'into' },
		{ type: 'word', text: 'our' },
		{ type: 'word', text: 'world -' },
		{ type: 'word', text: 'and' },
		{ type: 'word', text: "we're" },
		{ type: 'word', text: 'looking' },
		{ type: 'word', text: 'for' },
		{ type: 'word', text: 'you' },
		{ type: 'word', text: 'to' },
		{ type: 'underline', text: 'tell our stories.' }
	];

	let heroScrollContainer: HTMLDivElement | undefined;

	onMount(() => {
		if (!heroScrollContainer) return;

		const heroEl = heroScrollContainer.querySelector<HTMLElement>('.hero');
		const carouselTop = heroScrollContainer.querySelector<HTMLElement>('.carousel-top');
		const carouselBottom = heroScrollContainer.querySelector<HTMLElement>('.carousel-bottom');
		const typingWordEls = heroScrollContainer.querySelectorAll<HTMLElement>('.typing-word');
		const total = typingWordEls.length;
		const scrollDownEl = document.getElementById('scroll-down') as HTMLElement;

		const onScroll = () => {
			if (!heroScrollContainer) return;
			const rect = heroScrollContainer.getBoundingClientRect();
			const scrollableHeight = rect.height - window.innerHeight;
			const progress = Math.max(0, Math.min(1, -rect.top / scrollableHeight));

			const heroFade = Math.max(0, Math.min(1, (progress - 0.1) / 0.18));
			if (heroEl) heroEl.style.opacity = String(1 - heroFade);
			scrollDownEl.style.pointerEvents = heroFade > 0 ? 'none' : 'auto';

			const wordProgress = Math.max(0, Math.min(1, (progress - 0.38) / 0.47));
			const fadeWindow = 3 / total;

			typingWordEls.forEach((word, i) => {
				const start = (i / (total - 1)) * (1 - fadeWindow);
				const wp = Math.max(0, Math.min(1, (wordProgress - start) / fadeWindow));
				word.style.opacity = String(wp);

				if (word.classList.contains('typing-underline')) {
					word.classList.toggle('underline-visible', wp > 0.5);
				}
			});

			const carouselProgress = Math.max(0, Math.min(1, (progress - 0.93) / 0.07));
			if (carouselTop) {
				carouselTop.style.transform = `translateY(${-carouselProgress * 110}%)`;
				carouselTop.style.opacity = String(1 - carouselProgress);
			}
			if (carouselBottom) {
				carouselBottom.style.transform = `translateY(${carouselProgress * 100}%)`;
				carouselBottom.style.opacity = String(1 - carouselProgress);
			}
		};

		window.addEventListener('scroll', onScroll, { passive: true });
		onScroll();

		return () => window.removeEventListener('scroll', onScroll);
	});
</script>

<div class="hero-scroll-container" bind:this={heroScrollContainer}>
	<div class="carousel-page">
		<div class="carousel-viewport carousel-top">
			<div class="teleport-strip" bind:this={topStripA}>
				{#each topStripImages as src, index (`top-a-${index}`)}
					<div class="image-card">
						<img {src} alt="Carousel item" draggable="false" />
					</div>
				{/each}
			</div>
			<div class="teleport-strip" bind:this={topStripB} aria-hidden="true">
				{#each topStripImages as src, index (`top-b-${index}`)}
					<div class="image-card">
						<img {src} alt="Carousel item" draggable="false" />
					</div>
				{/each}
			</div>
		</div>

		<div class="herocontainer">
			<div class="hero">
				<div class="text">
					<img
						class="hero-flag"
						src="https://assets.hackclub.com/flag-standalone-wtransparent.svg"
						alt="Hack Club flag"
					/>
					<h1 id="title">tell our stories.</h1>
					<p id="body">
						Hack Club is hiring 2 teenagers to record the stories
						<span class="hero-body-crossfade-wrapper">
							<span class="hero-body-crossfade hero-body-crossfade-sizer" aria-hidden="true">
								of the next generation of <strong class="hero-highlight"
									>{HERO_HIGHLIGHT_WORDS.reduce((a, b) => (a.length >= b.length ? a : b))}.</strong
								>
							</span>
							{#key heroHighlightWordIndex}
								<span
									class="hero-body-crossfade"
									in:fade={{ duration: 350 }}
									out:fade={{ duration: 350 }}
								>
									of the next generation of <strong class="hero-highlight"
										>{HERO_HIGHLIGHT_WORDS[heroHighlightWordIndex]}.</strong
									>
								</span>
							{/key}
						</span>
					</p>
				</div>
				<div class="button">
					<a
						style="margin-top: 2vh;"
						href="https://forms.hackclub.com/mediafellowship"
						class="apply-button">Apply Now ({daysUntilDue} days remaining)</a
					>
				</div>
				<p id="scroll-down">Scroll down to read <span id="scroll-down-arrow">↓</span></p>
			</div>
		</div>

		<div class="carousel-viewport carousel-bottom">
			<div class="teleport-strip" bind:this={bottomStripA}>
				{#each bottomStripImages as src, index (`bottom-a-${index}`)}
					<div class="image-card">
						<img {src} alt="Carousel item" draggable="false" />
					</div>
				{/each}
			</div>
			<div class="teleport-strip" bind:this={bottomStripB} aria-hidden="true">
				{#each bottomStripImages as src, index (`bottom-b-${index}`)}
					<div class="image-card">
						<img {src} alt="Carousel item" draggable="false" />
					</div>
				{/each}
			</div>
		</div>

		<div class="typing-overlay" id="first-intro">
			<p class="typing-text">
				{#each TYPING_TOKENS as token, i (i)}
					{#if token.type === 'break'}
						<br class="typing-word" />
					{:else if token.type === 'underline'}
						<span class="typing-word typing-underline">{token.text}</span>{WORD_SEPARATOR}
					{:else if token.accent}
						<span class="typing-word accent">{token.text}</span>{WORD_SEPARATOR}
					{:else}
						<span class="typing-word">{token.text}</span>{WORD_SEPARATOR}
					{/if}
				{/each}
			</p>
		</div>
	</div>
</div>

<section class="fellowship-section">
	<h2 class="title">Introducing the Hack Club Media Gap Year Fellowship</h2>
	<p class="fellowship-body">
		This is a paid, full-time, in-person role. $50k/year + all travel covered + healthcare &
		benefits. It's intended to be something you do for a year before you go to college or whatever
		your plans are after high school, but if you are on an alternate schooling path, that works too!<br
		/><br />You will be spending time at Hack Club HQ, working on projects and making videos with
		the team, as well as travelling all over the world to different Hack Club events!<br /><br
		/><strong>The job:</strong> Make Hack Club a household name. Reach new audiences and as many teens
		as you can.
	</p>
	<div class="button">
		<a href="https://forms.hackclub.com/mediafellowship" class="apply-button"
			>Apply Now ({daysUntilDue} days remaining)</a
		>
	</div>
</section>

<section class="hack-club-section">
	<h2 class="title">So what is Hack Club?</h2>
	<p class="hc-body">
		We are a 501(c)(3) global non-profit organization based in the U.S. aimed at supporting
		teenagers worldwide interested in engineering and coding to develop and grow. In the past we've
		... [PLACEHOLDER]
	</p>
	<div class="button-container">
		<div class="button">
			<a id="linkButton" href="https://www.youtube.com/channel/UCQzO0jpcRkP-9eWKMpJyB0w"><svg fill-rule="evenodd" clip-rule="evenodd" stroke-linejoin="round" stroke-miterlimit="1.414" xmlns="http://www.w3.org/2000/svg" aria-label="youtube" viewBox="0 0 32 32" preserveAspectRatio="xMidYMid meet" fill="currentColor" width="48" height="48" title="youtube"><path d="M20.0065 15.7665L13.5265 19.1265L13.522 12.384L20.0065 15.7665Z"></path><path d="M15.7501 6C20.8501 6 22.9971 6.576 24.0861 7.665C25.1751 8.754 25.7501 10.9 25.7501 16C25.7501 21.1 25.1751 23.247 24.0861 24.336C22.9971 25.425 20.8501 26 15.7501 26C10.6501 26 8.50306 25.425 7.41406 24.336C6.32506 23.247 5.75006 21.1 5.75006 16C5.75006 10.9 6.32506 8.753 7.41406 7.665C8.50306 6.576 10.6501 6 15.7501 6ZM27.7501 16C27.7501 6 25.7501 4 15.7501 4C5.75006 4 3.75006 6 3.75006 16C3.75006 26 5.75006 28 15.7501 28C25.7501 28 27.7501 26 27.7501 16Z"></path></svg></a>
		</div>
		<div class="button">
			<a id="linkButton" href="https://www.instagram.com/starthackclub/"><svg fill-rule="evenodd" clip-rule="evenodd" stroke-linejoin="round" stroke-miterlimit="1.414" xmlns="http://www.w3.org/2000/svg" aria-label="instagram" viewBox="0 0 32 32" preserveAspectRatio="xMidYMid meet" fill="currentColor" width="48" height="48" title="instagram"><path d="M16 6c5.1 0 7.247.575 8.336 1.664C25.425 8.753 26 10.9 26 16s-.575 7.247-1.664 8.336C23.247 25.425 21.1 26 16 26s-7.247-.575-8.336-1.664C6.575 23.247 6 21.1 6 16s.575-7.247 1.664-8.336C8.753 6.575 10.9 6 16 6zm0-2c10 0 12 2 12 12s-2 12-12 12S4 26 4 16 6 4 16 4z"></path><path d="M16 9.838a6.162 6.162 0 1 0 0 12.324 6.162 6.162 0 1 0 0-12.324zM16 20a4 4 0 1 1 0-8 4 4 0 0 1 0 8zm7.845-10.405a1.44 1.44 0 1 1-2.88 0 1.44 1.44 0 0 1 2.88 0z"></path></svg></a>
		</div>
	</div>
</section>

<section class="hwyd-section">
	<h2 class="title">Here's what you'll do.</h2>
	<div class="hwyd-panel">
		<img
			class="panel-img left"
			alt="Collage of Hack Club events"
			src="https://cdn.hackclub.com/019d6191-88a7-7daa-b4c0-fdcae2fffa38/attend_hc_events.png"
		/>
		<div class="panel-text right">
			<h3 class="stitle">Travel the world for Hack Club events</h3>
			<p class="sbody">
				Hack Club hosts hundreds of events across the globe every year. You'll promote, attend,
				document, and create content for them.
			</p>
		</div>
	</div>
	<div class="hwyd-panel">
		<div class="panel-text left">
			<h3 class="stitle">Run our social media</h3>
			<p class="sbody">
				Own our presence across YouTube, Instagram, TikTok, Twitter, and more. You'll post
				frequently and craft compelling stories alongside our community.
			</p>
		</div>
		<img
			class="panel-img right"
			alt="Collage of Hack Club events"
			src="https://cdn.hackclub.com/019d657c-8346-7a39-acbf-e083a5e26edf/image%20(13).png"
		/>
	</div>
	<div class="hwyd-panel">
		<img
			class="panel-img left"
			alt="Michael Reeves that I stole off the internet"
			src="https://mediaproxy.tvtropes.org/width/1200/https://static.tvtropes.org/pmwiki/pub/images/mykull_6.png"
		/>
		<div class="panel-text right">
			<h3 class="stitle">Get mentored by Open Sauce creators</h3>
			<p class="sbody">
				Work directly with creators from Open Sauce, like Michael Reeves and William Osman,
				receiving hands-on mentorship while collaborating on content.
			</p>
		</div>
	</div>
</section>

<section class="cta-section">
	<h1 class="title">The door is open.</h1>
	<div class="button">
		<a href="https://forms.hackclub.com/mediafellowship" class="apply-button"
			>Apply Now ({daysUntilDue} days remaining)</a
		>
	</div>
	<div class="button-container">
		<div class="button">
			<a id="linkButton">Read the Hacker Novella ↗</a>
		</div>
	</div>
</section>

<section class="footer">
	<p>
		© 2026 <u><a href="https://hackclub.com">Hack Club</a></u>. 501(c)(3) nonprofit (EIN:
		81-2908499)
	</p>
	<p>
		made with &lt;3 by <u><a href="https://github.com/hellonearth311">hellonearth311</a></u>,
		<u><a href="https://github.com/sadeshmukh">sadeshmukh</a></u>,
		<u><a href="https://github.com/maxstellar">maxstellar</a></u>, and
		<u><a href="https://github.com/astra-the-boop">astra celestine</a></u>.
		<u><a href="https://github.com/hackclub/novella">always OSS</a>.</u>
	</p>
</section>
