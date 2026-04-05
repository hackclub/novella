<script lang="ts">
  import { browser } from '$app/environment';
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

  const INITIAL_TITLE = 'tell our stories.';
  const INITIAL_BODY =
    "Hack Club is hiring 2 teenagers for a paid gap year to create videos, films, and other content for Hack Club's social media.";

  const NEXT_TITLE = '';
  const NEXT_BODY =
    "Hack Club is an international nonprofit organization of teenagers who code together. We're also a community, run by teenagers for teenagers, full of amazing people and amazing stories--and we're looking for you to tell them.";

  const TEXT_EFFECT_START_PX = 28;
  const TEXT_EFFECT_RANGE_PX = 420;
  const FALLBACK_SCROLL_SENSITIVITY = 0.0016;
  const KEYBOARD_SCROLL_STEP = 0.11;
  const FADE_PHASE_PORTION = 0.42;

  let scrollProgress = $state(0);
  let fallbackProgress = 0;
  let touchStartY = 0;

  function prefersReducedMotion() {
    if (!browser) return false;
    return window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  }

  function clamp(value: number, min: number, max: number) {
    return Math.min(max, Math.max(min, value));
  }

  function getScrollDrivenState(progress: number, initialText: string, nextText: string) {
    if (prefersReducedMotion()) {
      return {
        text: progress < 0.5 ? initialText : nextText,
        opacity: 1,
        typing: false
      };
    }

    if (progress <= FADE_PHASE_PORTION) {
      const fade = clamp(1 - progress / FADE_PHASE_PORTION, 0, 1);
      return {
        text: initialText,
        opacity: fade,
        typing: false
      };
    }

    const typeProgress = clamp((progress - FADE_PHASE_PORTION) / (1 - FADE_PHASE_PORTION), 0, 1);
    const visibleChars = Math.round(nextText.length * typeProgress);

    return {
      text: nextText.slice(0, visibleChars),
      opacity: clamp(typeProgress, 0.12, 1),
      typing: visibleChars > 0 && visibleChars < nextText.length
    };
  }

  const titleState = $derived(getScrollDrivenState(scrollProgress, INITIAL_TITLE, NEXT_TITLE));
  const bodyState = $derived(getScrollDrivenState(scrollProgress, INITIAL_BODY, NEXT_BODY));

  function getMaxScrollableDistance() {
    return document.documentElement.scrollHeight - window.innerHeight;
  }

  function pageCanActuallyScroll() {
    return getMaxScrollableDistance() > 2;
  }

  function syncProgressFromPageScroll() {
    const maxScrollable = getMaxScrollableDistance();
    if (maxScrollable <= 2) {
      scrollProgress = fallbackProgress;
      return;
    }

    const startOffset = Math.min(TEXT_EFFECT_START_PX, maxScrollable * 0.2);
    const range = Math.min(TEXT_EFFECT_RANGE_PX, Math.max(180, maxScrollable * 0.85));
    scrollProgress = clamp((window.scrollY - startOffset) / range, 0, 1);
    fallbackProgress = scrollProgress;
  }

  function nudgeFallbackProgress(delta: number) {
    if (pageCanActuallyScroll()) return;
    fallbackProgress = clamp(fallbackProgress + delta, 0, 1);
    scrollProgress = fallbackProgress;
  }

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

    const onScroll = () => syncProgressFromPageScroll();

    const onWheel = (event: WheelEvent) => {
      nudgeFallbackProgress(event.deltaY * FALLBACK_SCROLL_SENSITIVITY);
    };

    const onTouchStart = (event: TouchEvent) => {
      touchStartY = event.touches[0]?.clientY ?? 0;
    };

    const onTouchMove = (event: TouchEvent) => {
      const currentY = event.touches[0]?.clientY ?? touchStartY;
      const swipeDelta = touchStartY - currentY;
      nudgeFallbackProgress(swipeDelta * 0.004);
      touchStartY = currentY;
    };

    const onKeyDown = (event: KeyboardEvent) => {
      const target = event.target as HTMLElement | null;
      if (target?.tagName === 'INPUT' || target?.tagName === 'TEXTAREA' || target?.isContentEditable) {
        return;
      }

      if (event.key === 'ArrowDown' || event.key === 'PageDown' || event.key === ' ') {
        nudgeFallbackProgress(KEYBOARD_SCROLL_STEP);
      }

      if (event.key === 'ArrowUp' || event.key === 'PageUp') {
        nudgeFallbackProgress(-KEYBOARD_SCROLL_STEP);
      }
    };

    window.addEventListener('scroll', onScroll, { passive: true });
    window.addEventListener('wheel', onWheel, { passive: true });
    window.addEventListener('touchstart', onTouchStart, { passive: true });
    window.addEventListener('touchmove', onTouchMove, { passive: true });
    window.addEventListener('keydown', onKeyDown);
    onScroll();

    return () => {
      stopTop();
      stopBottom();
      window.removeEventListener('scroll', onScroll);
      window.removeEventListener('wheel', onWheel);
      window.removeEventListener('touchstart', onTouchStart);
      window.removeEventListener('touchmove', onTouchMove);
      window.removeEventListener('keydown', onKeyDown);
    };
  });
</script>

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
      <h1 id="title" class:typing={titleState.typing} style={`opacity: ${titleState.opacity};`}>{titleState.text}</h1>
      <p id="body" class:typing={bodyState.typing} style={`opacity: ${bodyState.opacity};`}>{bodyState.text}</p>
    </div>

      <div class="button"><a id="applyButton" href="https://example.com">Apply Now (x days remaining)</a></div>
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
</div>

