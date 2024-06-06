'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"manifest.json": "777740f069799b4446c621c0a387ff81",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter_bootstrap.js": "a2980c05f20156c9c34d512cab79ed16",
"version.json": "1ec4c375f64d09b5e9814c227830f5d0",
"index.html": "850721e2992ff4bc2f1e67edab581f1f",
"/": "850721e2992ff4bc2f1e67edab581f1f",
"main.dart.js": "e2651b7688dcf3c4274d041927f1e139",
"assets/AssetManifest.json": "ba383bccd8de7367365d995b9d930822",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "7eee4193e9d3de75c0fac8b5e7de98c4",
"assets/fonts/MaterialIcons-Regular.otf": "47c46f4d8b150720086439ba614a39a1",
"assets/assets/images/map.jpg": "6c86dd5f01b7f7a25600a3c1bf5e1d8f",
"assets/assets/images/dog.jpg": "1addf9fff8aa2cec637091b3446cb927",
"assets/assets/images/hamster.jpg": "ffc75033cac88add6ad23e6a013f0204",
"assets/assets/images/cat.jpg": "8347d4d88870de9849cf089d2a75e0f9",
"assets/assets/svgs/notification.svg": "e4d8c2b15bab75acf8d7e1339f97fb60",
"assets/assets/svgs/about_button.svg": "08eb4a93677f540247a3b01f91978645",
"assets/assets/svgs/vaccine.svg": "1cf37abf1b085f9eacbd50e42819ad4b",
"assets/assets/svgs/search_seleted.svg": "e26b574c1677fff08a653b22fc036086",
"assets/assets/svgs/password_hide.svg": "028d22fe268ea836a7057931d7d69110",
"assets/assets/svgs/account_seleted.svg": "3372d53715af6c3d1ad1c8653d31e5c0",
"assets/assets/svgs/map_sample.svg": "ed73122f7ab1d013dcce7e5a8262ceba",
"assets/assets/svgs/medicald.svg": "a792b2aea0317949c2b19a94ee4fe8b5",
"assets/assets/svgs/logout_button.svg": "fc133a7f151fbe96e511f91513439141",
"assets/assets/svgs/account.svg": "3d461351839e9e77f2bc2632394e9337",
"assets/assets/svgs/arrow_back.svg": "28ff079f68fe010e6cde744d4701ccba",
"assets/assets/svgs/search.svg": "ef89135f66d0abe7f5f8d175f0534c60",
"assets/assets/svgs/profile_button.svg": "49743302ecf93818fff6a08f64c73751",
"assets/assets/svgs/home_seleted.svg": "21a189006f32855f87a20424ecb3a05b",
"assets/assets/svgs/social.svg": "5c2979e5a3a4adbc15b48c59b81b20ef",
"assets/assets/svgs/map.svg": "1a5b94609e0739fed738fe52fa558156",
"assets/assets/svgs/drug.svg": "4bf3c197cc7ab85f5327000672bfb853",
"assets/assets/svgs/dialog.svg": "5b2006c090a8db66ec4e567893091076",
"assets/assets/svgs/diet.svg": "1868e595a4bf27dc1f11ff6da6a8b63c",
"assets/assets/svgs/home.svg": "fd9a152333242bc2121cb5aba2eb42cd",
"assets/assets/svgs/files.txt": "554c8ce1e532b5364ce9185b030c6161",
"assets/assets/svgs/load_logo.svg": "290c58c112fb04c637a270f60e86153a",
"assets/assets/svgs/password_show.svg": "3137a82a55bbf88051de8feb150bb57c",
"assets/assets/svgs/star.svg": "362c06d30eba0cea08e7c231aaae823f",
"assets/assets/svgs/excretion.svg": "163ec78ae3c535653cf6ec2ee0251d10",
"assets/assets/svgs/social_seleted.svg": "3df94768bb19e367bd399bdc6c5d79c4",
"assets/assets/svgs/login_logo.svg": "bb5ba91706ee85859ca1bc63a358dd5f",
"assets/assets/svgs/notification_button.svg": "380e9c550e9650ff70fdd7a7ebe52c26",
"assets/NOTICES": "2c6cd14fbbb8d40b89d63a70f88639a7",
"assets/AssetManifest.bin": "54ff06399ecaabb129fdf8bf3234adfe",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
