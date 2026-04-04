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

