function setFavicon(): void {
  const lightFavicon: string = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAYAAADDPmHLAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAABgwAAAYMAVZP0FsAAAEYSURBVHhe7dtLCoNAAAXBSe5/53wwy2wykpGhq0B0J2jj5uEAAAAAAAAAAAAAAAAAALZyex2P45Iv3s9nxjbP9P45EyWAOAHECSBOAHECiBNAnADiBBAngDgBxAkgTgBxAog7MwfPTqX8x9R79AWIE0CcAOIEECeAOAHECSBOAHECiBNAnADiBBAngLgr1sAzP06uvudOi6c1kN8JIE4AcQKIE0CcAOIEECeAOAHECSBOAHECiBNAXGUN3MnS9+ELECeAOAHECSBOAHECiBNAnADiBBAngDgBxAkgTgBxu62Bq12xPloDWUcAcQKIE0CcAOIEECeAOAHECSBOAHECiBNAnADiBAAAAAAAAAAAAAAAAAAAsI0xnqj6DollzmTrAAAAAElFTkSuQmCC'; // Replace with your dark mode favicon in Base64 or URL
  const darkFavicon: string = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAYAAADDPmHLAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAABg0AAAYNAYQIMr8AAAEdSURBVHhe7dk7DsMgEEBBO/e/cz6Sq3TZKETozTSmQ5gnmj0AAAAAAAAAAAAAAAAAgK2c96drzZvz6Vp+ZKd/eru+RAkgTgBxAogTQJwA4gQQJ4A4AcQJIE4AcQKIE0CcAOLG4+DpqJTfmN6jFyBOAHECiBNAnADiBBAngDgBxAkgTgBxAogTQJwA4pZPA6f7vazec7rfP0zP6AWIE0CcAOIEECeAOAHECSBOAHECiBNAnADiBBAngLjENHAnq+/DCxAngDgBxAkgTgBxAogTQJwA4gQQJ4A4AcQJIE4AcVtNA1ebnvEbq+/DCxAngDgBxAkgTgBxAogTQJwA4gQQJ4A4AcQJIE4AcQIAAAAAAAAAAAAAAAAAANjGcTwAKVw4gAIO+0YAAAAASUVORK5CYII='; // Replace with your light mode favicon in Base64 or URL

  if (typeof document !== 'undefined' && typeof window !== 'undefined') {
    // Select the favicon link element or create one if it doesn't exist
    const favicon: HTMLLinkElement =
      document.querySelector<HTMLLinkElement>('link[rel="icon"]') ||
      (() => {
        const newFavicon = document.createElement('link');
        newFavicon.rel = 'icon';
        newFavicon.type = 'image/png';
        document.head.appendChild(newFavicon);
        return newFavicon;
      })();

    // Check the current color scheme preference
    if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
      favicon.href = darkFavicon;
    } else {
      favicon.href = lightFavicon;
    }
  }
}

// Call the function on the client side only
if (typeof window !== 'undefined') {
  window.addEventListener('DOMContentLoaded', () => {
    setFavicon();
  });
}
