<script lang="ts">
	import { resolve } from '$app/paths';
	import { onMount } from 'svelte';
	import { fade } from 'svelte/transition';
	import { bottomCarouselImages, topCarouselImages } from '$lib/carousel';
	import './page.css';

	const novella = resolve('/novella');

	const DUE_YEAR: number = 2026;
	const DUE_MONTH: number = 4;
	const DUE_DAY: number = 30;

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
	const HERO_HIGHLIGHT_WORDS = ['hackers', 'builders', 'programmers', 'artists'];

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
		}, 2000);

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
		| { type: 'underline'; text: string }
		| { type: 'link'; text: string; href: string };

	const TYPING_TOKENS: Token[] = [
		{ type: 'link', text: 'Hack Club', href: 'https://hackclub.com' },
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
		{ type: 'word', text: 'or' },
		{ type: 'word', text: 'a' },
		{ type: 'word', text: 'stylus' },
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
				<div class="hero-row">
					<div class="hero-left">
						<div class="text">
							<img
								class="hero-flag"
								src="https://assets.hackclub.com/flag-standalone-wtransparent.svg"
								alt="Hack Club flag"
							/>
							<h1 id="title">tell our stories.</h1>
							<p id="body">
								Hack Club is hiring 2 teenage filmmakers to travel the world making films about the
								next generation of
								<span class="hero-body-crossfade-wrapper">
									<span class="hero-body-crossfade hero-body-crossfade-sizer" aria-hidden="true">
										<strong class="hero-highlight"
											>{HERO_HIGHLIGHT_WORDS.reduce((a, b) =>
												a.length >= b.length ? a : b
											)}.</strong
										>
									</span>
									{#key heroHighlightWordIndex}
										<span
											class="hero-body-crossfade"
											in:fade={{ duration: 350 }}
											out:fade={{ duration: 350 }}
										>
											<strong class="hero-highlight"
												>{HERO_HIGHLIGHT_WORDS[heroHighlightWordIndex]}.</strong
											>
										</span>
									{/key}
								</span>
							</p>
							<p
								style="font-size: clamp(12px, 1.8vh, 22px); color: #aaa; letter-spacing: 0.05em; margin-top: 0.5em;"
							>
								Full-time, in-person &middot; June 2026 - August 2027, $50k/year
								&middot; $10k travel + $5k equipment budget
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
					<figure class="hero-video-figure">
						<p class="hero-video-annotation">
							made by <a
								href="https://www.instagram.com/paoloaverycarino/"
								target="_blank"
								rel="noopener noreferrer"
								style="text-decoration: underline; color: inherit;">Paolo</a
							>, our media gap year last year ↓
						</p>
						<iframe
							class="hero-video"
							src="https://www.youtube-nocookie.com/embed/kkbf092Los0?autoplay=1&mute=1&controls=0&loop=1&playlist=kkbf092Los0&modestbranding=0"
							title="Hack Club Media"
							frameborder="0"
							allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
							allowfullscreen
						></iframe>
						<figcaption class="hero-video-caption">
							<a
								href="https://shiba.hackclub.com"
								target="_blank"
								rel="noopener noreferrer"
								style="text-decoration: underline;">Hack Club Shiba</a
							> - Nov, 2025 in Tokyo, Japan
						</figcaption>
					</figure>
				</div>
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
					{:else if token.type === 'link'}
						<!-- eslint-disable svelte/no-navigation-without-resolve -->
						<a
							class="typing-word"
							href={token.href}
							target="_blank"
							rel="noopener noreferrer"
							style="text-decoration: underline; color: inherit; pointer-events: auto;"
							>{token.text}</a
						>{WORD_SEPARATOR}
						<!-- eslint-enable svelte/no-navigation-without-resolve -->
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
		This is a paid, full-time, in-person role from June 2026 - August 2027. $50k/year
		+ $5k equipment stipend + $10k travel + healthcare & benefits at Hack Club HQ in Burlington,
		Vermont.
	</p>
	<p class="fellowship-body">
		It's intended to be something you do for a year before you go to college or whatever your plans
		are after high school, but if you are on an alternate schooling path, that works too!<br /><br
		/>You will be based at Hack Club HQ, working on projects and making videos with the team, as
		well as travelling all over the world to different Hack Club events!<br /><br /><strong
			>The job:</strong
		> Make Hack Club a household name. Reach new audiences and as many teens as you can.
	</p>
	<div class="button">
		<a href="https://forms.hackclub.com/mediafellowship" class="apply-button"
			>Apply Now ({daysUntilDue} days remaining)</a
		>
	</div>
</section>

<section class="hack-club-section">
	<h2 class="title">
		What even is <span id="hack-club"
			><a href="https://hackclub.com" target="_blank">Hack Club</a></span
		>?
	</h2>
	<div class="button-container">
		<div class="button">
			<a id="linkButton" aria-label="YouTube" href="https://www.youtube.com/@hackclubhq"
				><svg
					fill-rule="evenodd"
					clip-rule="evenodd"
					stroke-linejoin="round"
					stroke-miterlimit="1.414"
					xmlns="http://www.w3.org/2000/svg"
					aria-label="youtube"
					viewBox="0 0 32 32"
					preserveAspectRatio="xMidYMid meet"
					fill="currentColor"
					width="48"
					height="48"
					><path d="M20.0065 15.7665L13.5265 19.1265L13.522 12.384L20.0065 15.7665Z"></path><path
						d="M15.7501 6C20.8501 6 22.9971 6.576 24.0861 7.665C25.1751 8.754 25.7501 10.9 25.7501 16C25.7501 21.1 25.1751 23.247 24.0861 24.336C22.9971 25.425 20.8501 26 15.7501 26C10.6501 26 8.50306 25.425 7.41406 24.336C6.32506 23.247 5.75006 21.1 5.75006 16C5.75006 10.9 6.32506 8.753 7.41406 7.665C8.50306 6.576 10.6501 6 15.7501 6ZM27.7501 16C27.7501 6 25.7501 4 15.7501 4C5.75006 4 3.75006 6 3.75006 16C3.75006 26 5.75006 28 15.7501 28C25.7501 28 27.7501 26 27.7501 16Z"
					></path></svg
				></a
			>
		</div>
		<div class="button">
			<a id="linkButton" aria-label="Instagram" href="https://www.instagram.com/starthackclub/"
				><svg
					fill-rule="evenodd"
					clip-rule="evenodd"
					stroke-linejoin="round"
					stroke-miterlimit="1.414"
					xmlns="http://www.w3.org/2000/svg"
					aria-label="instagram"
					viewBox="0 0 32 32"
					preserveAspectRatio="xMidYMid meet"
					fill="currentColor"
					width="48"
					height="48"
					><path
						d="M16 6c5.1 0 7.247.575 8.336 1.664C25.425 8.753 26 10.9 26 16s-.575 7.247-1.664 8.336C23.247 25.425 21.1 26 16 26s-7.247-.575-8.336-1.664C6.575 23.247 6 21.1 6 16s.575-7.247 1.664-8.336C8.753 6.575 10.9 6 16 6zm0-2c10 0 12 2 12 12s-2 12-12 12S4 26 4 16 6 4 16 4z"
					></path><path
						d="M16 9.838a6.162 6.162 0 1 0 0 12.324 6.162 6.162 0 1 0 0-12.324zM16 20a4 4 0 1 1 0-8 4 4 0 0 1 0 8zm7.845-10.405a1.44 1.44 0 1 1-2.88 0 1.44 1.44 0 0 1 2.88 0z"
					></path></svg
				></a
			>
		</div>
	</div>
	<p class="hc-body">
		We are a 501(c)(3) global non-profit organization based in the United States. We host real
		adventures, run online programs, and provide community for technical teenagers! Every year, our
		community creates <a
			href="https://magazine.hackclub.com"
			target="_blank"
			rel="noopener noreferrer"
			style="text-decoration: underline;">thousands of amazing projects</a
		>, and we ship out thousands of cool prizes, from stickers to laptops to plushies of our mascot!
	</p>
	<section class="videos-body">
		<h1 class="title">Some videos we've posted before:</h1>
		<div id="video-disclaimer-container">
			<h3>
				Disclaimer: You don't have to follow this style! It's just an example of what we've posted
				before
			</h3>
		</div>

		<div id="videos-container">
			<div class="video-container">
				<iframe
					id="fallout"
					src="https://www.youtube-nocookie.com/embed/SrP2ZeNHm6s?si=kxVdUXMkOMGhsxXS"
					title="YouTube video player"
					frameborder="0"
					allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
					referrerpolicy="strict-origin-when-cross-origin"
					allowfullscreen
					loading="lazy"
				></iframe>
				<p class="videos-subtext">
					Fallout: An upcoming hardware hackathon taking place in Shenzhen, China this summer!
				</p>
			</div>
			<div class="video-container">
				<iframe
					id="shipwrecked"
					src="https://www.youtube-nocookie.com/embed/uXWMr0gdLJA?si=Vb4hK6MBO0E5RDWB"
					title="YouTube video player"
					frameborder="0"
					allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
					referrerpolicy="strict-origin-when-cross-origin"
					allowfullscreen
					loading="lazy"
				></iframe>
				<p class="videos-subtext">
					Shipwrecked: A four-day hackathon on a private island we organized last summer!
				</p>
			</div>
		</div>
	</section>
</section>

<section class="past-events">
	<h1 class="title">In the past year, we have organized...</h1>
	<div class="programs-grid">
		<a class="program-card" href="https://flagship.hackclub.com" target="_blank" rel="noopener">
			<img
				class="program-card-img"
				src="https://cdn.hackclub.com/019d9226-a5ac-7d49-8361-46f200cd9cf9/cdn.hackclub.com__019d75da-13a0-755c-9260-3a7a839e6c2b__image.png.webp"
				alt="Campfire Flagship"
			/>
			<img
				class="program-card-logo"
				src="https://cdn.hackclub.com/019d9226-9ff2-7589-9cfd-54493d929d8a/cdn.hackclub.com__019d75d9-1b8c-780a-a990-1c6b65473906__image.png.webp"
				alt="Campfire Flagship logo"
			/>
			<p class="program-card-desc">
				A 3 day flagship game jam in Los Angeles with YouTubers like Michael Reeves, William Osman,
				and many more!
			</p>
		</a>

		<a class="program-card" href="https://midnight.hackclub.com" target="_blank" rel="noopener">
			<img
				class="program-card-img"
				src="https://cdn.hackclub.com/019d9226-1711-7159-9392-7dd842277185/manifesto.hackclub.com__images__midnight.jpg.webp"
				alt="Midnight"
			/>
			<div class="midnight-logo">
				<img
					class="front program-card-logo"
					src="https://cdn.hackclub.com/019d9220-9c84-702a-b94e-2d30e50a499d/midnight-logo.webp"
					alt="Midnight logo"
				/>
			</div>
			<p class="program-card-desc">
				A murder-mystery hackathon held in Austria, Vienna with 60+ teenagers from all across the
				world!
			</p>
		</a>

		<a class="program-card" href="https://blueprint.hackclub.com" target="_blank" rel="noopener">
			<img
				class="program-card-img"
				src="https://cdn.hackclub.com/019d9226-06e7-728e-81ea-12f72df08181/manifesto.hackclub.com__images__blueprint.png.webp"
				alt="Blueprint"
			/>
			<img
				class="program-card-logo"
				src="https://cdn.hackclub.com/019d9226-b27a-7d56-b90f-d62b88efeb29/cdn.hackclub.com__019d75da-1a49-739f-8e97-b3f6f15961ce__image.png.webp"
				alt="Blueprint logo"
				style="width:300px"
			/>
			<p class="program-card-desc">
				From October 2025 to March 2026, Blueprint gave $140,000 to fund 1,500 hardware and
				electronics projects built by 1000 teenagers from 77 countries!
			</p>
		</a>

		<a class="program-card" href="https://siege.hackclub.com" target="_blank" rel="noopener">
			<img
				class="program-card-img"
				src="https://cdn.hackclub.com/019d9226-35c7-753a-999a-ff293fa6e3ed/manifesto.hackclub.com__images__siege.png.webp"
				alt="Siege"
			/>
			<img
				class="program-card-logo"
				src="https://cdn.hackclub.com/019d9226-bda0-7214-863f-fbe54de0d094/cdn.hackclub.com__019d75da-1ce9-7d50-9a52-53aadbfdfce7__image.png.webp"
				alt="Siege logo"
				style="width:161px"
			/>
			<p class="program-card-desc">
				A 14 week event where 250 teens created a project each week to work towards a laptop with
				over 100 Framework laptops given out!
			</p>
		</a>
	</div>
	<h2 id="andsomuchmore">and so much more!</h2>
	<div class="programs-more-grid">
		<a
			class="mini-card"
			href="https://summer.hackclub.com"
			target="_blank"
			rel="noopener"
			style="background-image:url('https://cdn.hackclub.com/019d9226-4624-7611-8f95-816315193e80/manifesto.hackclub.com__images__summer-of-making.png.webp');background-size:cover;background-position:bottom"
		>
			<img
				class="mini-card-logo"
				src="https://cdn.hackclub.com/019d9226-84ba-7696-ab5c-5676754ce263/manifesto.hackclub.com__images__som-logo.png.webp"
				alt="Summer of Making"
				style="width:60%;height:auto"
			/>
		</a>

		<a class="mini-card" href="https://campfire.hackclub.com" target="_blank" rel="noopener">
			<img
				class="mini-card-bg"
				src="https://cdn.hackclub.com/019d9226-09d7-7b90-909c-49086c91eb05/manifesto.hackclub.com__images__campfire-bg.png.webp"
				alt=""
			/>
			<img
				class="mini-card-logo"
				src="https://cdn.hackclub.com/019d9226-512f-7336-9bfe-8de2f6f8b21c/manifesto.hackclub.com__images__campfire-logo.png.webp"
				alt="Campfire"
				style="width:65%;height:auto"
			/>
		</a>

		<a
			class="mini-card"
			href="https://sleepover.hackclub.com"
			target="_blank"
			rel="noopener"
			style="background-color:#dbdcf7;background-image:url('https://cdn.hackclub.com/019d9219-39b9-7952-8e93-739a5f2852cd/manifesto.hackclub.com__images__sleepover-pattern.png.webp');background-repeat:repeat;background-size:112px"
		>
			<img
				class="mini-card-logo"
				src="https://cdn.hackclub.com/019d9226-7696-7f2d-8ad2-5680f8ddd281/manifesto.hackclub.com__images__sleepover-logo.png.webp"
				alt="Sleepover"
				style="width:60%;height:auto"
			/>
		</a>

		<a class="mini-card" href="https://overglade.hackclub.com" target="_blank" rel="noopener">
			<img
				class="mini-card-bg"
				src="https://cdn.hackclub.com/019d9226-2983-746c-8338-675ee8d43c87/manifesto.hackclub.com__images__overglade.png.webp"
				alt="Overglade"
			/>
		</a>

		<a
			class="mini-card"
			href="https://undercity.hackclub.com"
			target="_blank"
			rel="noopener"
			style="background:#171717"
		>
			<img
				class="mini-card-bg"
				src="https://cdn.hackclub.com/019d9226-3f61-7c44-821c-0454f6b9d375/manifesto.hackclub.com__images__undercity-bg.png.webp"
				alt=""
			/>
			<img
				class="mini-card-logo"
				src="https://cdn.hackclub.com/019d9226-91d6-7930-9cef-08d4b1ecfbbe/manifesto.hackclub.com__images__undercity-logo.png.webp"
				alt="Undercity"
				style="width:65%;height:auto"
			/>
		</a>

		<a class="mini-card" href="https://shiba.hackclub.com" target="_blank" rel="noopener">
			<img
				class="mini-card-bg"
				src="https://cdn.hackclub.com/019d9226-2fa5-736f-bb48-f4ccae39caab/manifesto.hackclub.com__images__shiba-bg.png.webp"
				alt=""
			/>
			<div class="mini-card-overlay"></div>
			<img
				class="mini-card-logo"
				src="https://cdn.hackclub.com/019d9226-6b1f-7bcd-b8e6-7109ef124067/manifesto.hackclub.com__images__shiba-logo.png.webp"
				alt="Shiba Arcade"
				style="width:308px;max-width:80%;height:auto;opacity:0.8;filter:drop-shadow(0 0 80px white)"
			/>
		</a>

		<a class="mini-card" href="https://hackpad.hackclub.com" target="_blank" rel="noopener">
			<img
				class="mini-card-bg"
				src="https://cdn.hackclub.com/019d9226-0c75-75c8-abac-620f1e8975e4/manifesto.hackclub.com__images__hackpad-bg.png.webp"
				alt=""
			/>
			<img
				class="mini-card-logo"
				src="https://cdn.hackclub.com/019d9226-5507-7f24-9a1b-3cca3a1b8069/manifesto.hackclub.com__images__hackpad-logo.png.webp"
				alt="Hackpad"
				style="width:65%;height:auto"
			/>
		</a>

		<a class="mini-card" href="https://horizons.hackclub.com" target="_blank" rel="noopener">
			<img
				class="mini-card-bg"
				src="https://cdn.hackclub.com/019d9226-10bc-71f8-af20-b10cc75e8ce1/manifesto.hackclub.com__images__horizons-bg.png.webp"
				alt=""
			/>
			<img
				class="mini-card-logo"
				src="https://cdn.hackclub.com/019d9226-5e01-7b26-b441-a18dffc493a8/manifesto.hackclub.com__images__horizons-logo.png.webp"
				alt="Horizons"
				style="width:100%;height:auto"
			/>
		</a>
	</div>
</section>

<section class="blogs">
	<h1 class="stitle">Here's what Hack Clubbers have to say:</h1>
	<a
		href="https://journal.tongyu.fish/gapyear/"
		target="_blank"
		rel="noopener noreferrer"
		class="notes-card"
	>
		<img
			class="notes-card-photo"
			src="https://cdn.hackclub.com/019d9226-c92a-7593-a762-823597d286d5/manifesto.hackclub.com__images__notes-tongyu.jpg.webp"
			alt="Tongyu"
		/>
		<div class="notes-card-text">
			<p class="notes-card-title">this is why you should do a hack club gap year. →</p>
			<p class="notes-card-author">Written by Tongyu, 2025-26 Gap Year</p>
		</div>
	</a>

	<a
		href="https://notes.deven.dev/posts/the-plan-for-hack-club-world-dominance"
		class="notes-card"
		target="_blank"
	>
		<img
			class="notes-card-photo"
			src="https://cdn.hackclub.com/019d9226-c0e1-7eee-87a3-7ee3991d6d58/cdn.hackclub.com__019d7609-92c0-7e58-8b43-c91362db8aa9__image_720-4.png.webp"
			alt="Deven"
		/>
		<div class="notes-card-text">
			<p class="notes-card-title">
				The plan for hack club world dominance <span class="notes-card-subtitle"
					>(rundown on Hack Club!)</span
				> →
			</p>
			<p class="notes-card-author">Written by Deven, YSWS Lead @ Hack Club</p>
		</div>
	</a>
</section>

<section class="hwyd-section">
	<h2 class="title">
		Here's what <i><span style="font-family: Garamond; font-weight: bold">you'll</span></i> do.
	</h2>
	<div class="hwyd-panel">
		<img
			class="panel-img left"
			alt="Collage of Hack Club events"
			src="https://cdn.hackclub.com/019d9226-981a-7067-946a-34432f31f525/cdn.hackclub.com__019d6191-88a7-7daa-b4c0-fdcae2fffa38__attend_hc_events.png.webp"
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
				You'll have full control over our social media presence across YouTube, Instagram, TikTok,
				Twitter, and more, to post about all the amazing people you'll meet.
			</p>
		</div>
		<img
			class="panel-img right"
			alt="Collage of Hack Clubbers doing media"
			src="https://cdn.hackclub.com/019d9306-76c7-7eff-8f6f-b56626d85f4e/run-our-social-media.png"
		/>
	</div>
	<div class="hwyd-panel">
		<img class="panel-img left" alt="Hack Club gap year teenagers" src="/gap-years.webp" />
		<div class="panel-text right">
			<h3 class="stitle">Join 40 other teenage gap years</h3>
			<p class="sbody">
				You'll join 40 technical teenage <a
					href="https://manifesto.hackclub.com"
					target="_blank"
					rel="noopener noreferrer"
					style="text-decoration: underline; color: inherit;">gap years</a
				> from across the USA and world who design and run all of Hack Club's programs. Every program
				above was ran by 18 and 19 year old gap years at Hack Club.
			</p>
		</div>
	</div>
</section>

<section class="cta-section">
	<h1 class="title">The door is open.</h1>
	<div class="vbutton-container">
		<div class="button">
			<a href="https://forms.hackclub.com/mediafellowship" class="apply-button"
				>Apply Now ({daysUntilDue} days remaining)</a
			>
		</div>
		<div class="button">
			<a id="linkButton" href={novella}>A note from the designers ↗</a>
		</div>
	</div>
</section>

<section class="footer">
	<p>
		© 2026 <u><a href="https://hackclub.com">Hack Club</a></u>. 501(c)(3) nonprofit (EIN:
		81-2908499)
	</p>
	<p>
		made with &lt;3 by <u><a href="https://github.com/maxstellar">maxstellar</a></u>,
		<u><a href="https://github.com/sadeshmukh">sadeshmukh</a></u>,
		<u><a href="https://github.com/hellonearth311">hellonearth311</a></u>,
		<u><a href="https://github.com/astra-the-boop">astra celestine</a></u>, and
		<u><a href="https://github.com/mntrushmore">rushmore</a></u>.
		<u><a href="https://github.com/hackclub/novella">always OSS</a>.</u>
		<br />
		heavily inspired by
		<u><a href="https://manifesto.hackclub.com/">manifesto</a></u>
		and
		<u><a href="https://github.com/techpixel">manitej</a></u>.
	</p>
</section>
