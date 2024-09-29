'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.json": "3aa53ac2a85e302598921ad8a5d9b1cc",
"assets/assets/svgs/filter.svg": "1af857758c59d277c7d55a81298a4345",
"assets/assets/svgs/option.svg": "1f3c8600d0af14ffeca86e80d4080cfa",
"assets/assets/svgs/arrow_back.svg": "0c2d9cb1bbccd8925dee92856166f1b5",
"assets/assets/svgs/star.svg": "362c06d30eba0cea08e7c231aaae823f",
"assets/assets/svgs/article.svg": "62680ae2bbabc411658228bdcc0e8dfb",
"assets/assets/svgs/excretion.svg": "c1806a033fce03eecd116b02aba2d30d",
"assets/assets/svgs/home.svg": "798da989f260abb352e64203f97470cd",
"assets/assets/svgs/password_hide.svg": "028d22fe268ea836a7057931d7d69110",
"assets/assets/svgs/edit.svg": "79298c9721aeaca4d60dbaffa40e4d17",
"assets/assets/svgs/login_logo.svg": "bb5ba91706ee85859ca1bc63a358dd5f",
"assets/assets/svgs/home_seleted.svg": "f7671d893b4051414025fb331ac2bf07",
"assets/assets/svgs/account_seleted.svg": "3372d53715af6c3d1ad1c8653d31e5c0",
"assets/assets/svgs/diet.svg": "3f6d0812c62896022d2388493d305804",
"assets/assets/svgs/arrow_enter.svg": "f94c75900051895c2006bfa1f9a33c2a",
"assets/assets/svgs/files.txt": "69e27506ae31cc2fbaa7613817d37367",
"assets/assets/svgs/dialog.svg": "5b2006c090a8db66ec4e567893091076",
"assets/assets/svgs/profile_button.svg": "49743302ecf93818fff6a08f64c73751",
"assets/assets/svgs/copy.svg": "4ed595b179b030839fd5abc73270e4bb",
"assets/assets/svgs/notification_button.svg": "380e9c550e9650ff70fdd7a7ebe52c26",
"assets/assets/svgs/account.svg": "3d461351839e9e77f2bc2632394e9337",
"assets/assets/svgs/about_button.svg": "08eb4a93677f540247a3b01f91978645",
"assets/assets/svgs/menu.svg": "0a3de61b5c620058fe367c5a7f340b6d",
"assets/assets/svgs/map.svg": "1a5b94609e0739fed738fe52fa558156",
"assets/assets/svgs/comment.svg": "5eb8dddfabbd9b85419d85ce4b5ac62b",
"assets/assets/svgs/password_show.svg": "3137a82a55bbf88051de8feb150bb57c",
"assets/assets/svgs/load_logo.svg": "290c58c112fb04c637a270f60e86153a",
"assets/assets/svgs/male.svg": "0a3825f6832162420ebdfd2571c58fab",
"assets/assets/svgs/social_seleted.svg": "5fbac0574ba909c18eafd76a5dc931c4",
"assets/assets/svgs/female.svg": "fd18cfc2778b1d899dbbab3a5b81553c",
"assets/assets/svgs/medical.svg": "401b6abb5495ad0afb19c5dce7eaa170",
"assets/assets/svgs/logout_button.svg": "fc133a7f151fbe96e511f91513439141",
"assets/assets/svgs/background_effect.svg": "21967ca9ab3a779e58749f068f490cd9",
"assets/assets/svgs/notification.svg": "47a93968d92a4cc0148ba50bc5534e83",
"assets/assets/svgs/delete.svg": "e6adfce99479a9d5db875a1e8118beec",
"assets/assets/svgs/vaccine.svg": "c6e9fd30ec692cae5f8b9b08417df2e5",
"assets/assets/svgs/find_place_seleted.svg": "da95a1c8a40ce811b38a80a5b53c195c",
"assets/assets/svgs/social.svg": "f0224c44213f7488dc839ad2a22a1d5c",
"assets/assets/svgs/management.svg": "d0be1ba0a7e7a7de57029092f76d7e1e",
"assets/assets/svgs/arrow_down.svg": "413714ed8ec7c28d06ff92860a50475e",
"assets/assets/svgs/send.svg": "43d05d55b1f332d6327a67f999cafbdd",
"assets/assets/svgs/find_place.svg": "52f9a13d1f84f737b913732f95db5b41",
"assets/assets/svgs/drug.svg": "f64faa166b21c35ead24c58b9799e6fd",
"assets/assets/images/pet_avator.png": "6928008cb2c71f8f3ff22357755fadf2",
"assets/assets/images/logo.png": "86f4f2c43f4333f5076e47c0d7e4141a",
"assets/assets/images/cat.jpg": "8347d4d88870de9849cf089d2a75e0f9",
"assets/assets/images/pet_photo.png": "98a8c49006f8996fe4b3b620a7aae5ee",
"assets/assets/images/dog.jpg": "1addf9fff8aa2cec637091b3446cb927",
"assets/assets/images/no_comments.png": "c0ed31d48a0ab649687b3bd752ec4f3e",
"assets/assets/images/hamster.jpg": "ffc75033cac88add6ad23e6a013f0204",
"assets/assets/images/load_logo.jpg": "5c7240336a24fdc374cfa08aff9248b9",
"assets/assets/images/user_avatar.png": "94acb2b2d905c0b2827048cdfd3a3f77",
"assets/assets/images/no_results.png": "db7319da12c0d8b583dcaabe5b9a2ce2",
"assets/assets/images/add_photo.png": "66301d83d7ba15f320c9940a638293a3",
"assets/assets/images/empty_data.png": "e04720ba60ae4f05bea24f97e22ffd37",
"assets/AssetManifest.bin.json": "e022c08e98b2f4adf655527772a3984d",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "84193485be3a916c632bbab12a9fde8f",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "943887415f7918533f2709c046c5232e",
"assets/fonts/MaterialIcons-Regular.otf": "8ffad03be6eeba65b777bbaf793d592e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"main.dart.js": "527289ce7d91fba96fb3f11233151a65",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"flutter_bootstrap.js": "7319e622bf018214eee693b17ecd8f15",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"index.html": "2bbc0008085a986e9662ef27571d6707",
"/": "2bbc0008085a986e9662ef27571d6707",
"version.json": "1ec4c375f64d09b5e9814c227830f5d0",
"manifest.json": "777740f069799b4446c621c0a387ff81"};
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
