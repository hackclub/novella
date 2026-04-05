<script lang="ts">
	import { onMount } from 'svelte';
	import { bottomCarouselImages, topCarouselImages } from '$lib/carousel';
	import './page.css';

	const topStripImages = [...topCarouselImages, ...topCarouselImages];
	const bottomStripImages = [...bottomCarouselImages, ...bottomCarouselImages];

	let topStripA: HTMLDivElement | undefined;
	let topStripB: HTMLDivElement | undefined;
	let bottomStripA: HTMLDivElement | undefined;
	let bottomStripB: HTMLDivElement | undefined;

	const TOP_SPEED = 75;
	const BOTTOM_SPEED = 75;
	const WORD_SEPARATOR = ' ';

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
			const container = document.querySelector('.hero-scroll-container') as HTMLElement;
			const scrollableHeight = container.scrollHeight - window.innerHeight;
			console.log('test');
			window.scrollTo({
				top: scrollableHeight * 0.85,
				behavior: 'smooth'
			});
		});

		if (!topStripA || !topStripB || !bottomStripA || !bottomStripB) {
			return;
		}

		const stopTop = startTeleportLoop(topStripA, topStripB, -1, TOP_SPEED);
		const stopBottom = startTeleportLoop(bottomStripA, bottomStripB, 1, BOTTOM_SPEED);

		return () => {
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
		{ type: 'word', text: '— people' },
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
		{ type: 'word', text: 'world —' },
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

		const onScroll = () => {
			if (!heroScrollContainer) return;
			const rect = heroScrollContainer.getBoundingClientRect();
			const scrollableHeight = rect.height - window.innerHeight;
			const progress = Math.max(0, Math.min(1, -rect.top / scrollableHeight));

			// Hero text fades out: progress 0.2→0.38
			const heroFade = Math.max(0, Math.min(1, (progress - 0.2) / 0.18));
			if (heroEl) heroEl.style.opacity = String(1 - heroFade);

			// Words type in: progress 0.38→0.85 (carousels still visible as backdrop)
			const wordProgress = Math.max(0, Math.min(1, (progress - 0.38) / 0.47));
			const fadeWindow = 3 / total;

			typingWordEls.forEach((word, i) => {
				const start = (i / (total - 1)) * (1 - fadeWindow);
				const wp = Math.max(0, Math.min(1, (wordProgress - start) / fadeWindow));
				word.style.opacity = String(wp);

				// Trigger underline draw once the span is mostly faded in
				if (word.classList.contains('typing-underline')) {
					word.classList.toggle('underline-visible', wp > 0.5);
				}
			});

			// Top carousel slides up, bottom carousel fades out: progress 0.85→1.0
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
						src="https://cdn.hackclub.com/019d5fd7-0e18-76e5-bd56-5ce00ae54238/flag.svg"
						alt="Hack Club flag"
						draggable="false"
					/>
					<h1 id="title">tell our stories.</h1>
					<p id="body">
						Hack Club is hiring 2 teenagers for a paid gap year to create videos, films, and other
						content for Hack Club's social media.
					</p>
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
		This is a paid full-time in person role. $50k/year + all travel covered + healthcare & benefits.
		It's intended to be something you do for a year before you go to college or whatever your plans
		are after high school, but if you are on an alternate schooling path that works too!<br /><br
		/>You will be spending time at Hack Club HQ, working on projects and making videos with the
		team, as well as travelling all over the world to different Hack Club events!<br /><br /><strong
			>The job:</strong
		> Make Hack Club a household name. Reach new audiences and as many teens as you can.
	</p>
	<br />
	<div class="button">
		<a id="applyButton" href="https://example.com">Apply Now (x days remaining)</a>
	</div>
</section>

<section class="hwyd-section">
	<h2 class="title">Here's what you'll do.</h2>
	<div class="hwyd-panel right">
		<div class="panel-text">
			<h3 class="stitle">Travel to Hack Club events</h3>
			<p class="sbody">
				Hack Club hosts hundreds of events across the globe every year. You'll promote, attend,
				document, and create content for them.
			</p>
		</div>
	</div>
</section>
