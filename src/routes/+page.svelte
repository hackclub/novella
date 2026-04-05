<script lang="ts">
	import { onMount } from 'svelte';
	import { carouselImages } from '$lib/carousel';
	import './page.css';

	const stripImages = [...carouselImages, ...carouselImages];

	let topStripA: HTMLDivElement | undefined;
	let topStripB: HTMLDivElement | undefined;
	let bottomStripA: HTMLDivElement | undefined;
	let bottomStripB: HTMLDivElement | undefined;

	const TOP_SPEED = 75;
	const BOTTOM_SPEED = 75;

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

	const TYPING_TEXT =
		"Hack Club is an international nonprofit organization of teenagers who code together. We're also a community, run by teenagers for teenagers, full of amazing people and amazing stories--and we're looking for you to tell them.";

	let heroScrollContainer: HTMLDivElement | undefined;

	onMount(() => {
		if (!heroScrollContainer) return;

		const heroEl = heroScrollContainer.querySelector<HTMLElement>('.hero');
		const carouselTop = heroScrollContainer.querySelector<HTMLElement>('.carousel-top');
		const carouselBottom = heroScrollContainer.querySelector<HTMLElement>('.carousel-bottom');
		const typingWordEls = heroScrollContainer.querySelectorAll<HTMLSpanElement>('.typing-word');
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
				word.style.top = `${(1 - wp) * 10}px`;
			});

			// Top carousel slides up, bottom carousel fades out: progress 0.85→1.0
			const carouselProgress = Math.max(0, Math.min(1, (progress - 0.85) / 0.15));
			if (carouselTop) carouselTop.style.transform = `translateY(${-carouselProgress * 110}%)`;
			if (carouselBottom) carouselBottom.style.opacity = String(1 - carouselProgress);
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
				{#each stripImages as src, index (`top-a-${index}`)}
					<div class="image-card">
						<img {src} alt="Carousel item" draggable="false" />
					</div>
				{/each}
			</div>
			<div class="teleport-strip" bind:this={topStripB} aria-hidden="true">
				{#each stripImages as src, index (`top-b-${index}`)}
					<div class="image-card">
						<img {src} alt="Carousel item" draggable="false" />
					</div>
				{/each}
			</div>
		</div>

		<div class="herocontainer">
			<div class="hero">
				<div class="text">
					<h1 id="title">tell our stories.</h1>
					<p id="body">
						Hack Club is hiring 2 teenagers for a paid gap year to create videos, films, and other
						content for Hack Club's social media.
					</p>
				</div>

				<div class="button">
					<a id="applyButton" href="https://example.com">Apply Now (x days remaining)</a>
				</div>
			</div>
		</div>

		<div class="carousel-viewport carousel-bottom">
			<div class="teleport-strip" bind:this={bottomStripA}>
				{#each stripImages as src, index (`bottom-a-${index}`)}
					<div class="image-card">
						<img {src} alt="Carousel item" draggable="false" />
					</div>
				{/each}
			</div>
			<div class="teleport-strip" bind:this={bottomStripB} aria-hidden="true">
				{#each stripImages as src, index (`bottom-b-${index}`)}
					<div class="image-card">
						<img {src} alt="Carousel item" draggable="false" />
					</div>
				{/each}
			</div>
		</div>

		<div class="typing-overlay">
			<p class="typing-text">
				<!-- eslint-disable svelte/no-useless-mustaches -->
				{#each TYPING_TEXT.split(' ') as word, i (i)}<span class="typing-word">{word}</span
					>{' '}{/each}
				<!-- eslint-enable svelte/no-useless-mustaches -->
			</p>
		</div>
	</div>
</div>

<section class="fellowship-section">
	<h2 class="fellowship-title">Introducing the Hack Club Media Gap Year Fellowship</h2>
	<p class="fellowship-body">
		This is a paid full-time in person role. $50k/year + all travel covered + healthcare & benefits.
		You will be spending time at Hack Club HQ as well as travelling all over the world to different
		Hack Club events. It's intended to be something you do for a year before you go to college or
		whatever your plans are after high school, but if you are on an alternate schooling path that
		works too!
	</p>
</section>
