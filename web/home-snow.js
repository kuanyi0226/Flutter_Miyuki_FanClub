(() => {
  const host = document.getElementById('flutter-app');
  const snow = document.getElementById('home-snow');
  const mobileViewport = window.matchMedia('(max-width: 700px)');
  let active = false;
  let timer;

  function refreshSnow() {
    clearTimeout(timer);
    if (!active || document.hidden || mobileViewport.matches) {
      snow.hidden = true;
      return;
    }

    const now = new Date();
    const minute = now.getMinutes() % 30;
    const snowing = minute === 0;
    snow.hidden = !snowing;

    if (snowing && !snow.firstChild) {
      const flakes = document.createDocumentFragment();
      for (let index = 0; index < 28; index++) {
        const flake = document.createElement('span');
        flake.style.left = `${(index * 37 + 3) % 100}%`;
        flake.style.setProperty('--size', `${2 + index % 4}px`);
        flake.style.setProperty('--drift', `${(index % 7 - 3) * 10}px`);
        flake.style.setProperty('--duration', `${8 + index % 7}s`);
        flake.style.setProperty('--delay', `-${index % 11}s`);
        flakes.append(flake);
      }
      snow.append(flakes);
    }

    const remainingMinutes = snowing ? 1 : 30 - minute;
    const remainingMs =
      (remainingMinutes * 60 - now.getSeconds()) * 1000 - now.getMilliseconds();
    timer = setTimeout(refreshSnow, remainingMs);
  }

  window.setYukiHomeLayout = (showHome) => {
    active = showHome;
    document.documentElement.classList.toggle('home-layout', active);
    document.body.classList.toggle('home-layout', active);
    host.classList.toggle('home-layout', active);
    refreshSnow();
  };

  document.addEventListener('visibilitychange', refreshSnow);
  mobileViewport.addEventListener('change', refreshSnow);
})();
