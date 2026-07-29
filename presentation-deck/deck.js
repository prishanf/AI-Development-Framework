const slides = Array.from(document.querySelectorAll(".slide"));
const previousButton = document.querySelector("#prev");
const nextButton = document.querySelector("#next");
const slideTitle = document.querySelector("#slideTitle");
const slideCount = document.querySelector("#slideCount");
const progressBar = document.querySelector("#progressBar");
const actLabel = document.querySelector("#actLabel");
const actSep = document.querySelector("#actSep");
const overview = document.querySelector("#overview");

let current = 0;
let animating = false;
const ANIM_MS = 320;

function updateNav() {
  previousButton.disabled = current === 0;
  nextButton.disabled = current === slides.length - 1;

  const slide = slides[current];
  const act = slide.dataset.act || "";
  actLabel.textContent = act;
  actSep.textContent = act ? "·" : "";
  slideTitle.textContent = slide.dataset.title || `Slide ${current + 1}`;
  slideCount.textContent = `${current + 1} / ${slides.length}`;
  progressBar.style.width = `${((current + 1) / slides.length) * 100}%`;

  overview.querySelectorAll("button").forEach((b, i) =>
    b.classList.toggle("is-current", i === current));

  history.replaceState(null, "", `#slide-${current + 1}`);
}

function showSlide(index, direction) {
  const next = Math.max(0, Math.min(index, slides.length - 1));

  // No direction means initial render or a hash jump — skip the animation.
  if (direction === undefined) {
    slides.forEach((s, i) => s.classList.toggle("active", i === next));
    current = next;
    updateNav();
    return;
  }

  if (animating || next === current) return;
  animating = true;

  const prevSlide = slides[current];
  const nextSlide = slides[next];
  const exitClass = direction === "forward" ? "exit-forward" : "exit-backward";
  const enterClass = direction === "forward" ? "enter-forward" : "enter-backward";

  prevSlide.classList.remove("active");
  prevSlide.classList.add(exitClass);

  current = next;
  nextSlide.classList.add("active", enterClass);
  nextSlide.scrollTop = 0;
  updateNav();

  setTimeout(() => {
    prevSlide.classList.remove(exitClass);
    nextSlide.classList.remove(enterClass);
    animating = false;
  }, ANIM_MS);
}

function go(index) {
  if (index === current) return;
  showSlide(index, index > current ? "forward" : "backward");
}

function slideFromHash() {
  const m = window.location.hash.match(/^#slide-(\d+)$/);
  return m ? Math.max(0, Number(m[1]) - 1) : 0;
}

/* ── Overview grid ───────────────────────────────────────────────
   A 30-slide talk needs a way to jump. Built from the slides
   themselves so it can never drift out of sync with the deck. */
slides.forEach((slide, i) => {
  const button = document.createElement("button");
  button.type = "button";
  button.classList.toggle("is-act", slide.classList.contains("slide--act"));
  button.innerHTML =
    `<span class="n">${String(i + 1).padStart(2, "0")}</span>` +
    `<span class="t"></span>`;
  button.querySelector(".t").textContent = slide.dataset.title || `Slide ${i + 1}`;
  button.addEventListener("click", () => {
    overview.classList.remove("open");
    go(i);
  });
  overview.appendChild(button);
});

function toggleOverview(force) {
  const open = force === undefined ? !overview.classList.contains("open") : force;
  overview.classList.toggle("open", open);
  if (open) {
    overview.querySelector(".is-current")?.scrollIntoView({ block: "center" });
  }
}

previousButton.addEventListener("click", () => showSlide(current - 1, "backward"));
nextButton.addEventListener("click", () => showSlide(current + 1, "forward"));

document.addEventListener("keydown", (e) => {
  if (e.metaKey || e.ctrlKey || e.altKey) return;

  if (e.key === "Escape") {
    toggleOverview(false);
    return;
  }
  if (e.key === "o" || e.key === "O") {
    e.preventDefault();
    toggleOverview();
    return;
  }
  if (overview.classList.contains("open")) return;

  if (e.key === "ArrowRight" || e.key === "PageDown" || e.key === " ") {
    e.preventDefault();
    showSlide(current + 1, "forward");
  } else if (e.key === "ArrowLeft" || e.key === "PageUp") {
    e.preventDefault();
    showSlide(current - 1, "backward");
  } else if (e.key === "Home") {
    e.preventDefault();
    go(0);
  } else if (e.key === "End") {
    e.preventDefault();
    go(slides.length - 1);
  } else if (e.key === "f" || e.key === "F") {
    if (!document.fullscreenElement) document.documentElement.requestFullscreen?.();
    else document.exitFullscreen?.();
  }
});

/* Touch / swipe */
let touchStartX = 0;
let touchStartY = 0;

document.addEventListener("touchstart", (e) => {
  touchStartX = e.changedTouches[0].clientX;
  touchStartY = e.changedTouches[0].clientY;
}, { passive: true });

document.addEventListener("touchend", (e) => {
  const dx = e.changedTouches[0].clientX - touchStartX;
  const dy = e.changedTouches[0].clientY - touchStartY;
  if (Math.abs(dx) > Math.abs(dy) && Math.abs(dx) > 48) {
    showSlide(dx < 0 ? current + 1 : current - 1, dx < 0 ? "forward" : "backward");
  }
}, { passive: true });

window.addEventListener("hashchange", () => showSlide(slideFromHash()));

showSlide(slideFromHash());
